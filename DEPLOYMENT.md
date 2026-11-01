# Run, install and publish the Flutter portfolio

You can build online using GitHub Actions without installing Android Studio, Java, or the Android SDK on your computer. For local builds, commands below run from `portfolio_flutter`, not the parent React project; complete the Android setup in [README.md](README.md) first.

## Build online with GitHub Actions (no local Android setup)

The **Build Android APK** workflow is included in `.github/workflows/android-apk.yml`. A copy is also inside this app folder's `.github/workflows` so it works if you publish the app as a separate repository. Keep these two copies identical when editing the workflow in the full website repository. GitHub only runs workflows in the repository-root `.github/workflows` directory.

1. Create your GitHub repository and push the complete app, including `pubspec.lock`, `assets`, `android`, `lib`, `test`, and the hidden `.github` folder. You can push either this folder's contents as the repository root, or the entire parent portfolio repository. The workflow detects both layouts. Use Git rather than dragging only the visible files into GitHub; the existing ignore rules exclude local SDK caches, build outputs and signing secrets.
2. Open the repository on GitHub and select **Actions → Build Android APK**. Pushing app changes starts a build automatically.
3. To start a build yourself, select **Run workflow**, choose your branch, and click **Run workflow** again. The workflow must be on the repository's default branch for this manual button to appear.
4. Open the newest run and wait for **Build downloadable APK** to finish with a green check. The first run downloads Flutter and Android dependencies, so allow several minutes.
5. On that run's summary page, scroll to **Artifacts** and download **eshaq-portfolio-apk**. You must be signed in to GitHub and have access to the repository. Extract the downloaded ZIP to get **app-debug.apk**. Artifacts are retained for 14 days; run another build if one expires. See [GitHub's artifact download guide](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/download-workflow-artifacts).
6. Transfer `app-debug.apk` to your Android phone or download and extract it there. Open it in the phone's Files app and install it. Allow installation from that app if Android prompts. USB debugging is not required for this manual APK installation.

No signing secrets are required for this debug build. It is for personal testing, not Play Store publication. Fresh GitHub runners can generate different debug signing keys; if Android refuses to update an earlier test build, uninstall that test app first (clearing its preferences), then install the new APK.

If a run fails, open its red step and copy the error log. If no workflow appears, confirm `.github/workflows/android-apk.yml` exists at the **repository root** and Actions is enabled. The workflow has been checked locally but its first cloud/Android build still needs to run after you push.

## 1. Install on your own Android phone (easiest)

You do not need a Play Store account to use the app on your phone.

With USB debugging enabled and the phone connected:

```powershell
flutter pub get
flutter devices
flutter run -d YOUR_DEVICE_ID
```

This installs a development build. To create a file that you can copy to a phone:

```powershell
flutter build apk --debug
```

The file is `build/app/outputs/flutter-apk/app-debug.apk`. Transfer it to the phone and open it. Android may ask you to allow installation from the app used to open the APK. This is a development build, not a store release.

## 2. Create a signed release APK

The project contains release signing support in `android/app/build.gradle.kts`. Release builds require your private keystore and `android/key.properties`; they deliberately do not fall back to the debug key.

