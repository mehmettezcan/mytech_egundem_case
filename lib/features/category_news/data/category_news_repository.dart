import 'package:dio/dio.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/core/network/endpoints.dart';
import 'package:mytech_egundem_case/features/category_news/data/models/category_news_item.dart';

class CategoryNewsRepository {
  final ApiClient _api;
  CategoryNewsRepository(this._api);

  Future<({List<CategoryNewsItem> items, int total, int page, int pageSize})>
  getCategoryNews({
    required String categoryId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final res = await _api.get(
        '${Endpoints.newsByCategory}/$categoryId',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      final data = res.data;
      if (data is! Map || data['result'] is! Map) {
        throw Exception('Invalid category news response');
      }

      final result = data['result'] as Map;
      final itemsRaw = result['items'];
      if (itemsRaw is! List) throw Exception('Invalid items');

      final items =
          itemsRaw
              .map((e) => CategoryNewsItem.fromJson(e as Map<String, dynamic>))
              .toList();

      return (
        items: items,
        total: (result['total'] as num?)?.toInt() ?? 0,
        page: (result['page'] as num?)?.toInt() ?? page,
        pageSize: (result['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Failed to fetch category news.');
        }
      }

      throw Exception('Failed to fetch category news.');
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
