import 'package:playtick/l10n/app_localizations.dart';

extension PlaytimeLocalization on Duration {
  String localize(AppLocalizations appLoc, {bool withMinutes = true}) {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final minutesPadded = minutes.toString().padLeft(2, '0');

    if (hours == 0 && minutes == 0) {
      return appLoc.gamePlaytime(0, '00');
    }

    if (!withMinutes) {
      if (hours == 0) {
        return appLoc.gamePlaytimeMinutes(minutes.toString());
      }
      return appLoc.gamePlaytime(hours, minutesPadded);
    }

    if (hours == 0) {
      return appLoc.gamePlaytimeMinutes(minutes.toString());
    }

    return appLoc.gamePlaytimeHoursMinutes(hours, minutesPadded);
  }
}
