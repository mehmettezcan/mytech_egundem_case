import 'package:dio/dio.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/core/network/endpoints.dart';
import 'package:mytech_egundem_case/features/home/data/models/category_with_news_model.dart';

class HomeRepository {
  final ApiClient _api;
  HomeRepository(this._api);

  Future<List<CategoryWithNews>> getCategoriesWithNews({
    required int page,
    required int pageSize,
    required bool isLatest,
    required bool forYou,
  }) async {
    try {
      final res = await _api.get(
        Endpoints.categoryNews,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'isLatest': isLatest,
          'forYou': forYou,
        },
      );

      final data = res.data;
      if (data is! Map ||
          data['result'] is! Map ||
          (data['result'] as Map)['items'] is! List) {
        throw Exception('Invalid categories-with-news response');
      }

      final items = (data['result'] as Map)['items'] as List;
      return items
          .map((e) => CategoryWithNews.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Failed to fetch categories with news.');
        }
      }

      throw Exception('Failed to fetch categories with news.');
    }
  }

  Future<void> toggleSave({
    required String newsId,
    required bool shouldSave,
  }) async {
    try {
      if (shouldSave) {
        await _api.post(Endpoints.savedNews, data: {'newsId': newsId});
      } else {
        await _api.delete('${Endpoints.savedNews}/$newsId');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Failed to update saved news.');
        }
      }

      throw Exception('Failed to update saved news.');
    }
  }
}
