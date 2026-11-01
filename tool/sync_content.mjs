// Run from any directory: node portfolio_flutter/tool/sync_content.mjs
// Copies the website's content into a standalone, offline-capable app bundle.
import fs from 'node:fs';
import path from 'node:path';
import vm from 'node:vm';
import { fileURLToPath } from 'node:url';

const app = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const root = path.resolve(app, '..');
const media = path.join(app, 'assets', 'media');
fs.mkdirSync(media, { recursive: true });
const modules = new Map();
function readModule(file) {
  file = path.resolve(file);
  if (modules.has(file)) return modules.get(file);
  let source = fs.readFileSync(file, 'utf8');
  const bindings = {};
  source = source.replace(/import\s+([^;]+?)\s+from\s+["']([^"']+)["'];/g, (_, names, relative) => {
    const target = path.resolve(path.dirname(file), relative);
    if (relative.endsWith('.js')) {
      const data = readModule(target);
      for (const name of names.replace(/[{}]/g, '').split(',').map(s => s.trim())) bindings[name] = data[name];
    } else {
      const relativeAsset = path.relative(path.join(root, 'src', 'assets'), target).split(path.sep).join('/');
      const destination = path.join(media, relativeAsset);
      fs.mkdirSync(path.dirname(destination), { recursive: true });
      fs.copyFileSync(target, destination);
      bindings[names.trim()] = `assets/media/${relativeAsset}`;
    }
    return '';
  });
  const exports = [...source.matchAll(/export const (\w+)/g)].map(m => m[1]);
  source = source.replaceAll('export const ', 'const ');
  const result = vm.runInNewContext(`${source}\n;({${exports.join(',')}})`, bindings, { timeout: 1000 });
  modules.set(file, result);
  return result;
}
const projects = readModule(path.join(root, 'src/data/projects.js'));
const about = readModule(path.join(root, 'src/data/about.js'));
const { certificates } = readModule(path.join(root, 'src/data/certificates.js'));
// Connect.jsx contains JSX after these two data declarations; only evaluate the declarations.
const connectSource = fs.readFileSync(path.join(root, 'src/pages/Connect.jsx'), 'utf8');
const connectBindings = {};
for (const [, name, relative] of connectSource.matchAll(/import (\w+) from "(\.\.\/assets\/[^\"]+)";/g)) {
  const target = path.resolve(root, 'src/pages', relative);
  const relativeAsset = path.relative(path.join(root, 'src/assets'), target).split(path.sep).join('/');
  const destination = path.join(media, relativeAsset);
  fs.mkdirSync(path.dirname(destination), { recursive: true });
  fs.copyFileSync(target, destination);
  connectBindings[name] = `assets/media/${relativeAsset}`;
}
const declarations = connectSource.slice(connectSource.indexOf('const socials ='), connectSource.indexOf('export default'));
const connect = vm.runInNewContext(`${declarations};({socials,resumes})`, connectBindings, { timeout: 1000 });
const data = {
  name: 'Md Khaja Eshaq', email: 'mdsohel46940@gmail.com', phone: '+917396987687',
  location: 'Visakhapatnam, India', website: 'https://www.eshaq.me/',
  portrait: 'assets/media/portraits/eshaq-portrait-960.webp',
  projects: [...projects.hackathonProjects.map(p => ({...p, category: 'Hackathon'})), ...projects.basicProjects.map(p => ({...p, category: 'Personal'}))],
  certificates, ...about, ...connect,
};
// Flutter's cross-platform image decoder does not guarantee AVIF support.
for (const project of data.projects) if (project.img.endsWith('.avif')) project.img = project.img.replace('.avif', '.png');
fs.writeFileSync(path.join(app, 'assets/portfolio.json'), JSON.stringify(data, null, 2) + '\n');
console.log(`Synced ${data.projects.length} projects, ${certificates.length} certificates, ${data.resumes.length} resumes. Convert tic tac.avif to tic tac.png after syncing (see README).`);
