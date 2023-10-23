import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tddboilerplate/app.dart';
import 'package:tddboilerplate/dependencies_injection.dart';
import 'package:tddboilerplate/utils/utils.dart';

void main() {
  runZonedGuarded(
    /// Lock device orientation to portrait
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      /// Register Service locator
      await serviceLocator();
      await FirebaseServices.init();

      return SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      ).then((_) => runApp(App()));
    },
    (error, stackTrace) async {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
