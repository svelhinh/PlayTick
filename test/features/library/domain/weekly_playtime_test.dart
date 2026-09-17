import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/domain/play_session.dart';
import 'package:playtick/features/library/domain/weekly_playtime.dart';

void main() {
  final now = DateTime(2026, 8, 27, 12);

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
          sessionOn(DateTime(2026, 8, 24)),
          sessionOn(
            DateTime(2026, 8, 30),
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
            DateTime(2026, 8, 23),
            duration: const Duration(hours: 2),
          ),
          sessionOn(DateTime(2026, 8, 26), id: 2),
          sessionOn(
            DateTime(2026, 8, 31),
            duration: const Duration(hours: 3),
            id: 3,
          ),
        ],
        now,
      ),
      const Duration(hours: 1),
    );
  });

  test(
    'includes a Monday from the previous month when the week spans months',
    () {
      final tuesday = DateTime(2026, 9, 1, 12);

      expect(
        weeklyPlaytime(
          [
            sessionOn(
              DateTime(2026, 8, 30),
              duration: const Duration(hours: 2),
            ),
            sessionOn(DateTime(2026, 8, 31), id: 2),
            sessionOn(
              DateTime(2026, 9, 6),
              duration: const Duration(hours: 3),
              id: 3,
            ),
            sessionOn(
              DateTime(2026, 9, 7),
              duration: const Duration(hours: 4),
              id: 4,
            ),
          ],
          tuesday,
        ),
        const Duration(hours: 4),
      );
    },
  );

  test('includes Monday when now is Monday at midnight', () {
    final monday = DateTime(2026, 8, 24);

    expect(
      weeklyPlaytime(
        [
          sessionOn(DateTime(2026, 8, 24)),
          sessionOn(
            DateTime(2026, 8, 23),
            duration: const Duration(hours: 2),
            id: 2,
          ),
        ],
        monday,
      ),
      const Duration(hours: 1),
    );
  });

  test('includes Sunday and excludes the following Monday', () {
    final sunday = DateTime(2026, 8, 30, 18);

    expect(
      weeklyPlaytime(
        [
          sessionOn(
            DateTime(2026, 8, 30),
            duration: const Duration(hours: 2),
          ),
          sessionOn(
            DateTime(2026, 8, 31),
            duration: const Duration(hours: 3),
            id: 2,
          ),
        ],
        sunday,
      ),
      const Duration(hours: 2),
    );
  });
}
