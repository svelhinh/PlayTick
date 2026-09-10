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

  String formatTimer() {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }
}
