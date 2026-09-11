const sessionDurationStep = Duration(minutes: 15);
const minSessionDuration = Duration(minutes: 15);

Duration nextQuarterHour(Duration duration) {
  final stepMinutes = sessionDurationStep.inMinutes;
  final remainder = duration.inMinutes % stepMinutes;
  if (remainder == 0) {
    return duration + sessionDurationStep;
  }
  return Duration(minutes: duration.inMinutes + (stepMinutes - remainder));
}

Duration previousQuarterHour(Duration duration) {
  if (duration < minSessionDuration) {
    return duration;
  }

  final stepMinutes = sessionDurationStep.inMinutes;
  final remainder = duration.inMinutes % stepMinutes;
  final nextMinutes = remainder == 0
      ? duration.inMinutes - stepMinutes
      : duration.inMinutes - remainder;
  if (nextMinutes < minSessionDuration.inMinutes) {
    return minSessionDuration;
  }
  return Duration(minutes: nextMinutes);
}
