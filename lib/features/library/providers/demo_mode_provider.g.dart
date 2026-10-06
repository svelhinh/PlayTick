// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(demoMode)
final demoModeProvider = DemoModeProvider._();

final class DemoModeProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  DemoModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoModeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return demoMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$demoModeHash() => r'ffc7333bb9c5cabb21ee7e58b9d506fc6f42df86';
