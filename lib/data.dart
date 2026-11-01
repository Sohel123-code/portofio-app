import 'dart:convert';

import 'package:flutter/services.dart';

typedef Item = Map<String, dynamic>;

class PortfolioData {
  PortfolioData(this.raw);
  final Item raw;
  static Future<PortfolioData> load() async => PortfolioData(
    jsonDecode(await rootBundle.loadString('assets/portfolio.json')) as Item,
  );
  String text(String key) => raw[key] as String;
  List<Item> items(String key) => (raw[key] as List).cast<Item>();
  List<Item> get projects => items('projects');
  List<Item> get certificates => items('certificates');
}

List<Item> filterProjects(List<Item> projects, String query, String category) {
  final needle = query.trim().toLowerCase();
  return projects.where((p) {
    final matchesCategory = category == 'All' || p['category'] == category;
    final searchable =
        '${p['title']} ${p['desc']} ${(p['tags'] as List).join(' ')}'
            .toLowerCase();
    return matchesCategory && searchable.contains(needle);
  }).toList();
}
