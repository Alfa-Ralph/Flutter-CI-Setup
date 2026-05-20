# Fastlane Configuration Guide

This guide provides setup instructions for Fastlane CD (Continuous Deployment) pipeline.

## Installation

### Prerequisites
- macOS (for iOS deployment)
- Ruby 2.5 or higher
- Xcode Command Line Tools
- Android SDK for Android deployment

### Install Fastlane

```bash
# Install Ruby gems
sudo gem install fastlane -NV

# Or use Homebrew
brew install fastlane
```

### Initialize Fastlane

```bash
# In the project root
cd flutter_ci_setup

# Initialize fastlane for iOS
fastlane init ios

# Initialize fastlane for Android
fastlane init android
```

## Configuration Structure

```
flutter_ci_setup/
├── fastlane/
│   ├── Appfile
│   ├── Fastfile
│   ├── Deliverfile (iOS)
│   ├── Playfile (Android)
│   └── metadata/
│       ├── android/
│       │   ├── en-US/
│       │   │   ├── full_description.txt
│       │   │   ├── short_description.txt
│       │   │   └── title.txt
│       │   └── images/
│       └── ios/
│           └── en-US/
│               └── description.txt
```

## Key Fastlane Tasks

### iOS Deployment

#### Testflight (Beta Testing)
```bash
fastlane ios beta
```

#### App Store (Production)
```bash
fastlane ios release
```

#### Provisioning Profile Management
```bash
fastlane ios setup_certificates
```

### Android Deployment

#### Google Play Beta
```bash
fastlane android beta
```

#### Google Play Production
```bash
fastlane android release
```

#### Generate Signed APK/AAB
```bash
fastlane android build
```

## Setup Steps

### 1. iOS Setup

#### Create App Identifiers
1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Create App IDs for your Flutter app
3. Set up signing certificates and provisioning profiles

#### Configure Fastlane for iOS
```ruby
# fastlane/Appfile
app_identifier "com.example.flutter_ci_setup"
apple_id "your-apple-id@example.com"
team_id "ABCDEFG123"

# fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    setup_ci if is_ci
    build_app(
      workspace: "ios/Runner.xcworkspace",
      scheme: "Runner",
      configuration: "Release",
      derived_data_path: "build/ios",
      destination: "generic/platform=iOS",
      export_method: "app-store",
      export_xcargs: "-allowProvisioningUpdates"
    )
    upload_to_testflight
  end

  desc "Push a new production build to the App Store"
  lane :release do
    setup_ci if is_ci
    build_app(
      workspace: "ios/Runner.xcworkspace",
      scheme: "Runner",
      configuration: "Release",
      derived_data_path: "build/ios",
      destination: "generic/platform=iOS",
      export_method: "app-store",
      export_xcargs: "-allowProvisioningUpdates"
    )
    upload_to_app_store(
      force: true,
      skip_screenshots: false,
      skip_metadata: false
    )
  end
end
```

### 2. Android Setup

#### Create Service Account Key
1. Go to [Google Play Console](https://play.google.com/console)
2. Create a service account with access to your app
3. Download the JSON key file
4. Base64 encode and store in GitHub secrets

#### Configure Fastlane for Android
```ruby
# fastlane/Appfile
json_key_file("path/to/google-play-key.json")
package_name("com.example.flutter_ci_setup")

# fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Submit a new beta build to Google Play"
  lane :beta do
    gradle(
      project_dir: "android/",
      task: "bundle",
      properties: {
        "android.injected.signing.store.file" => ENV['KEYSTORE_PATH'],
        "android.injected.signing.store.password" => ENV['KEYSTORE_PASSWORD'],
        "android.injected.signing.key.alias" => ENV['KEY_ALIAS'],
        "android.injected.signing.key.password" => ENV['KEY_PASSWORD']
      }
    )
    upload_to_play_store(
      track: "beta",
      aab: "android/app/build/outputs/bundle/release/app-release.aab",
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end

  desc "Submit a new production build to Google Play"
  lane :release do
    gradle(
      project_dir: "android/",
      task: "bundle",
      properties: {
        "android.injected.signing.store.file" => ENV['KEYSTORE_PATH'],
        "android.injected.signing.store.password" => ENV['KEYSTORE_PASSWORD'],
        "android.injected.signing.key.alias" => ENV['KEY_ALIAS'],
        "android.injected.signing.key.password" => ENV['KEY_PASSWORD']
      }
    )
    upload_to_play_store(
      track: "production",
      aab: "android/app/build/outputs/bundle/release/app-release.aab"
    )
  end
end
```

### 3. GitHub Actions Integration

Create `.github/workflows/cd.yml` for automated deployment:

```yaml
name: Flutter CD

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy:
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Build Flutter app
        run: flutter build appbundle --release
      
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '2.7'
          bundler-cache: true
      
      - name: Deploy to App Store
        env:
          APPLE_ID: ${{ secrets.APPLE_ID }}
          APPLE_PASSWORD: ${{ secrets.APPLE_PASSWORD }}
          FASTLANE_USER: ${{ secrets.FASTLANE_USER }}
          FASTLANE_PASSWORD: ${{ secrets.FASTLANE_PASSWORD }}
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
        run: |
          cd flutter_ci_setup
          fastlane ios release
      
      - name: Deploy to Google Play
        env:
          KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
          KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
        run: |
          cd flutter_ci_setup
          fastlane android release
```

## Environment Variables

### iOS
```bash
FASTLANE_USER=your-apple-id@example.com
FASTLANE_PASSWORD=your-app-specific-password
MATCH_PASSWORD=your-match-password
```

### Android
```bash
KEYSTORE_PATH=/path/to/keystore.jks
KEYSTORE_PASSWORD=your-keystore-password
KEY_ALIAS=your-key-alias
KEY_PASSWORD=your-key-password
```

## Security Best Practices

1. **Never commit credentials** to the repository
2. **Use GitHub Secrets** for sensitive data
3. **Use Fastlane Match** for certificate management
4. **Rotate credentials** regularly
5. **Enable 2FA** on Apple and Google accounts
6. **Use service accounts** for Google Play

## Useful Fastlane Commands

```bash
# List all available lanes
fastlane lanes

# Run a specific lane
fastlane ios beta

# Generate documentation
fastlane docs

# Get help on a plugin
fastlane action upload_to_testflight
```

## References

- [Fastlane Documentation](https://fastlane.tools/)
- [iOS Deployment Guide](https://fastlane.tools/docs/ios)
- [Android Deployment Guide](https://fastlane.tools/docs/android)
- [Match - Certificate Management](https://docs.fastlane.tools/actions/match/)
