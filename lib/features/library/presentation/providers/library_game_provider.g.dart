// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryGame)
final libraryGameProvider = LibraryGameFamily._();

final class LibraryGameProvider
    extends
        $FunctionalProvider<
          AsyncValue<LibraryGameDetails?>,
          LibraryGameDetails?,
          Stream<LibraryGameDetails?>
        >
    with
        $FutureModifier<LibraryGameDetails?>,
        $StreamProvider<LibraryGameDetails?> {
  LibraryGameProvider._({
    required LibraryGameFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'libraryGameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryGameHash();

  @override
  String toString() {
    return r'libraryGameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<LibraryGameDetails?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<LibraryGameDetails?> create(Ref ref) {
    final argument = this.argument as int;
    return libraryGame(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryGameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryGameHash() => r'b205b84e050426f876c3e8d56f49943ddb4bb7ef';

final class LibraryGameFamily extends $Family
    with $FunctionalFamilyOverride<Stream<LibraryGameDetails?>, int> {
  LibraryGameFamily._()
    : super(
        retry: null,
        name: r'libraryGameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryGameProvider call(int gameId) =>
      LibraryGameProvider._(argument: gameId, from: this);

  @override
  String toString() => r'libraryGameProvider';
}
