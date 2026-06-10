# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter run          # Run on connected device/emulator (hot reload: r, hot restart: R)
flutter build apk    # Build Android APK
flutter test         # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter analyze      # Static analysis (configured by analysis_options.yaml)
flutter pub get      # Install dependencies after pubspec.yaml changes
```

## Architecture

This is a minimal Flutter starter app. All application code lives in [lib/main.dart](lib/main.dart).

- **State management**: `StatefulWidget` + `setState` (no external state management library)
- **Theme**: Material Design 3 (`useMaterial3: true`)
- **Structure**: Single screen, monolithic — no routing, no feature folders

When adding features, the standard Flutter convention is to split code under `lib/` into feature directories (e.g., `lib/screens/`, `lib/widgets/`, `lib/models/`) and introduce a state management solution (Provider, Riverpod, or BLoC) as complexity grows.
