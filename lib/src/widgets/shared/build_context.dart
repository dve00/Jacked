import 'package:flutter/material.dart';
import 'package:jacked/src/l10n/generated/app_localizations.dart';

extension ExtendedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
