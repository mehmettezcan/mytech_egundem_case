// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(env)
const envProvider = EnvProvider._();

final class EnvProvider
    extends $FunctionalProvider<EnvConfig, EnvConfig, EnvConfig>
    with $Provider<EnvConfig> {
  const EnvProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'envProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$envHash();

  @$internal
  @override
  $ProviderElement<EnvConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EnvConfig create(Ref ref) {
    return env(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnvConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnvConfig>(value),
    );
  }
}

String _$envHash() => r'03156e0f4e919c6530317b6c147402fa17734777';
