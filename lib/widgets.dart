import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';
import 'theme.dart';

void notice(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<void> openLink(BuildContext context, String value) async {
  try {
    if (await launchUrl(
      Uri.parse(value),
      mode: LaunchMode.externalApplication,
    )) {
      return;
    }
  } catch (_) {
    /* Offer a useful fallback when no app handles the URI. */
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Could not open this link on your device.'),
      action: SnackBarAction(
        label: 'Copy link',
        onPressed: () => Clipboard.setData(ClipboardData(text: value)),
      ),
    ),
  );
}

class PortfolioImage extends StatelessWidget {
  const PortfolioImage(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.label,
  });
  final String path;
  final BoxFit fit;
  final String? label;
  @override
  Widget build(BuildContext context) {
    Widget fallback(BuildContext context, Object error, StackTrace? stack) =>
        ColoredBox(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: const Center(child: Icon(Icons.auto_awesome, size: 40)),
        );
    return path.startsWith('http')
        ? Image.network(
            path,
            fit: fit,
            semanticLabel: label,
            errorBuilder: fallback,
          )
        : Image.asset(
            path,
            fit: fit,
            semanticLabel: label,
            errorBuilder: fallback,
          );
  }
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children, this.storageKey});
  final List<Widget> children;
  final String? storageKey;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: PageStorageKey(storageKey ?? 'page'),
    padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    ),
  );
}

class Heading extends StatelessWidget {
  const Heading(this.eyebrow, this.title, {super.key, this.description});
  final String eyebrow, title;
  final String? description;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✳  ${eyebrow.toUpperCase()}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 14),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        if (description != null) ...[
          const SizedBox(height: 12),
          Text(description!, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ],
    ),
  );
}

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(22),
  });
  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Material(
    color: color ?? Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(
        color: Theme.of(context).colorScheme.outlineVariant
            .withValues(alpha: .45),
      ),
    ),
    child: SizedBox(
      width: double.infinity,
      child: Padding(padding: padding, child: child),
    ),
  );
}

class Tags extends StatelessWidget {
  const Tags(this.tags, {super.key});
  final List<dynamic> tags;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 7,
    runSpacing: 7,
    children: tags
        .map(
          (tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer
                  .withValues(alpha: .5),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '$tag',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        )
        .toList(),
  );
}

class ResponsiveCards extends StatelessWidget {
  const ResponsiveCards({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 850
          ? 3
          : constraints.maxWidth >= 580
          ? 2
          : 1;
      final width = (constraints.maxWidth - 16 * (columns - 1)) / columns;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: children
            .map((child) => SizedBox(width: width, child: child))
            .toList(),
      );
    },
  );
}

class ProjectCard extends StatelessWidget {
  const ProjectCard(this.project, {super.key});
  final Item project;
  @override
  Widget build(BuildContext context) => Panel(
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: AspectRatio(
            aspectRatio: 1.65,
            child: PortfolioImage(
              project['img'] as String,
              label: project['title'] as String,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${project['category']} / PROJECT',
                style: const TextStyle(fontSize: 10, letterSpacing: 1.7),
              ),
              const SizedBox(height: 10),
              Text(
                project['title'] as String,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 9),
              Text(project['desc'] as String),
              const SizedBox(height: 16),
              Tags(project['tags'] as List),
              const SizedBox(height: 14),
              TextButton.icon(
                onPressed: () => openLink(context, project['link'] as String),
                icon: const Icon(Icons.north_east, size: 18),
                label: const Text('Explore project'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ContactBanner extends StatelessWidget {
  const ContactBanner({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Panel(
    color: forest,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LET’S BUILD SOMETHING GOOD',
          style: TextStyle(color: lime, fontSize: 10, letterSpacing: 1.6),
        ),
        const SizedBox(height: 12),
        Text(
          'A little code.\nA lot of possibility.',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: lime,
            foregroundColor: forest,
          ),
          onPressed: onTap,
          icon: const Icon(Icons.north_east),
          label: const Text('Let’s talk'),
        ),
      ],
    ),
  );
}
