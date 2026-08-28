final class EstimatedPlaytimes {
  const EstimatedPlaytimes({
    this.story,
    this.main,
    this.completion,
  });

  final Duration? story;
  final Duration? main;
  final Duration? completion;
}
