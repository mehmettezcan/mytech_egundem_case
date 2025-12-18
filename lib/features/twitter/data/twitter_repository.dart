import 'package:dio/dio.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/core/network/endpoints.dart';
import 'package:mytech_egundem_case/features/twitter/data/models/tweet_item.dart';

class TwitterRepository {
  final ApiClient _api;
  TwitterRepository(this._api);

  Future<List<TweetItem>> getTweets({
    required int page,
    required int pageSize,
    required bool isPopular,
  }) async {
    try {
      final res = await _api.get(
        Endpoints.twitterTweets,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'isPopular': isPopular,
        },
      );

      final data = res.data;
      if (data is! Map || data['result'] is! Map) {
        throw Exception('Invalid tweets response');
      }

      final result = data['result'] as Map;

      final itemsRaw = result['items'];

      if (itemsRaw is! List) throw Exception('Invalid tweet items');

      return itemsRaw
          .map((e) => TweetItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Failed to fetch tweets.');
        }
      }

      throw Exception('Failed to fetch tweets.');
    }
  }
}
