final class EstimatedPlaytimes {
  const EstimatedPlaytimes({
    this.story,
    this.main,
    this.completion,
  });

  final Duration? story;
  final Duration? main;
  final Duration? completion;

  bool get hasValues => story != null || main != null || completion != null;
}
