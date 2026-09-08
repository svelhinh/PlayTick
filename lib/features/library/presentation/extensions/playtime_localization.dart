import 'package:playtick/l10n/app_localizations.dart';

extension PlaytimeLocalization on Duration {
  String localize(AppLocalizations appLoc) {
    final hours = inHours;
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');

    if (hours == 0) {
      return appLoc.gamePlaytimeMinutes(minutes);
    }

    return appLoc.gamePlaytime(hours, minutes);
  }
}
