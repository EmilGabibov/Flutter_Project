import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/l10n/app_localizations.dart';

void main() {
  test(
    'completion and web push batch is generated for supported locales',
    () async {
      final english = await AppLocalizations.delegate.load(const Locale('en'));
      final urdu = await AppLocalizations.delegate.load(const Locale('ur'));
      final indonesian = await AppLocalizations.delegate.load(const Locale('id'));

      expect(english.completionContinue, 'Continue');
      expect(english.webPushEnable, isNotEmpty);
      expect(english.socialJointCompletion, isNotEmpty);
      expect(urdu.completionContinue, isNotEmpty);
      expect(urdu.webPushEnable, isNotEmpty);
      expect(indonesian.completionContinue, 'Lanjutkan');
      expect(indonesian.webPushEnable, isNotEmpty);
      expect(indonesian.socialJointCompletion, isNotEmpty);
    },
  );
}
