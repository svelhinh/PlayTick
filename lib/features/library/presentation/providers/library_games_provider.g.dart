// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_games_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryGames)
final libraryGamesProvider = LibraryGamesProvider._();

final class LibraryGamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LibraryGame>>,
          List<LibraryGame>,
          Stream<List<LibraryGame>>
        >
    with
        $FutureModifier<List<LibraryGame>>,
        $StreamProvider<List<LibraryGame>> {
  LibraryGamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryGamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryGamesHash();

  @$internal
  @override
  $StreamProviderElement<List<LibraryGame>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LibraryGame>> create(Ref ref) {
    return libraryGames(ref);
  }
}

String _$libraryGamesHash() => r'a713f98671c17c09a8a6e9060506f63ff8f3592e';
