import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_providers.g.dart';

@riverpod
GlobalKey<NavigatorState> navigatorKey(Ref ref) {
  return GlobalKey<NavigatorState>();
}

@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}
