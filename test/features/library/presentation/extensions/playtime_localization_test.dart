import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/l10n/app_localizations_en.dart';

void main() {
  final appLoc = AppLocalizationsEn();

  test('formats minutes only when withMinutes is true', () {
    expect(Duration.zero.localize(appLoc), '0 h 00');
    expect(const Duration(minutes: 5).localize(appLoc), '5 min');
    expect(const Duration(minutes: 15).localize(appLoc), '15 min');
  });

  test('formats hours and minutes with the min suffix', () {
    expect(const Duration(hours: 1).localize(appLoc), '1 h 00 min');
    expect(
      const Duration(hours: 10, minutes: 38).localize(appLoc),
      '10 h 38 min',
    );
  });

  test('formats compact hours and minutes when withMinutes is false', () {
    expect(Duration.zero.localize(appLoc, withMinutes: false), '0 h 00');
    expect(
      const Duration(minutes: 15).localize(appLoc, withMinutes: false),
      '15 min',
    );
    expect(
      const Duration(minutes: 30).localize(appLoc, withMinutes: false),
      '30 min',
    );
    expect(
      const Duration(
        hours: 12,
        minutes: 45,
      ).localize(appLoc, withMinutes: false),
      '12 h 45',
    );
  });

  test('formats a timer with padded hours, minutes, and seconds', () {
    expect(Duration.zero.formatTimer(), '00:00:00');
    expect(
      const Duration(hours: 1, minutes: 2, seconds: 3).formatTimer(),
      '01:02:03',
    );
    expect(
      const Duration(hours: 100, seconds: 9).formatTimer(),
      '100:00:09',
    );
  });
}
