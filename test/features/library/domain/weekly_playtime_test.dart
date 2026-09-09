import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/domain/play_session.dart';
import 'package:playtick/features/library/domain/weekly_playtime.dart';

void main() {
  final now = DateTime.utc(2026, 8, 27, 12);

  PlaySession sessionOn(DateTime date, {Duration? duration, int id = 1}) {
    return PlaySession(
      id: id,
      gameId: 200,
      date: date,
      duration: duration ?? const Duration(hours: 1),
    );
  }

  test('returns zero when there are no sessions', () {
    expect(weeklyPlaytime(const [], now), Duration.zero);
  });

  test('includes sessions from Monday 00:00 through Sunday', () {
    expect(
      weeklyPlaytime(
        [
          sessionOn(DateTime.utc(2026, 8, 24), id: 1),
          sessionOn(
            DateTime.utc(2026, 8, 30),
            duration: const Duration(hours: 2),
            id: 2,
          ),
        ],
        now,
      ),
      const Duration(hours: 3),
    );
  });

  test('excludes the previous Sunday and the next Monday', () {
    expect(
      weeklyPlaytime(
        [
          sessionOn(
            DateTime.utc(2026, 8, 23),
            duration: const Duration(hours: 2),
            id: 1,
          ),
          sessionOn(DateTime.utc(2026, 8, 26), id: 2),
          sessionOn(
            DateTime.utc(2026, 8, 31),
            duration: const Duration(hours: 3),
            id: 3,
          ),
        ],
        now,
      ),
      const Duration(hours: 1),
    );
  });
}
