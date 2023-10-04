<br>

# TDD Boilerplate 📱

This is an app boilertplate to easily create flutter project using TDD and Bloc State Management

## Pre-requisites 📐

| Technology | Recommended Version | Installation Guide                                                    |
|------------|---------------------|-----------------------------------------------------------------------|
| Flutter    | v3.10.x             | [Flutter Official Docs](https://flutter.dev/docs/get-started/install) |
| Dart       | v3.0.x              | Installed automatically with Flutter                                  |

## Get Started 🚀

- Clone this project using `git clone https://github.com/ericwidhiantara/tdd_boilerplate.git`
- Run `flutter pub get`
- Run `flutter gen-l10n` to generate localization files
- Run `dart run build_runner build --delete-conflicting-outputs` to generate freezes files
- To generate launcher icon based on
  Flavor `dart run flutter_launcher_icons:main -f flutter_launcher_icons*`
- To generate mock class `dart run build_runner build`

## Run The App 🏃

For **development**

- Use `flutter run --flavor dev -t lib/main.dart --dart-define-from-file .env.dev.json` command in
  console or in Android Studio run configuration

For **staging**

- Use `flutter run --flavor stg -t lib/main.dart --dart-define-from-file .env.stg.json` command in
  console or in Android Studio run configuration

For **production**

- Use `flutter run --flavor prd -t lib/main.dart --dart-define-from-file .env.prd.json` command in
  console or in Android Studio Run Configuration

## Run The Test 🏃

- Use `flutter test` command to run the tests

<br>
