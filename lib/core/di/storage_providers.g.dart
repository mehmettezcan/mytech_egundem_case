// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tokenStorage)
const tokenStorageProvider = TokenStorageProvider._();

final class TokenStorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<TokenStorage>,
          TokenStorage,
          FutureOr<TokenStorage>
        >
    with $FutureModifier<TokenStorage>, $FutureProvider<TokenStorage> {
  const TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $FutureProviderElement<TokenStorage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TokenStorage> create(Ref ref) {
    return tokenStorage(ref);
  }
}

String _$tokenStorageHash() => r'80c2b3b15b4d1e97295f378a829e9eb6161130f2';
