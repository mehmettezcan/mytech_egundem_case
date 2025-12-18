import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:loggy/loggy.dart';

part 'logging_providers.g.dart';

@riverpod
Loggy appLog(Ref ref) => Loggy('EgundemApp');

@riverpod
Loggy log(Ref ref, String tag) {
  return Loggy(tag);
}
