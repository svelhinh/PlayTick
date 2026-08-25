// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jsonPlaceholderHttpClient)
final jsonPlaceholderHttpClientProvider = JsonPlaceholderHttpClientProvider._();

final class JsonPlaceholderHttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  JsonPlaceholderHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonPlaceholderHttpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonPlaceholderHttpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return jsonPlaceholderHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$jsonPlaceholderHttpClientHash() =>
    r'49f0a3c80592bfd5ce62435ceb184b22e93ca6c2';

@ProviderFor(jsonPlaceholderClient)
final jsonPlaceholderClientProvider = JsonPlaceholderClientProvider._();

final class JsonPlaceholderClientProvider
    extends
        $FunctionalProvider<
          JsonPlaceholderClient,
          JsonPlaceholderClient,
          JsonPlaceholderClient
        >
    with $Provider<JsonPlaceholderClient> {
  JsonPlaceholderClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonPlaceholderClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonPlaceholderClientHash();

  @$internal
  @override
  $ProviderElement<JsonPlaceholderClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  JsonPlaceholderClient create(Ref ref) {
    return jsonPlaceholderClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JsonPlaceholderClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JsonPlaceholderClient>(value),
    );
  }
}

String _$jsonPlaceholderClientHash() =>
    r'f6e8298d305cc674fec3be9405402fb558a52a58';

@ProviderFor(jsonPlaceholderPost)
final jsonPlaceholderPostProvider = JsonPlaceholderPostFamily._();

final class JsonPlaceholderPostProvider
    extends
        $FunctionalProvider<
          AsyncValue<JsonPlaceholderPostDto>,
          JsonPlaceholderPostDto,
          FutureOr<JsonPlaceholderPostDto>
        >
    with
        $FutureModifier<JsonPlaceholderPostDto>,
        $FutureProvider<JsonPlaceholderPostDto> {
  JsonPlaceholderPostProvider._({
    required JsonPlaceholderPostFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'jsonPlaceholderPostProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jsonPlaceholderPostHash();

  @override
  String toString() {
    return r'jsonPlaceholderPostProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<JsonPlaceholderPostDto> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JsonPlaceholderPostDto> create(Ref ref) {
    final argument = this.argument as int;
    return jsonPlaceholderPost(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JsonPlaceholderPostProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jsonPlaceholderPostHash() =>
    r'39a632c08f57d632e6b5fde18838aaf25bd5cfa4';

final class JsonPlaceholderPostFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<JsonPlaceholderPostDto>, int> {
  JsonPlaceholderPostFamily._()
    : super(
        retry: null,
        name: r'jsonPlaceholderPostProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JsonPlaceholderPostProvider call(int id) =>
      JsonPlaceholderPostProvider._(argument: id, from: this);

  @override
  String toString() => r'jsonPlaceholderPostProvider';
}
