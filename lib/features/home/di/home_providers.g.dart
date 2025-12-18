// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeRepository)
const homeRepositoryProvider = HomeRepositoryProvider._();

final class HomeRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeRepository>,
          HomeRepository,
          FutureOr<HomeRepository>
        >
    with $FutureModifier<HomeRepository>, $FutureProvider<HomeRepository> {
  const HomeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<HomeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeRepository> create(Ref ref) {
    return homeRepository(ref);
  }
}

String _$homeRepositoryHash() => r'3224a2d2f97412851a29844517357034d4923cb3';
