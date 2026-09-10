// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_play_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activePlaySession)
final activePlaySessionProvider = ActivePlaySessionProvider._();

final class ActivePlaySessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActivePlaySession?>,
          ActivePlaySession?,
          Stream<ActivePlaySession?>
        >
    with
        $FutureModifier<ActivePlaySession?>,
        $StreamProvider<ActivePlaySession?> {
  ActivePlaySessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePlaySessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activePlaySessionHash();

  @$internal
  @override
  $StreamProviderElement<ActivePlaySession?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ActivePlaySession?> create(Ref ref) {
    return activePlaySession(ref);
  }
}

String _$activePlaySessionHash() => r'b03a3694ba14d87e6c122d32eddef1f4ada9caa9';
