"""Regenerate code-drawn launcher marks; requires Pillow. Run from any folder."""
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

app = Path(__file__).resolve().parent.parent
canvas = Image.new('RGB', (1024, 1024), '#214b38')
draw = ImageDraw.Draw(canvas)
font = ImageFont.truetype(str(app / 'assets/fonts/Manrope.ttf'), 680)
draw.text((235, 32), 'e', font=font, fill='#f6f6ee')
draw.ellipse((680, 655, 788, 763), fill='#d3ee98')
for density, size in {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}.items():
    canvas.resize((size, size), Image.Resampling.LANCZOS).save(app / f'android/app/src/main/res/mipmap-{density}/ic_launcher.png')
icons = app / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for entry in json.loads((icons / 'Contents.json').read_text())['images']:
    size = round(float(entry['size'].split('x')[0]) * float(entry['scale'].replace('x', '')))
    canvas.resize((size, size), Image.Resampling.LANCZOS).save(icons / entry['filename'])
for size in [192, 512]:
    for name in [f'Icon-{size}.png', f'Icon-maskable-{size}.png']:
        canvas.resize((size, size), Image.Resampling.LANCZOS).save(app / 'web/icons' / name)
canvas.resize((32, 32), Image.Resampling.LANCZOS).save(app / 'web/favicon.png')
print('Updated Android, iOS and web launcher icons.')
