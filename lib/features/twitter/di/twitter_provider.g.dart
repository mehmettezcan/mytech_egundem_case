// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(twitterRepository)
const twitterRepositoryProvider = TwitterRepositoryProvider._();

final class TwitterRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<TwitterRepository>,
          TwitterRepository,
          FutureOr<TwitterRepository>
        >
    with
        $FutureModifier<TwitterRepository>,
        $FutureProvider<TwitterRepository> {
  const TwitterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'twitterRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$twitterRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<TwitterRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TwitterRepository> create(Ref ref) {
    return twitterRepository(ref);
  }
}

String _$twitterRepositoryHash() => r'0e59a0306bc6876a125be7ce879cefc075146803';
