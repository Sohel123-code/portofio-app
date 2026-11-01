import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:eshaq_portfolio/data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PortfolioData data;
  setUpAll(() async => data = await PortfolioData.load());
  test('all portfolio assets referenced by the content exist', () async {
    Future<void> inspect(dynamic value) async {
      if (value is Map) {
        for (final entry in value.entries) {
          if (entry.key != 'srcSet') await inspect(entry.value);
        }
      }
      if (value is List) {
        for (final item in value) {
          await inspect(item);
        }
      }
      if (value is String && value.startsWith('assets/')) {
        expect(
          (await rootBundle.load(value)).lengthInBytes,
          greaterThan(0),
          reason: value,
        );
      }
    }

    await inspect(data.raw);
    expect(data.projects.length, 15);
    expect(data.certificates.length, 22);
    expect(data.items('resumes').length, 4);
  });
  test('project search combines category with case-insensitive title, description and tags', () {
    expect(
      filterProjects(data.projects, '  sms  ', 'All').single['title'],
      'SMS PREDICTOR',
    );
    expect(
      filterProjects(data.projects, 'python', 'Personal').single['title'],
      'SMS PREDICTOR',
    );
    expect(filterProjects(data.projects, 'python', 'Hackathon'), isEmpty);
    expect(filterProjects(data.projects, '', 'Hackathon').length, 7);
    expect(filterProjects(data.projects, 'missing-project', 'All'), isEmpty);
  });
  test('project and social links use absolute HTTPS URLs', () {
    for (final item in [...data.projects, ...data.items('socials')]) {
      final uri = Uri.parse(item['link'] as String);
      expect(uri.scheme, 'https');
      expect(uri.host, isNotEmpty);
    }
  });
}
