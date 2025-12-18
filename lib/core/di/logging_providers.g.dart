// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logging_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appLog)
const appLogProvider = AppLogProvider._();

final class AppLogProvider
    extends
        $FunctionalProvider<
          Loggy<LoggyType>,
          Loggy<LoggyType>,
          Loggy<LoggyType>
        >
    with $Provider<Loggy<LoggyType>> {
  const AppLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLogHash();

  @$internal
  @override
  $ProviderElement<Loggy<LoggyType>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Loggy<LoggyType> create(Ref ref) {
    return appLog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Loggy<LoggyType> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Loggy<LoggyType>>(value),
    );
  }
}

String _$appLogHash() => r'c049ee74e73a17d3aedf247660729993c9596436';

@ProviderFor(log)
const logProvider = LogFamily._();

final class LogProvider
    extends
        $FunctionalProvider<
          Loggy<LoggyType>,
          Loggy<LoggyType>,
          Loggy<LoggyType>
        >
    with $Provider<Loggy<LoggyType>> {
  const LogProvider._({
    required LogFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'logProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$logHash();

  @override
  String toString() {
    return r'logProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Loggy<LoggyType>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Loggy<LoggyType> create(Ref ref) {
    final argument = this.argument as String;
    return log(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Loggy<LoggyType> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Loggy<LoggyType>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LogProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$logHash() => r'7f6c5fe9106b3ba69d3690621fe94e4fc1988d73';

final class LogFamily extends $Family
    with $FunctionalFamilyOverride<Loggy<LoggyType>, String> {
  const LogFamily._()
    : super(
        retry: null,
        name: r'logProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LogProvider call(String tag) => LogProvider._(argument: tag, from: this);

  @override
  String toString() => r'logProvider';
}
