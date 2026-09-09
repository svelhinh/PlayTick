// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_playtime_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weeklyPlaytime)
final weeklyPlaytimeProvider = WeeklyPlaytimeProvider._();

final class WeeklyPlaytimeProvider
    extends
        $FunctionalProvider<AsyncValue<Duration>, Duration, Stream<Duration>>
    with $FutureModifier<Duration>, $StreamProvider<Duration> {
  WeeklyPlaytimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyPlaytimeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyPlaytimeHash();

  @$internal
  @override
  $StreamProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Duration> create(Ref ref) {
    return weeklyPlaytime(ref);
  }
}

String _$weeklyPlaytimeHash() => r'3a2fcf25663713769bef87ef62d763cc8fffcd82';
