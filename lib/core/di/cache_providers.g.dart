// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(popularNewsCache)
const popularNewsCacheProvider = PopularNewsCacheProvider._();

final class PopularNewsCacheProvider
    extends
        $FunctionalProvider<
          AsyncValue<PopularNewsCache>,
          PopularNewsCache,
          FutureOr<PopularNewsCache>
        >
    with $FutureModifier<PopularNewsCache>, $FutureProvider<PopularNewsCache> {
  const PopularNewsCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularNewsCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularNewsCacheHash();

  @$internal
  @override
  $FutureProviderElement<PopularNewsCache> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PopularNewsCache> create(Ref ref) {
    return popularNewsCache(ref);
  }
}

String _$popularNewsCacheHash() => r'76ed347a762e0f679f5add884e5c5358e1f5e716';
