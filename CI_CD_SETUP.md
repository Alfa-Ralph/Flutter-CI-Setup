# Flutter CI/CD Setup Guide

## Overview
This document describes the CI/CD pipeline setup for the Flutter project using GitHub Actions for CI and Fastlane for CD.

## CI Pipeline (GitHub Actions)

### Workflow File
Location: `.github/workflows/ci.yml`

The CI pipeline is triggered on:
- Push to `main`, `develop`, or `master` branches
- Pull requests to `main`, `develop`, or `master` branches

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

## Local Development

### Running Tests Locally

#### Run all tests
```bash
flutter test
```

#### Run tests with coverage
```bash
flutter test --coverage
```

#### Run specific test file
```bash
flutter test test/unit_test.dart
flutter test test/widget_test.dart
```

### Code Formatting

#### Check formatting
```bash
dart format --set-exit-if-changed lib test
```

#### Auto-fix formatting
```bash
dart format lib test
```

### Code Analysis

```bash
flutter analyze
```

### Getting Dependencies

```bash
flutter pub get
```

### Build Verification

#### Android APK
```bash
flutter build apk --release
```

#### iOS (requires macOS)
```bash
flutter build ios --release
```

## Test Structure

### Unit Tests
Location: `test/unit_test.dart`

Tests for the `CounterService` class including:
- Initial state tests
- Increment operations
- Decrement operations
- Reset and set value operations
- Helper methods (isPositive, isZero, getCounterDisplay)
- Edge cases

### Widget Tests
Location: `test/widget_test.dart`

Tests for the Flutter UI including:
- Widget rendering
- Counter display
- Button interactions
- Multiple taps
- Widget hierarchy verification

## Code Quality Standards

The project uses the following linting rules (configured in `analysis_options.yaml`):
- **Error Rules**: Prevent common programming errors
- **Style Rules**: Enforce consistent code style
- **Formatting**: All code must pass `dart format --set-exit-if-changed`

## CD Pipeline (Fastlane)

The Continuous Deployment pipeline will be handled by Fastlane separately, which includes:
- Code signing (iOS & Android)
- Publishing to TestFlight (iOS)
- Publishing to Google Play Console (Android)
- Release notes generation
- Automated screenshots

## GitHub Actions Secrets

For CD pipeline integration, the following secrets should be configured in GitHub:
- `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD`: Keystore password
- `ANDROID_KEY_ALIAS`: Key alias
- `ANDROID_KEY_PASSWORD`: Key password
- `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`: Apple app-specific password
- `FASTLANE_USER`: Apple Developer account email

## Troubleshooting

### Formatting Failures
If the format check fails, run:
```bash
dart format lib test
```

### Lint Warnings
Check the analysis_options.yaml for any disabled rules that might need addressing.

### Test Failures
1. Ensure all dependencies are installed: `flutter pub get`
2. Check test output for specific failures
3. Review the test file for expected behaviors

### Build Failures
1. Run `flutter clean` to clear build cache
2. Run `flutter pub get` to reinstall dependencies
3. Try building locally first: `flutter build apk --release`

## Next Steps

1. **Enable branch protection** on main/develop branches:
   - Require status checks to pass before merging
   - Require code reviews before merging

2. **Configure Fastlane** for CD pipeline

3. **Add more tests** as the project grows

4. **Monitor coverage** using Codecov integration

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Fastlane Documentation](https://fastlane.tools/)
- [Dart Linting Rules](https://dart.dev/lints)
