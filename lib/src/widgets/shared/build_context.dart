import 'package:flutter/material.dart';
import 'package:jacked/src/db/service_provider.dart';
import 'package:jacked/src/l10n/generated/app_localizations.dart';
import 'package:jacked/src/widgets/jacked_home_page.dart';

extension ExtendedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  ServiceProvider get svc => ServiceProvider.of(this);
  ActiveWorkoutDisplayState get displayState => ActiveWorkoutDisplayState.of(this);
}
