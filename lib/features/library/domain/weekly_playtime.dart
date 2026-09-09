import 'package:playtick/features/library/domain/play_session.dart';

Duration weeklyPlaytime(Iterable<PlaySession> sessions, DateTime now) {
  final today = _calendarDay(now);
  final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  return sessions
      .where((session) {
        final day = _calendarDay(session.date);
        return !day.isBefore(startOfWeek) && day.isBefore(endOfWeek);
      })
      .fold(Duration.zero, (sum, session) => sum + session.duration);
}

DateTime _calendarDay(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}
