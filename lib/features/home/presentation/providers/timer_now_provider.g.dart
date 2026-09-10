// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_now_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(timerNow)
final timerNowProvider = TimerNowProvider._();

final class TimerNowProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime>, DateTime, Stream<DateTime>>
    with $FutureModifier<DateTime>, $StreamProvider<DateTime> {
  TimerNowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerNowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerNowHash();

  @$internal
  @override
  $StreamProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime> create(Ref ref) {
    return timerNow(ref);
  }
}

String _$timerNowHash() => r'd7a8e2fee56191d400027504becd2cbeb588b5f2';
