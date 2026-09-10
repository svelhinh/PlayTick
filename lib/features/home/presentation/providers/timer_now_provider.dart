import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_now_provider.g.dart';

@riverpod
Stream<DateTime> timerNow(Ref ref) async* {
  yield DateTime.now();

  yield* Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
}
