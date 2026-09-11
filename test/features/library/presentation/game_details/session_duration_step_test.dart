import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/presentation/widgets/session_duration_step.dart';

void main() {
  group('nextQuarterHour', () {
    test('adds a step when already on a quarter hour', () {
      expect(
        nextQuarterHour(const Duration(minutes: 15)),
        const Duration(minutes: 30),
      );
      expect(
        nextQuarterHour(const Duration(minutes: 60)),
        const Duration(minutes: 75),
      );
    });

    test('snaps up to the next quarter hour', () {
      expect(
        nextQuarterHour(const Duration(minutes: 16)),
        const Duration(minutes: 30),
      );
      expect(
        nextQuarterHour(const Duration(minutes: 23)),
        const Duration(minutes: 30),
      );
      expect(
        nextQuarterHour(const Duration(minutes: 29)),
        const Duration(minutes: 30),
      );
      expect(
        nextQuarterHour(const Duration(hours: 1, minutes: 7)),
        const Duration(hours: 1, minutes: 15),
      );
    });

    test('steps from zero to the minimum session duration', () {
      expect(nextQuarterHour(Duration.zero), const Duration(minutes: 15));
    });
  });

  group('previousQuarterHour', () {
    test('subtracts a step when already on a quarter hour', () {
      expect(
        previousQuarterHour(const Duration(minutes: 30)),
        const Duration(minutes: 15),
      );
      expect(
        previousQuarterHour(const Duration(minutes: 75)),
        const Duration(minutes: 60),
      );
    });

    test('snaps down to the previous quarter hour', () {
      expect(
        previousQuarterHour(const Duration(minutes: 31)),
        const Duration(minutes: 30),
      );
      expect(
        previousQuarterHour(const Duration(minutes: 44)),
        const Duration(minutes: 30),
      );
      expect(
        previousQuarterHour(const Duration(hours: 1, minutes: 7)),
        const Duration(hours: 1),
      );
    });

    test('does not go below the minimum session duration', () {
      expect(
        previousQuarterHour(const Duration(minutes: 15)),
        const Duration(minutes: 15),
      );
      expect(
        previousQuarterHour(const Duration(minutes: 23)),
        const Duration(minutes: 15),
      );
    });

    test('does nothing when already below the minimum session duration', () {
      expect(
        previousQuarterHour(const Duration(minutes: 7)),
        const Duration(minutes: 7),
      );
      expect(previousQuarterHour(Duration.zero), Duration.zero);
    });
  });
}
