

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/models/repository_detail.dart';

final searchRepositoryProvider = Provider.family<SearchRepository, String>(
      (_, token) => SearchRepository(token),
);

class SearchRepository{
  SearchRepository(this.token);

  final String token;


  Dio get _client => Dio(
    BaseOptions(
      baseUrl: "https://api.github.com/",
      headers: {"Authorization": "Bearer $token"},
    ),
  );

  Future<List<RepositoryDetail>> getRepositories({String query = "flutter"}) async {
    try {
      final result = await _client.get("search/repositories?q=$query");
      final List<dynamic> items = result.data["items"];
      return items.map<RepositoryDetail>((itemMap) => RepositoryDetail.fromJson(itemMap as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      // DioErrorを処理する
      print(e);
      return [];
    }
  }

}