import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';
import 'screens.dart';
import 'theme.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key, this.data});
  final PortfolioData? data;
  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late Future<PortfolioData> content;
  ThemeMode mode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    content = widget.data == null
        ? PortfolioData.load()
        : Future.value(widget.data);
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dark = prefs.getBool('darkMode');
      if (mounted && dark != null) {
        setState(() => mode = dark ? ThemeMode.dark : ThemeMode.light);
      }
    } catch (_) {
      /* System theme works when preferences are unavailable. */
    }
  }

  void toggleTheme(bool currentlyDark) {
    setState(() => mode = currentlyDark ? ThemeMode.light : ThemeMode.dark);
    saveTheme(!currentlyDark);
  }

  Future<void> saveTheme(bool dark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('darkMode', dark);
    } catch (_) {
      /* Keep the session preference. */
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Eshaq • Portfolio',
    debugShowCheckedModeBanner: false,
    theme: portfolioTheme(Brightness.light),
    darkTheme: portfolioTheme(Brightness.dark),
    themeMode: mode,
    home: FutureBuilder<PortfolioData>(
      future: content,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PortfolioShell(data: snapshot.data!, toggleTheme: toggleTheme);
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not load the portfolio.'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        setState(() => content = PortfolioData.load()),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  );
}

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({
    super.key,
    required this.data,
    required this.toggleTheme,
  });
  final PortfolioData data;
  final ValueChanged<bool> toggleTheme;
  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  int selected = 0;
  void select(int index) => setState(() => selected = index);
  void contact() => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => ContactScreen(data: widget.data)),
  );
  static const labels = ['Home', 'About', 'Work', 'Awards', 'Connect'];
  static const icons = [
    Icons.home_outlined,
    Icons.person_outline,
    Icons.grid_view_outlined,
    Icons.workspace_premium_outlined,
    Icons.alternate_email,
  ];
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final pages = [
      HomeScreen(data: widget.data, navigate: select, contact: contact),
      AboutScreen(data: widget.data),
      ProjectsScreen(data: widget.data),
      CertificatesScreen(data: widget.data),
      ConnectScreen(data: widget.data, contact: contact),
    ];
    return PopScope(
      canPop: selected == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) select(0);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'eshaq.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          actions: [
            IconButton(
              tooltip: dark ? 'Switch to light theme' : 'Switch to dark theme',
              onPressed: () => widget.toggleTheme(dark),
              icon: Icon(
                dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
            ),
            IconButton(
              tooltip: 'Contact Eshaq',
              onPressed: contact,
              icon: const Icon(Icons.chat_bubble_outline),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Row(
            children: [
              if (wide)
                NavigationRail(
                  selectedIndex: selected,
                  onDestinationSelected: select,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (var i = 0; i < labels.length; i++)
                      NavigationRailDestination(
                        icon: Icon(icons[i]),
                        label: Text(labels[i]),
                      ),
                  ],
                ),
              Expanded(
                child: IndexedStack(index: selected, children: pages),
              ),
            ],
          ),
        ),
        bottomNavigationBar: wide
            ? null
            : NavigationBar(
                selectedIndex: selected,
                onDestinationSelected: select,
                destinations: [
                  for (var i = 0; i < labels.length; i++)
                    NavigationDestination(
                      icon: Icon(icons[i]),
                      label: labels[i],
                    ),
                ],
              ),
      ),
    );
  }
}
