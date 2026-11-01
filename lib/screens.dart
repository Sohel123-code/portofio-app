import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'documents.dart';
import 'theme.dart';
import 'widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.data,
    required this.navigate,
    required this.contact,
  });
  final PortfolioData data;
  final ValueChanged<int> navigate;
  final VoidCallback contact;
  @override
  Widget build(BuildContext context) => PageBody(
    storageKey: 'home',
    children: [
      const Text(
        '●  HEY THERE, I’M MD KHAJA ESHAQ',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
      const SizedBox(height: 22),
      Text(
        'A curious mind.\nA builder’s heart.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: 17),
      const Text(
        'Aspiring AI/ML engineer × Creative problem solver',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 15),
      const Text(
        'I’m Md Khaja Eshaq, a Computer Science student in Visakhapatnam. I build AI/ML applications and web experiences that turn complex problems into useful, real-world solutions.',
      ),
      const SizedBox(height: 22),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          FilledButton.icon(
            onPressed: () => navigate(2),
            label: const Text('Explore my work'),
            icon: const Icon(Icons.north_east, size: 18),
          ),
          OutlinedButton.icon(
            onPressed: () => openDocument(
              context,
              'Main Resume',
              data.items('resumes').first['filePath'] as String,
            ),
            label: const Text('My résumé'),
            icon: const Icon(Icons.description_outlined, size: 18),
          ),
        ],
      ),
      const SizedBox(height: 30),
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Transform.rotate(
            angle: -.025,
            child: Panel(
              padding: const EdgeInsets.all(12),
              color: lime,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: Image.asset(
                        data.text('portrait'),
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -.65),
                        semanticLabel: 'Md Khaja Eshaq smiling in a blue suit',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 14, 5, 4),
                    child: Text(
                      'a little curiosity goes a long way.  ✳',
                      style: TextStyle(
                        color: forest,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 32),
      const Tags([
        'Python',
        'PyTorch',
        'Scikit-learn',
        'React',
        'OpenCV',
        'Generative AI',
      ]),
      const SizedBox(height: 32),
      Panel(
        child: Wrap(
          spacing: 32,
          runSpacing: 18,
          children: [
            _Stat('${data.projects.length}', 'Projects'),
            _Stat('${data.certificates.length}', 'Milestones'),
            const _Stat('9.80', '2nd sem SGPA'),
          ],
        ),
      ),
      const SizedBox(height: 36),
      const Heading('01 / Selected work', 'Small ideas. Real impact.'),
      ResponsiveCards(
        children: [
          for (final p in data.projects.where(
            (p) => [
              'ECOSPHERE',
              'CLEANSLATE',
              'SMS PREDICTOR',
            ].contains(p['title']),
          ))
            ProjectCard(p),
        ],
      ),
      const SizedBox(height: 15),
      TextButton.icon(
        onPressed: () => navigate(2),
        label: const Text('See all projects'),
        icon: const Icon(Icons.arrow_forward),
      ),
      const SizedBox(height: 24),
      const Heading(
        '02 / Beyond the code',
        'Forever a student.\nAlways a builder.',
        description: 'From training neural networks to bringing ideas to life at hackathons, I’m driven by the chance to make something useful.',
      ),
      OutlinedButton(
        onPressed: () => navigate(1),
        child: const Text('A little more about me'),
      ),
      const SizedBox(height: 32),
      ContactBanner(onTap: contact),
      const SizedBox(height: 24),
      const Center(child: Text('Learning. Building. Evolving.  ✳')),
    ],
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value, label;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: Theme.of(context).textTheme.headlineMedium),
      Text(label, style: const TextStyle(fontSize: 11)),
    ],
  );
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.data});
  final PortfolioData data;
  @override
  Widget build(BuildContext context) => PageBody(
    storageKey: 'about',
    children: [
      const Heading(
        'The human behind the work',
        'Curiosity is my\nstarting point.',
      ),
      for (final paragraph in data.items('sections').first['content'] as List)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            '$paragraph',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      const SizedBox(height: 20),
      const Heading('01 / The journey', 'Learning, one step at a time.'),
      for (final e in data.items('education'))
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.school_outlined),
                const SizedBox(height: 12),
                Text(
                  e['label'] as String,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 7),
                Text(
                  e['place'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 7),
                Text(e['desc'] as String),
              ],
            ),
          ),
        ),
      const SizedBox(height: 24),
      const Heading(
        '02 / My toolkit',
        'Built on curiosity.\nBacked by skills.',
      ),
      for (final s in data.items('skillCategories'))
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s['category'] as String,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 14),
                Tags(s['skills'] as List),
              ],
            ),
          ),
        ),
      const SizedBox(height: 24),
      const Heading('03 / Along the way', 'Little wins. Lasting lessons.'),
      for (final a in data.raw['achievements'] as List)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.stars_outlined),
          title: Text('$a'),
        ),
      const SizedBox(height: 28),
      const Heading('04 / In my element', 'A human behind the code.'),
      ResponsiveCards(
        children: [
          for (final photo in data.items('galleryPhotos'))
            Panel(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => openDocument(
                      context,
                      photo['caption'] as String,
                      photo['src'] as String,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                        aspectRatio: 1.1,
                        child: PortfolioImage(
                          photo['src'] as String,
                          label: photo['caption'] as String,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(photo['caption'] as String),
                  ),
                ],
              ),
            ),
        ],
      ),
    ],
  );
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key, required this.data});
  final PortfolioData data;
  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String query = '', category = 'All';
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = filterProjects(widget.data.projects, query, category);
    return PageBody(
      storageKey: 'projects',
      children: [
        const Heading(
          'Ideas into action',
          'Things I’ve built.',
          description: 'Experiments, hackathons, and useful solutions. Every project taught me something new.',
        ),
        TextField(
          controller: search,
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: 'Search projects or technology',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      search.clear();
                      setState(() => query = '');
                    },
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            for (final value in ['All', 'Hackathon', 'Personal'])
              ChoiceChip(
                label: Text(value),
                selected: category == value,
                onSelected: (_) => setState(() => category = value),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text('${results.length} projects'),
        const SizedBox(height: 16),
        if (results.isEmpty)
          const Panel(
            child: Text('No projects found. Try another keyword or category.'),
          ),
        ResponsiveCards(children: results.map(ProjectCard.new).toList()),
      ],
    );
  }
}

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key, required this.data});
  final PortfolioData data;
  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  String category = 'All';
  @override
  Widget build(BuildContext context) {
    final results = widget.data.certificates
        .where((c) => category == 'All' || c['category'] == category)
        .toList();
    return PageBody(
      storageKey: 'certificates',
      children: [
        const Heading(
          'Learning milestones',
          'The journey,\non paper.',
          description:
              'Courses, competitions, and experiences that helped me grow.',
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final value in [
              'All',
              'courses',
              'hackathons',
              'events',
              'achievements',
            ])
              ChoiceChip(
                label: Text('${value[0].toUpperCase()}${value.substring(1)}'),
                selected: value == category,
                onSelected: (_) => setState(() => category = value),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Text('${results.length} certificates'),
        const SizedBox(height: 18),
        ResponsiveCards(
          children: [
            for (final c in results)
              Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          c['fileType'] == 'pdf'
                              ? Icons.workspace_premium_outlined
                              : Icons.image_outlined,
                          size: 30,
                        ),
                        const Spacer(),
                        Text(
                          c['date'] as String,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      c['title'] as String,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      c['issuer'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(c['description'] as String),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => openDocument(
                        context,
                        c['title'] as String,
                        c['filePath'] as String,
                      ),
                      icon: const Icon(Icons.open_in_full, size: 17),
                      label: const Text('View certificate'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key, required this.data, required this.contact});
  final PortfolioData data;
  final VoidCallback contact;
  @override
  Widget build(BuildContext context) => PageBody(
    storageKey: 'connect',
    children: [
      const Heading(
        'Find me around the internet',
        'Good things happen\nwhen we connect.',
      ),
      for (final social in data.items('socials'))
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Panel(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: SizedBox(
                width: 36,
                height: 36,
                child: PortfolioImage(
                  social['img'] as String,
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(social['platform'] as String),
              subtitle: Text(social['desc'] as String),
              trailing: const Icon(Icons.north_east, size: 19),
              onTap: () => openLink(context, social['link'] as String),
            ),
          ),
        ),
      const SizedBox(height: 28),
      const Heading('The story on paper', 'A closer look at\nmy experience.'),
      ResponsiveCards(
        children: [
          for (final resume in data.items('resumes'))
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description_outlined, size: 32),
                  const SizedBox(height: 18),
                  Text(
                    resume['title'] as String,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  const Text('Md Khaja Eshaq · AI / ML · Development'),
                  const SizedBox(height: 14),
                  TextButton.icon(
                    onPressed: () => openDocument(
                      context,
                      resume['title'] as String,
                      resume['filePath'] as String,
                    ),
                    icon: const Icon(Icons.open_in_full, size: 17),
                    label: const Text('View & share résumé'),
                  ),
                ],
              ),
            ),
        ],
      ),
      const SizedBox(height: 28),
      ContactBanner(onTap: contact),
      const SizedBox(height: 16),
      TextButton.icon(
        onPressed: () => openLink(context, data.text('website')),
        icon: const Icon(Icons.language),
        label: const Text('Visit eshaq.me'),
      ),
    ],
  );
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key, required this.data});
  final PortfolioData data;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Say hello')),
    body: SafeArea(
      child: PageBody(
        storageKey: 'contact',
        children: [
          const Heading(
            'Say hello. Share an idea.',
            'Something on\nyour mind?',
            description: 'An interesting project, a collaboration, or just a good conversation — I’d love to hear from you.',
          ),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.alternate_email, size: 30),
                const SizedBox(height: 14),
                const Text(
                  'DROP ME A LINE',
                  style: TextStyle(fontSize: 10, letterSpacing: 1.5),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  data.text('email'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () =>
                          openLink(context, 'mailto:${data.text('email')}'),
                      icon: const Icon(Icons.north_east),
                      label: const Text('Write an email'),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: data.text('email')),
                        );
                        if (context.mounted) notice(context, 'Email copied!');
                      },
                      icon: const Icon(Icons.copy, size: 17),
                      label: const Text('Copy email'),
                    ),
                  ],
                ),
                const Divider(height: 36),
                const Icon(Icons.phone_outlined, size: 30),
                const SizedBox(height: 14),
                SelectableText(
                  '+91 73969 87687',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () =>
                      openLink(context, 'tel:${data.text('phone')}'),
                  icon: const Icon(Icons.call_outlined, size: 18),
                  label: const Text('Let’s talk'),
                ),
                const Divider(height: 28),
                Text(data.text('location')),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Heading(
            'Always happy to talk about',
            'Every great project starts\nwith a simple “hello.”',
          ),
          const Tags([
            'AI & Machine Learning',
            'Creative ideas',
            'Hackathons',
            'Collaboration',
          ]),
        ],
      ),
    ),
  );
}
