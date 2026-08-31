// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_filter_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibraryFilterNotifier)
final libraryFilterProvider = LibraryFilterNotifierProvider._();

final class LibraryFilterNotifierProvider
    extends $NotifierProvider<LibraryFilterNotifier, LibraryFilter> {
  LibraryFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryFilterNotifierHash();

  @$internal
  @override
  LibraryFilterNotifier create() => LibraryFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryFilter>(value),
    );
  }
}

String _$libraryFilterNotifierHash() =>
    r'b7ccee0ffd62b4f7c712ec3b2d3b77cc45f4c873';

abstract class _$LibraryFilterNotifier extends $Notifier<LibraryFilter> {
  LibraryFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibraryFilter, LibraryFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibraryFilter, LibraryFilter>,
              LibraryFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
