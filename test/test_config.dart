import 'package:flutter/material.dart';
import 'package:jacked/src/l10n/generated/app_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initializes the sqflite FFI (sqflite_ffi) backend for tests.
///
/// By default, the `sqflite` plugin expects to run on a mobile
/// platform (Android/iOS) with native bindings. In widget/unit tests,
/// however, we don’t have access to those native layers.
///
/// Calling this method switches the database implementation to
/// `sqflite_ffi`, a pure Dart/FFI version of sqflite that works on
/// desktop and in test environments. After this, any call to
/// `openDatabase` will use the in-memory FFI-backed database instead
/// of trying to talk to a missing native platform.
///
/// Usage:
///   void main() {
///     setupTestDatabase();
///     // ... now run tests that open/use a sqflite database.
///   }
void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

/// Wraps [child] in a MaterialApp with localization delegates, theme, etc.
/// so widgets have the same environment as in production.
Widget makeTestApp(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: child,
    ),
  );
}
