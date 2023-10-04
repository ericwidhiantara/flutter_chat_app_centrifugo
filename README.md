<br>

# TDD Boilerplate 📱

This is an App with Auth Functions like Login and Register. All API
using [reqres.in](https://reqres.in/).

## Pre-requisites 📐

| Technology | Recommended Version | Installation Guide                                                    |
|------------|---------------------|-----------------------------------------------------------------------|
| Flutter    | v3.10.x             | [Flutter Official Docs](https://flutter.dev/docs/get-started/install) |
| Dart       | v3.0.x              | Installed automatically with Flutter                                  |

## Get Started 🚀

- Clone this project
- Run `flutter pub get`
- Run `flutter gen-l10n` to generate localization files
- Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate freezes files
- Run `flutter run --flavor stg -t lib/main.dart --dart-define-from-file .env.stg.json` for *
  *staging** or
- Run `flutter run --flavor prd -t lib/main.dart --dart-define-from-file .env.prd.json` for *
  *production**
- Run Test `flutter test`
- To generate launcher icon based on
  Flavor `dart pub run flutter_launcher_icons:main -f flutter_launcher_icons*`
- To generate mock class `dart pub run build_runner build`

<br>
