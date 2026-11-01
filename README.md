# Eshaq — Flutter portfolio

A native Flutter companion to the React website in the parent folder. It carries over the cream, forest-green and lime palette, bundled DM Sans / Manrope fonts, portraits, biography, education, skills, 15 projects, 22 certificates, four résumés, and social/contact links.

## What is included

- Home, About, Work, Awards and Connect tabs, plus a separate Contact screen.
- Project search by title, description or technology, with project-category filters.
- Certificate category filters, in-app PDF previews, zoomable photos, and native document sharing/saving.
- Light/dark mode with a remembered preference; follows the system on first launch.
- Phone bottom navigation and a navigation rail on larger screens.
- Bundled content, photos, fonts and documents work offline on mobile. Two project thumbnails use the original Unsplash URLs and display a fallback offline. Opening external websites, email and phone actions needs a suitable app/connection.

The app is independent of the website's npm build. Changes here do not deploy or replace eshaq.me. Content is a snapshot: updating the website does not automatically update an installed app.

## First run on Windows / Android

**Prefer no local installation?** Use the [GitHub Actions instructions in DEPLOYMENT.md](DEPLOYMENT.md#build-online-with-github-actions-no-local-android-setup) to build an APK online and install it on your phone. The steps below are for local development.

1. Install the current stable [Flutter SDK](https://docs.flutter.dev/install) and add its `bin` folder to your user PATH. This project targets Flutter 3.47 or newer / Dart 3.13 or newer.
2. Install Android Studio and complete the [Android setup](https://docs.flutter.dev/platform-integration/android/setup), including the Android SDK, command-line tools, platform tools, and SDK tools required by `flutter doctor`. Android Studio includes a JDK.
3. Open this `portfolio_flutter` folder in VS Code with the Flutter extension, or Android Studio.
4. In PowerShell:

   ```powershell
   flutter doctor
   flutter doctor --android-licenses
   flutter pub get
   ```

5. On an Android phone, enable Developer options and USB debugging. Connect a data-capable USB cable and accept the phone's debugging prompt. Windows may need your phone manufacturer's USB driver.
6. Run:

   ```powershell
   flutter devices
   flutter run -d YOUR_DEVICE_ID
   ```

Use the ID from `flutter devices`. Alternatively start an emulator in Android Studio's Device Manager. The app supports Android 7.0 / API 24 and newer.

For a quick browser preview:

```powershell
flutter run -d chrome
```

Native phone integration still needs testing on a phone. Browser previews do not prove Android/iOS behavior.

The PDF renderer is pinned to `pdfrx 2.6.6` for predictable builds without an extra Windows C++ compiler for unit/widget tests. Review platform requirements before upgrading it.

### Local SDK used during development

An ignored SDK was downloaded at `../.cache/flutter-sdk`. If it is still present on this computer, you can use it for this terminal session without changing global settings:

```powershell
$env:PATH = "$(Resolve-Path ..\.cache\flutter-sdk\bin);$env:PATH"
$env:PUB_CACHE = "$(Resolve-Path ..\.cache\pub)"
flutter doctor
```

This cache is not committed and will not exist in a fresh clone. Install Flutter normally for ongoing development. Keeping a large SDK outside OneDrive is preferable.

## Build and deploy

See [DEPLOYMENT.md](DEPLOYMENT.md) for APK installation, release signing, Play Store publication, iPhone/TestFlight, and optional web hosting.

## Edit the app

| File | Purpose |
| --- | --- |
| `lib/main.dart` | Startup, theme preference, responsive navigation |
| `lib/theme.dart` | Website colors and typography |
| `lib/screens.dart` | Portfolio screens and filters |
| `lib/widgets.dart` | Shared layout, cards, external links |
| `lib/documents.dart` | PDF/image preview and share/save |
| `lib/data.dart` | Content loading and project filtering |
| `assets/portfolio.json` | Profile, projects, education, skills, certificates, résumé and social data |
| `assets/media/` | Copied website assets |
| `assets/fonts/` | Bundled fonts and their open-source licenses |

To refresh the content from the parent website, run from the repository root:

```powershell
node portfolio_flutter/tool/sync_content.mjs
python -m pip install Pillow
python -c "from PIL import Image; Image.open('portfolio_flutter/assets/media/tic tac.avif').save('portfolio_flutter/assets/media/tic tac.png')"
```

The script imports the site's data modules and the social/résumé declarations in `Connect.jsx`. It overwrites `assets/portfolio.json` and corresponding media files; preserve manual app-only data changes first. Contact details and the short home introduction are maintained in the app/sync script. AVIF is converted to PNG for portable Flutter image decoding. Nested asset directories must also be listed in `pubspec.yaml` if you add new directories.

## Verify changes

```powershell
dart format lib test
flutter analyze
flutter test
flutter build web --release
```

Before distributing a mobile build, check all tabs on a real device; project/category search; a PDF and an image certificate; résumé sharing; email and phone handlers; back navigation; dark mode after restarting; and content with airplane mode enabled.

See [VALIDATION.md](VALIDATION.md) for completed checks and remaining device verification.

No login, server, API keys or analytics service is required. The app opens the existing public links from the website.
