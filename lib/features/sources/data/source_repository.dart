import 'package:dio/dio.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/core/network/endpoints.dart';
import 'package:mytech_egundem_case/features/sources/data/models/follow_source_dto.dart';
import 'package:mytech_egundem_case/features/sources/data/models/news_source.dart';

class SourceRepository {
  final ApiClient _api;
  SourceRepository(this._api);

  Future<List<NewsSource>> getAllSources() async {
    try {
      final res = await _api.get(Endpoints.sources);

      final data = res.data;
      if (data is! Map || data['result']['sources'] is! List) {
        throw Exception('Invalid sources response');
      }

      return (data['result']['sources'] as List)
          .map((e) => NewsSource.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Failed to fetch sources.');
        }
      }

      throw Exception('Failed to fetch sources.');
    }
  }

  Future<void> syncFollowedSources(List<FollowSourceDto> items) async {
    try {
      await _api.post(
        Endpoints.sourcesFollowBulk,
        data: items.map((e) => e.toJson()).toList(),
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(
            data['message'] ?? 'Failed to sync followed sources.',
          );
        }
      }

      throw Exception('Failed to sync followed sources.');
    }
  }
}
