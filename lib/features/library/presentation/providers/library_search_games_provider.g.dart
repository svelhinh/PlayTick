// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_search_games_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(librarySearchGames)
final librarySearchGamesProvider = LibrarySearchGamesProvider._();

final class LibrarySearchGamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Game>>,
          List<Game>,
          FutureOr<List<Game>>
        >
    with $FutureModifier<List<Game>>, $FutureProvider<List<Game>> {
  LibrarySearchGamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: _skipIgdbSearchRetry,
        name: r'librarySearchGamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchGamesHash();

  @$internal
  @override
  $FutureProviderElement<List<Game>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Game>> create(Ref ref) {
    return librarySearchGames(ref);
  }
}

String _$librarySearchGamesHash() =>
    r'828937205f7a5d0b25b50972edd3a98df4829079';
