import 'dart:convert';
import 'package:mytech_egundem_case/features/home/data/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopularNewsCache {
  static const _kTs = 'popular_news_ts';
  static const _kData = 'popular_news_data';
  static const ttl = Duration(hours: 1);

  final SharedPreferences prefs;
  PopularNewsCache(this.prefs);

  List<NewsItem>? getIfValid() {
    final ts = prefs.getInt(_kTs);
    final raw = prefs.getString(_kData);

    if (ts == null || raw == null) return null;

    final savedAt = DateTime.fromMillisecondsSinceEpoch(ts);
    final isExpired = DateTime.now().difference(savedAt) > ttl;
    if (isExpired) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;

    return decoded
        .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<NewsItem> items) async {
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setInt(_kTs, DateTime.now().millisecondsSinceEpoch);
    await prefs.setString(_kData, raw);
  }

  Future<void> clear() async {
    await prefs.remove(_kTs);
    await prefs.remove(_kData);
  }
}
