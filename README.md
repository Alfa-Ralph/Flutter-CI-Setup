# Flutter CI/CD Setup Guide

## Overview
This document describes the CI/CD pipeline setup for the Flutter project using GitHub Actions for CI and Fastlane for CD.

## CI Pipeline (GitHub Actions)

### Workflow File
Location: `.github/workflows/ci.yml`

The CI pipeline is triggered on:
- Push to `main`, `develop`, or `staging` branches
- Pull requests to `main`, `develop`, or `staging` branches

### Pipeline Steps

#### 1. **Checkout Code**
Clones the repository using GitHub's checkout action.

#### 2. **Setup Flutter**
Installs Flutter SDK (version 3.19.0) from the stable channel.

#### 3. **Flutter pub get** 
Downloads and installs all project dependencies.
```bash
flutter pub get
```

#### 4. **Dart Format Check**
Verifies that all Dart code follows the standard formatting rules. This step fails if any files are not properly formatted.
```bash
dart format --set-exit-if-changed lib test
```

#### 5. **Flutter Analyze**
Performs static code analysis to check for errors, warnings, and lint violations.
```bash
flutter analyze
```

#### 6. **Build Runner Generation** (Optional)
Generates code from build_runner (if used in the project).
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
*Currently commented out - uncomment if your project uses build_runner*

#### 7. **Flutter Test**
Runs all unit and widget tests with coverage reporting.
```bash
flutter test --coverage
```

#### 8. **Android Build Verification**
Builds a release APK to ensure the app compiles correctly for Android.
```bash
flutter build apk --release
```

#### 9. **iOS Build Verification** (Optional)
Builds iOS app to verify compilation. Requires macOS runner.
```bash
flutter build ios --release --no-codesign
```
*Currently commented out - requires macOS runner. Uncomment for iOS verification*

### What Blocks a PR from Merging?

A PR **cannot merge** if any of these steps fail:
- ❌ Dart formatting check fails
- ❌ Flutter analyze finds errors
- ❌ Unit/Widget tests fail
- ❌ Android build fails
- ❌ Any other pipeline step fails

### PR Merge Flow
```
PR Created
   ↓
GitHub Actions Triggered
   ↓
flutter pub get
   ↓
dart format check
   ↓
flutter analyze
   ↓
build_runner generation
   ↓
flutter test
   ↓
android build verification
   ↓
ios build verification 
   ↓
✅ PR can merge (if all steps pass)
```