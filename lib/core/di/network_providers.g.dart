// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sslInterceptor)
const sslInterceptorProvider = SslInterceptorProvider._();

final class SslInterceptorProvider
    extends
        $FunctionalProvider<
          CustomSslCertificateInterceptor,
          CustomSslCertificateInterceptor,
          CustomSslCertificateInterceptor
        >
    with $Provider<CustomSslCertificateInterceptor> {
  const SslInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sslInterceptorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sslInterceptorHash();

  @$internal
  @override
  $ProviderElement<CustomSslCertificateInterceptor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomSslCertificateInterceptor create(Ref ref) {
    return sslInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomSslCertificateInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomSslCertificateInterceptor>(
        value,
      ),
    );
  }
}

String _$sslInterceptorHash() => r'5c033367bfa293830e018ace8f250ac13f3c0cf5';

@ProviderFor(authInterceptor)
const authInterceptorProvider = AuthInterceptorProvider._();

final class AuthInterceptorProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthInterceptor>,
          AuthInterceptor,
          FutureOr<AuthInterceptor>
        >
    with $FutureModifier<AuthInterceptor>, $FutureProvider<AuthInterceptor> {
  const AuthInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authInterceptorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authInterceptorHash();

  @$internal
  @override
  $FutureProviderElement<AuthInterceptor> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthInterceptor> create(Ref ref) {
    return authInterceptor(ref);
  }
}

String _$authInterceptorHash() => r'594f1673b822a077590b47d55c48c68160ac9ed2';

@ProviderFor(diologInterceptor)
const diologInterceptorProvider = DiologInterceptorProvider._();

final class DiologInterceptorProvider
    extends
        $FunctionalProvider<
          DioLoggingInterceptor,
          DioLoggingInterceptor,
          DioLoggingInterceptor
        >
    with $Provider<DioLoggingInterceptor> {
  const DiologInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diologInterceptorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diologInterceptorHash();

  @$internal
  @override
  $ProviderElement<DioLoggingInterceptor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DioLoggingInterceptor create(Ref ref) {
    return diologInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioLoggingInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioLoggingInterceptor>(value),
    );
  }
}

String _$diologInterceptorHash() => r'5f0f372645192d563a7b9ddbff7e7480e73e682d';

@ProviderFor(dio)
const dioProvider = DioProvider._();

final class DioProvider
    extends $FunctionalProvider<AsyncValue<Dio>, Dio, FutureOr<Dio>>
    with $FutureModifier<Dio>, $FutureProvider<Dio> {
  const DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $FutureProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Dio> create(Ref ref) {
    return dio(ref);
  }
}

String _$dioHash() => r'4cabf90bbf46c33feecd20386e58e707710099d6';

@ProviderFor(apiClient)
const apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiClient>,
          ApiClient,
          FutureOr<ApiClient>
        >
    with $FutureModifier<ApiClient>, $FutureProvider<ApiClient> {
  const ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $FutureProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ApiClient> create(Ref ref) {
    return apiClient(ref);
  }
}

String _$apiClientHash() => r'd511b7e902710217229b37a79de49950eb1cc132';
