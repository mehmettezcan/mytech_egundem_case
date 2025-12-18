// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_news_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryNewsRepository)
const categoryNewsRepositoryProvider = CategoryNewsRepositoryProvider._();

final class CategoryNewsRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<CategoryNewsRepository>,
          CategoryNewsRepository,
          FutureOr<CategoryNewsRepository>
        >
    with
        $FutureModifier<CategoryNewsRepository>,
        $FutureProvider<CategoryNewsRepository> {
  const CategoryNewsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryNewsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryNewsRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<CategoryNewsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CategoryNewsRepository> create(Ref ref) {
    return categoryNewsRepository(ref);
  }
}

String _$categoryNewsRepositoryHash() =>
    r'ab54c1396b27cc146d821367dabef0779b5ffe2d';
