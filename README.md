<br>

# TDD Boilerplate 📱

This is an app boilertplate to easily create flutter project using TDD and Bloc State Management

## Pre-requisites 📐

| Technology | Recommended Version | Installation Guide                                                    |
|------------|---------------------|-----------------------------------------------------------------------|
| Flutter    | v3.10.x             | [Flutter Official Docs](https://flutter.dev/docs/get-started/install) |
| Dart       | v3.0.x              | Installed automatically with Flutter                                  |

## Get Started 🚀

- Clone this project
- Run `flutter pub get`
- Run `flutter gen-l10n` to generate localization files
- Run `dart run build_runner build --delete-conflicting-outputs`
  or `dart run build_runner watch --delete-conflicting-outputs` to generate freezes files
- Run `flutter run --flavor dev -t lib/main.dart --dart-define-from-file .env.dev.json` for *
  *development** or
- Run `flutter run --flavor stg -t lib/main.dart --dart-define-from-file .env.stg.json` for *
  *staging** or
- Run `flutter run --flavor prd -t lib/main.dart --dart-define-from-file .env.prd.json` for *
  *production**
- Run Test `flutter test`
- To generate launcher icon based on
  Flavor `dart run flutter_launcher_icons:main -f flutter_launcher_icons*`
- To generate mock class `dart run build_runner build` or `dart run build_runner watch`

<br>
