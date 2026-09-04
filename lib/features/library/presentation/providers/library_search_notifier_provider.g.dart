// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_search_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibrarySearchNotifier)
final librarySearchProvider = LibrarySearchNotifierProvider._();

final class LibrarySearchNotifierProvider
    extends $NotifierProvider<LibrarySearchNotifier, String> {
  LibrarySearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchNotifierHash();

  @$internal
  @override
  LibrarySearchNotifier create() => LibrarySearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$librarySearchNotifierHash() =>
    r'98bf6f97e527cef386e5e4ac1774433085dfefdc';

abstract class _$LibrarySearchNotifier extends $Notifier<String> {
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
