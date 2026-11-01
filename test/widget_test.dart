import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eshaq_portfolio/data.dart';
import 'package:eshaq_portfolio/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late String content;
  setUpAll(() async => content = jsonEncode((await PortfolioData.load()).raw));
  for (final width in [320.0, 390.0, 1000.0]) {
    testWidgets('navigation, search and theme work at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final data = PortfolioData(jsonDecode(content) as Item);
      for (final p in data.projects) {
        if ((p['img'] as String).startsWith('http')) {
          p['img'] = data.text('portrait');
        }
      }
      await tester.pumpWidget(PortfolioApp(data: data));
      await tester.pumpAndSettle();
      expect(find.text('A curious mind.\nA builder’s heart.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Work').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'sms');
      await tester.pumpAndSettle();
      expect(find.text('1 projects'), findsOneWidget);
      expect(find.text('SMS PREDICTOR'), findsOneWidget);
      await tester.tap(find.text('Hackathon').last);
      await tester.pumpAndSettle();
      expect(
        find.text('No projects found. Try another keyword or category.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Awards').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Achievements').last);
      await tester.pumpAndSettle();
      expect(find.text('5 certificates'), findsOneWidget);
      await tester.tap(find.byTooltip('Contact Eshaq'));
      await tester.pumpAndSettle();
      expect(find.text('mdsohel46940@gmail.com'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Switch to dark theme'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Switch to light theme'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
