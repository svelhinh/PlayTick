import 'package:playtick/features/library/domain/play_session.dart';

Duration weeklyPlaytime(Iterable<PlaySession> sessions, DateTime now) {
  final startOfWeek = now
      .copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      )
      .subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  return sessions
      .where(
        (session) =>
            !session.date.isBefore(startOfWeek) &&
            session.date.isBefore(endOfWeek),
      )
      .fold(Duration.zero, (sum, session) => sum + session.duration);
}
