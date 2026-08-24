# Morning Routine App

A Flutter app for Android tablets that guides children through their morning routines.

## Features

- Daily checklist per child — tap to mark activities complete (turns green)
- Daily star animation when all activities are done
- Weekly overview showing completion badges for Mon–Fri
- Weekly star awarded when all 5 weekdays are fully completed
- Configurable children (1–5) with animal avatars
- Configurable activity list with drag-to-reorder
- Hungarian (default) and English languages
- Auto-resets at midnight every day

## Installation

Download the latest APK from the [Releases](../../releases) page and install it on your Android tablet.

## Development

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

## Releases

Pushing a tag `v*.*.*` triggers a GitHub Actions release build and attaches the APK automatically:

```bash
git tag v1.0.0
git push origin v1.0.0
```
