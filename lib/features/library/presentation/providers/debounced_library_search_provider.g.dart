// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debounced_library_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DebouncedLibrarySearch)
final debouncedLibrarySearchProvider = DebouncedLibrarySearchProvider._();

final class DebouncedLibrarySearchProvider
    extends $NotifierProvider<DebouncedLibrarySearch, String> {
  DebouncedLibrarySearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debouncedLibrarySearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debouncedLibrarySearchHash();

  @$internal
  @override
  DebouncedLibrarySearch create() => DebouncedLibrarySearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$debouncedLibrarySearchHash() =>
    r'ab2c4c9595fa60ae910305c056262b487ca46c00';

abstract class _$DebouncedLibrarySearch extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
