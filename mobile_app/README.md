# 🪷 ShilpSetu AI — Mobile Application

The official cross-platform mobile client for **ShilpSetu AI (शिल्पसेतू)**, built with Flutter.

For full architectural details, backend setup, and project-wide documentation, please refer to the [Root README](../README.md).

---

## 📱 Features

- **Multi-Role Experience**: Artisan, B2B Buyer, and Administrative personas.
- **AI Photo Studio**: Instant craft photo cleanup and studio lighting enhancement.
- **Voice-to-Catalog**: Multi-lingual voice recognition (Marathi, Hindi, English).
- **Smart Fair Pricing**: Transparent pricing recommendation breakdown.
- **Digital Pehchan Card**: Verifiable government artisan identity card with audio profile playback.
- **B2B Sourcing Portal**: Direct trade requests and real-time chat between buyers and artisans.
- **Digital Mela**: Virtual exhibitions and seasonal craft fair pavilions.

---

## 🚀 Running the Mobile App

### Prerequisites
- Flutter SDK (v3.19.0+)
- Android device or emulator with USB debugging enabled

### Run Locally
```bash
# Get dependencies
flutter pub get

# Check connected device
flutter devices

# Run on your target device
flutter run
```

### Build APK
```bash
flutter build apk --release
```
The output APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.
