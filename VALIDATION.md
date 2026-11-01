# Validation — 1 November 2026

Validated with Flutter 3.47.9 / Dart 3.13.7 on Windows.

- `flutter analyze --no-pub`: no issues found.
- `flutter test --no-pub`: all 6 tests passed. Checks bundled content/assets, project search/category behavior, link URL structure, and navigation/contact/theme behavior at widths of 320, 390 and 1000 logical pixels.
- `flutter build web --release --no-pub --no-wasm-dry-run`: passed; output is in the ignored `build/web` folder.

The Android SDK is not installed on this computer, so no APK/AAB was built and Android signing/native integration has not been tested. iOS has not been built or tested on macOS. Before release, test PDFs, sharing, email/phone handlers and offline operation on an actual phone using the checklist in README.

Live browser visual inspection was unavailable: computer-use stopped because it could not reliably determine the active Chrome URL. Responsive layouts were checked by Flutter widget tests; no live-browser visual approval is claimed.

The website was not deployed or changed as part of this app task. The pre-existing edit to the parent `SEO-SETUP.md` was left intact.
