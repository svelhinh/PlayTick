// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_search_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(librarySearchRepository)
final librarySearchRepositoryProvider = LibrarySearchRepositoryProvider._();

final class LibrarySearchRepositoryProvider
    extends
        $FunctionalProvider<
          LibrarySearchRepository,
          LibrarySearchRepository,
          LibrarySearchRepository
        >
    with $Provider<LibrarySearchRepository> {
  LibrarySearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySearchRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchRepositoryHash();

  @$internal
  @override
  $ProviderElement<LibrarySearchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LibrarySearchRepository create(Ref ref) {
    return librarySearchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibrarySearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibrarySearchRepository>(value),
    );
  }
}

String _$librarySearchRepositoryHash() =>
    r'7efe9f5f17a175e3ee4e6e02c7b5e6bef9fb522a';
