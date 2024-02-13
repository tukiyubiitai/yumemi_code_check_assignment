import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:yumemi_code_check_assignment/models/repository_detail.dart';

final searchRepositoryProvider = Provider.family<SearchRepository, String>(
  (_, token) => SearchRepository(),
);

final logger = Logger();

class SearchRepository {
  SearchRepository();

  // .envからアクセストークンを取得
  final token = dotenv.env['TOKEN'];

  //デフォルトはflutter　で検索される
  String defaultWord = "flutter";

  Dio get _client => Dio(
        BaseOptions(
          baseUrl: "https://api.github.com/",
          headers: {"Authorization": "Bearer $token"},
        ),
      );

  Future<List<RepositoryDetail>> getRepositories(
      {String query = "flutter"}) async {
    try {
      final result = await _client.get("search/repositories?q=$query");
      final List<dynamic> items = result.data["items"];
      return items
          .map<RepositoryDetail>((itemMap) =>
              RepositoryDetail.fromJson(itemMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logger.e('Error: ${e.toString()}');
      return Future.error("リポジトリの取得に失敗しました: ${e}"); // エラーメッセージを返す
    }
  }

  //検索データ取得処理
  Future<List<RepositoryDetail>> searchRepositories(String keyWords) async {
    defaultWord = keyWords; // デフォルトキーワードを書き換え
    return getRepositories(query: defaultWord); // 検索処理
  }
}
