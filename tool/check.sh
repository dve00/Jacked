#!/usr/bin/env bash
set -e

echo "🌐 Generating localization..."
flutter gen-l10n

echo "🔍 Running analyzer..."
flutter analyze

echo "🧹 Checking formatting..."
dart format --output=none --set-exit-if-changed .

echo "🧪 Running tests..."
flutter test --no-pub

echo "✅ All checks passed!"
