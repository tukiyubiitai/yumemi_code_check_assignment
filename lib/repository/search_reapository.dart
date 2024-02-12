import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/models/repository_detail.dart';

final searchRepositoryProvider = Provider.family<SearchRepository, String>(
  (_, token) => SearchRepository(),
);

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
    } on DioException catch (e) {
      // DioErrorを処理する
      print(e);
      throw e;
    }
  }

  //検索データ取得処理
  Future<List<RepositoryDetail>> searchRepositories(String keyWords) async {
    if (keyWords.isNotEmpty) {
      // 追加の書籍を読み込むメソッド
      defaultWord = keyWords;
      return getRepositories(query: defaultWord); // 更新されたページ番号でAPIを呼び出す
    }
    // keywordがnullの時
    return getRepositories();
  }
}
