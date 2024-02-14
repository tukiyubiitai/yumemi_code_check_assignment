import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:yumemi_code_check_assignment/models/repository_detail.dart';

// ロガーのインスタンス生成
final logger = Logger();

// SearchRepositoryクラスへのProvider
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository();
});

/// GitHub APIとの通信を抽象化するクラスです
///
/// このクラスは、リポジトリの検索機能を提供します。
class SearchRepository {
  /// Dioクライアント
  final Dio _client;

  /// コンストラクタ
  ///
  /// Dioクライアントを生成し、`Authorization` ヘッダーに環境変数から取得した
  /// アクセストークンを設定します。
  SearchRepository({Dio? client})
      : _client = Dio(
          BaseOptions(
            baseUrl: "https://api.github.com/",
            headers: {"Authorization": "Bearer ${dotenv.env['TOKEN']}"},
          ),
        );

  /// GitHub APIを使用して、リポジトリを検索し、結果をリストで返します。
  ///
  /// 引数:
  ///   query: 検索キーワード
  ///
  /// 戻り値:
  ///   検索結果のリポジトリ詳細リスト
  ///
  /// エラー発生時:
  ///   `Future.error` でエラーメッセージを返します。
  Future<List<RepositoryDetail>> searchRepositories(String query) async {
    try {
      // GitHub APIへリクエストを送信し、レスポンスを取得
      final response = await _client.get("search/repositories?q=$query");

      // レスポンスデータから、リポジトリ情報リストを取得
      final List<dynamic> items = response.data["items"];

      // 取得したリポジトリ情報リストを、`RepositoryDetail` オブジェクトのリストに変換
      return items
          .map<RepositoryDetail>((itemMap) =>
              RepositoryDetail.fromJson(itemMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // エラーが発生した場合、エラーログを出力し、エラーメッセージを返す
      logger.e('Error: ${e.toString()}');
      return Future.error("リポジトリの取得に失敗しました: ${e}");
    }
  }
}
