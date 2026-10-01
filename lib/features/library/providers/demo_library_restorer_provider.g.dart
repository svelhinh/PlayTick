// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_library_restorer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(demoLibraryRestorer)
final demoLibraryRestorerProvider = DemoLibraryRestorerProvider._();

final class DemoLibraryRestorerProvider
    extends
        $FunctionalProvider<
          DemoLibraryRestorer,
          DemoLibraryRestorer,
          DemoLibraryRestorer
        >
    with $Provider<DemoLibraryRestorer> {
  DemoLibraryRestorerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoLibraryRestorerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoLibraryRestorerHash();

  @$internal
  @override
  $ProviderElement<DemoLibraryRestorer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DemoLibraryRestorer create(Ref ref) {
    return demoLibraryRestorer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DemoLibraryRestorer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DemoLibraryRestorer>(value),
    );
  }
}

String _$demoLibraryRestorerHash() =>
    r'e2dea5b69624bde7ad39209d0d720458d7721065';
