// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sourceRepository)
const sourceRepositoryProvider = SourceRepositoryProvider._();

final class SourceRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SourceRepository>,
          SourceRepository,
          FutureOr<SourceRepository>
        >
    with $FutureModifier<SourceRepository>, $FutureProvider<SourceRepository> {
  const SourceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourceRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<SourceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SourceRepository> create(Ref ref) {
    return sourceRepository(ref);
  }
}

String _$sourceRepositoryHash() => r'a3aee54afe3e135dea75729dd4b46e0c2fa6fe8b';
