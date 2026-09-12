// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameNotes)
final gameNotesProvider = GameNotesFamily._();

final class GameNotesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameNote>>,
          List<GameNote>,
          Stream<List<GameNote>>
        >
    with $FutureModifier<List<GameNote>>, $StreamProvider<List<GameNote>> {
  GameNotesProvider._({
    required GameNotesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'gameNotesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameNotesHash();

  @override
  String toString() {
    return r'gameNotesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<GameNote>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GameNote>> create(Ref ref) {
    final argument = this.argument as int;
    return gameNotes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GameNotesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameNotesHash() => r'f70f33a500699451fa613145504e3a45212f0f4f';

final class GameNotesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<GameNote>>, int> {
  GameNotesFamily._()
    : super(
        retry: null,
        name: r'gameNotesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameNotesProvider call(int gameId) =>
      GameNotesProvider._(argument: gameId, from: this);

  @override
  String toString() => r'gameNotesProvider';
}