1. Create an upload keystore outside the repository. Run the following with Java's `keytool` on PATH (Android Studio's bundled JDK also contains it):

   ```powershell
   keytool -genkeypair -v -keystore "$env:USERPROFILE\eshaq-upload-keystore.jks" -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

   Enter the requested passwords and identity information interactively. Back up the keystore and passwords securely; use the same signing identity for future updates.

2. Copy `android/key.properties.example` to `android/key.properties` and fill in your own values:

   ```properties
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=C:/Users/SAMSUNG/eshaq-upload-keystore.jks
   ```

   Use an absolute path with forward slashes on Windows. These secrets and `*.jks` / `*.keystore` files are ignored by Git. Do not commit them.

3. Build:

   ```powershell
   flutter analyze
   flutter test
   flutter build apk --release
   ```

4. Install or share `build/app/outputs/flutter-apk/app-release.apk`. With a phone connected you can also run:

   ```powershell
   flutter install -d YOUR_DEVICE_ID --release
   ```

For smaller architecture-specific APKs, use `flutter build apk --release --split-per-abi`; choose the correct file for the receiving device. A universal APK is simpler for personal sharing. If an installed debug build has a different signing key, Android will refuse an update from the release APK; uninstall that development build first (this clears its preferences).

See Flutter's [Android release guide](https://docs.flutter.dev/deployment/android) and Android's [app signing guide](https://developer.android.com/studio/publish/app-signing).

## 3. Publish on Google Play

1. Create your own Google Play Console developer account and complete its current verification requirements.
2. Review the application ID in `android/app/build.gradle.kts` before the first publication. The generated ID is `me.eshaq.eshaq_portfolio`; it must be unique and becomes the app's permanent store identity.
3. Complete release signing above, then run:

   ```powershell
   flutter build appbundle --release
   ```

4. Upload `build/app/outputs/bundle/release/app-release.aab` to a Play Console **internal testing** release. An AAB is for Google Play; it cannot be opened and installed like an APK.
5. Complete the listing, screenshots, content rating, app access, ads declaration, privacy policy and Data safety questionnaire according to the actual app and its dependencies. Follow any testing requirements shown for your account.
6. Install through the testing link, check the app on real phones, then submit a production release for review. Store acceptance is decided by Google.

For updates, increase the build number in `pubspec.yaml`, for example `1.0.1+2`, rebuild and upload. Keep the application ID and signing identity consistent.

Current publishing steps are covered by [Flutter's release guide](https://docs.flutter.dev/deployment/android#publish-to-the-google-play-store) and the linked Play Console guidance.

## 4. iPhone / TestFlight / App Store

The `ios` project is included and configured for iOS 15 or newer. **Building and signing iOS needs macOS and Xcode; Windows cannot produce the signed iOS app.**

On a Mac:

```bash
flutter pub get
flutter doctor
open ios/Runner.xcworkspace
```

In Xcode, select Runner, choose your Apple development team under Signing & Capabilities, and verify the bundle identifier and deployment target. Connect an iPhone, complete its development/trust setup, then use `flutter devices` and `flutter run -d DEVICE_ID`. Distribution through TestFlight/App Store requires an Apple Developer Program membership and an App Store Connect app record.

After configuring signing:

```bash
flutter build ipa --release
```

Upload using Xcode/Transporter, test with TestFlight, and complete Apple's listing and review process. Follow the current [Flutter iOS release guide](https://docs.flutter.dev/deployment/ios). This iOS build has not been validated on a Mac.

## 5. Optional Flutter web preview / hosting

The React website remains the main search-engine-facing portfolio. The Flutter web target is useful for previewing this app and optionally sharing its interface in a browser.

```powershell
flutter build web --release
```

Publish the contents of `build/web` with any static HTTPS host. For Vercel, deploy the prebuilt directory from this app folder:

```powershell
npx vercel build/web
```

Use a separate Vercel project, review its preview, then publish it with `npx vercel build/web --prod` when ready. Do not point the existing React project's build settings at this folder. For Git-based Flutter deployments, the build environment must install Flutter; a standard Vite build configuration cannot compile Dart.

For local inspection, serve `build/web` over HTTP (do not double-click `index.html`):

```powershell
python -m http.server 8080 --directory build/web
```

Open `http://localhost:8080`. Web sharing and telephone/email behavior depend on the browser and installed apps. The native offline guarantee does not imply offline browser/PWA support.

## Troubleshooting

- **`flutter` is not recognized:** add the SDK `bin` directory to PATH and reopen the terminal, or use the local-cache commands in README.
- **No Android devices:** check USB debugging, the authorization prompt, the USB cable/driver, or start an emulator.
- **Android licenses/SDK missing:** run `flutter doctor -v`, install its requested SDK components, then `flutter doctor --android-licenses`.
- **Release signing fails:** check the absolute keystore path, alias and passwords in `android/key.properties`.
- **Gradle cannot download dependencies:** the first build needs network access for Gradle, Android dependencies and native PDF tooling.
- **No email/phone handler in the emulator:** test on a configured phone; the app offers a copy-link fallback.
- **Windows native build reports no C/C++ toolchain:** use the Android or web target. This project does not include a Windows desktop target.
