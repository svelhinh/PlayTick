// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_library_games_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(temporaryLibraryGames)
final temporaryLibraryGamesProvider = TemporaryLibraryGamesProvider._();

final class TemporaryLibraryGamesProvider
    extends
        $FunctionalProvider<
          List<LibraryGame>,
          List<LibraryGame>,
          List<LibraryGame>
        >
    with $Provider<List<LibraryGame>> {
  TemporaryLibraryGamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temporaryLibraryGamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temporaryLibraryGamesHash();

  @$internal
  @override
  $ProviderElement<List<LibraryGame>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<LibraryGame> create(Ref ref) {
    return temporaryLibraryGames(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LibraryGame> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LibraryGame>>(value),
    );
  }
}

String _$temporaryLibraryGamesHash() =>
    r'8e5e2cd0e55da35bb55f7681b829c7489afeee4f';
