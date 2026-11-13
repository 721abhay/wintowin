# WinToWin — Cross-Platform Mobile App (iOS & Android)

A modern, production-structured mobile application built with **Flutter**, designed to run natively on both **Apple iOS** and **Google Android** from a single shared Dart codebase.

---

## 📱 Features & Highlights

- **Universal Mobile Architecture**: 100% shared business logic and UI between iOS and Android.
- **Adaptive UI & Themes**: Material 3 for Android with Cupertino styling adaptation for iOS.
- **Dark Mode & Light Mode**: Live reactive theme switching with system auto-detection.
- **Dashboard & Performance KPI Cards**: Native frame rate metrics (120 FPS Impeller pipeline), device statistics, and module completion counters.
- **Interactive Roadmap & Modules**: Task toggle, expandable detail sheets, and modular design.
- **Native Hardware Exploration**: Curated guides for Camera, Biometrics (Face ID/Fingerprint), Geolocation, SQLite/Hive, and Push Notifications (APNs/FCM).
- **Deployment Checklist**: Store readiness score and build guides for Google Play & Apple App Store.

---

## 📁 Project Directory Structure

```text
wintowin/
├── android/                      # Native Android project (Gradle, Kotlin, Manifest)
│   ├── app/
│   │   ├── build.gradle.kts      # Android application build configuration
│   │   └── src/main/
│   │       ├── AndroidManifest.xml # Permissions (INTERNET, ACCESS_NETWORK_STATE)
│   │       ├── kotlin/           # MainActivity.kt
│   │       └── res/              # App icons, splash screens, XML drawables
│   └── build.gradle.kts          # Top-level Gradle script
├── ios/                          # Native iOS project (Xcode, CocoaPods, Swift)
│   ├── Runner/
│   │   ├── AppDelegate.swift     # iOS entry lifecycle
│   │   ├── Info.plist            # iOS permissions, orientations, bundle configuration
│   │   └── Assets.xcassets       # iOS AppIcon & LaunchImage sets
│   └── Runner.xcodeproj          # Xcode project settings
├── lib/                          # Main Flutter application source
│   ├── main.dart                 # Application entrypoint & theme initialization
│   ├── models/                   # Data transfer objects & entity models
│   │   └── feature_item.dart
│   ├── screens/                  # Main UI views
│   │   ├── main_navigation_screen.dart # Bottom navigation bar container
│   │   ├── home_screen.dart      # Dashboard & KPI metrics
│   │   ├── explore_screen.dart   # Native module catalog
│   │   ├── activity_screen.dart  # Release readiness & build commands
│   │   └── settings_screen.dart  # Theme switcher & device diagnostics
│   ├── services/                 # State management & business logic
│   │   └── app_state.dart
│   ├── theme/                    # Material 3 & color palette configuration
│   │   └── app_theme.dart
│   └── widgets/                  # Reusable components
│       ├── adaptive_dialog.dart  # Cupertino on iOS, Material on Android
│       ├── platform_badge.dart   # Real-time target engine indicator
│       └── stat_card.dart        # Metric card component
├── test/                         # Unit & widget tests
│   └── widget_test.dart
├── pubspec.yaml                  # Dependencies, fonts, assets
└── analysis_options.yaml         # Dart linter & code health rules
```

---

## 🚀 Getting Started

### 1. Verify Prerequisites
Run Flutter doctor to check your environment:
```bash
flutter doctor
```

Accept Android SDK licenses if needed:
```bash
flutter doctor --android-licenses
```

### 2. Run the App Locally

#### On Android (Emulator or Connected USB Device):
1. Enable **USB Debugging** on your Android phone, or start an Android Virtual Device (AVD).
2. Run:
```bash
flutter run
```

#### On iOS:
> **Note**: Building the native iOS `.ipa` or running in the iOS Simulator requires macOS with Xcode. However, your code is 100% iOS-ready! You can build/test via cloud CI/CD (such as GitHub Actions or Codemagic) or on a Mac:
```bash
flutter run -d ios
```

#### On Chrome / Desktop (Instant Preview):
You can also preview the UI immediately on your computer:
```bash
flutter run -d chrome
```

---

## 📦 Building for Production & App Stores

### 🤖 Google Play Store (Android)

1. **Build App Bundle (Recommended by Google Play)**:
   ```bash
   flutter build appbundle
   ```
   *Output*: `build/app/outputs/bundle/release/app-release.aab`

2. **Build Standalone APKs (For direct distribution / testing)**:
   ```bash
   flutter build apk --split-per-abi
   ```
   *Output*: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

---

### 🍎 Apple App Store (iOS)

1. **Build iOS Archive & IPA**:
   ```bash
   flutter build ipa
   ```
   *Output*: `build/ios/archive/Runner.xcarchive` and `build/ios/ipa/wintowin.ipa`

2. Upload to App Store Connect using Xcode Organizer, Transporter, or Fastlane.

---

## 🛠 Recommended Packages for Native Features

To add advanced device hardware integrations, add these standard Flutter community plugins:

| Feature | Recommended Package | Command |
| :--- | :--- | :--- |
| **Camera & Photos** | `image_picker` | `flutter pub add image_picker` |
| **Local Storage** | `shared_preferences` | `flutter pub add shared_preferences` |
| **Relational Database** | `sqflite` | `flutter pub add sqflite` |
| **Biometric Auth** | `local_auth` | `flutter pub add local_auth` |
| **Push Notifications** | `firebase_messaging` | `flutter pub add firebase_messaging` |
| **Network Requests** | `dio` or `http` | `flutter pub add http` |
| **Location & GPS** | `geolocator` | `flutter pub add geolocator` |

---

## 🧪 Testing

Execute the test suite:
```bash
flutter test
```
