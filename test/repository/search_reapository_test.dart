import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_code_check_assignment/models/repository_detail.dart';
import 'package:yumemi_code_check_assignment/repository/search_repository.dart';

import '../main_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
main() {
  group("SearchRepository", () {
    // テストケース1: APIリクエストが成功し、モックレスポンスを通じて正しいリポジトリリストが返されることを検証
    test('API request success with mock response returns valid repository list',
        () async {
      await dotenv.load(fileName: ".env"); // 環境変数をロード
      final client = MockDio(); // Dioのモックインスタンスを作成
      final searchRepository =
          SearchRepository(client: client); // モックを注入してSearchRepositoryをインスタンス化

      // モックレスポンスの設定: 正しいデータ構造を持つレスポンスを返すように指定
      when(client.get(any)).thenAnswer((_) async => Response(
            data: {
              "items": [
                {
                  "id": 12345,
                  "name": "flutter",
                  "forks_count": 54321,
                  "watchers_count": 4321,
                  "open_issues_count": 4321,
                  "owner": {"avatar_url": "flutter"},
                  "stargazers_count": 100000,
                  "language": "Dart",
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await searchRepository
          .searchRepositories('flutter'); // リポジトリ検索メソッドを実行

      // 期待される結果を検証
      expect(result,
          isA<List<RepositoryDetail>>()); // resultがRepositoryDetailのリストであること
      expect(result.isNotEmpty, true); // リストが空でないこと
      expect(
          result.first.name, equals('flutter')); // 最初のリポジトリの名前が'flutter'であること
    });

    // テストケース2: DioAdapterを使用してAPIリクエストが成功し、期待されるレスポンスデータが返されることを検証
    test('API request success directly via Dio returns valid response data',
        () async {
      await dotenv.load(fileName: ".env");
      final dio = Dio(BaseOptions(
        baseUrl: "https://api.github.com/",
        headers: {"Authorization": "Bearer ${dotenv.env['TOKEN']}"},
      ));
      final dioAdapter = DioAdapter(dio: dio);

      const path = "search/repositories?q=flutter"; // リクエスト先のパス
      // DioAdapterを使って特定のパスに対するGETリクエストのモッキング設定を行う
      dioAdapter.onGet(
        path,
        (server) => server.reply(200, {'message': 'Success!'}),
      );

      final response = await dio.get(path); // リクエストを送信し、レスポンスを取得

      // レスポンス内容の検証
      print(response.data); // コンソールにレスポンスデータを出力
      expect(response.statusCode, 200); // ステータスコードが200であること
      expect(response.data,
          {'message': 'Success!'}); // レスポンスボディが{'message': 'Success!'}であること
    });

    // テストケース3: APIリクエストが失敗した場合にエラーレスポンスが返されることを検証
    test('API request failure returns error response', () async {
      await dotenv.load(fileName: ".env");
      final dio = Dio(BaseOptions(
        baseUrl: "https://api.github.com/",
        headers: {"Authorization": "Bearer ${dotenv.env['TOKEN']}"},
      ));
      final dioAdapter = DioAdapter(dio: dio);

      const path = "search/repositories?q=flutter"; // 失敗が期待されるリクエストパス

      // GETリクエストが失敗した場合のモックを設定
      dioAdapter.onGet(
        path,
        (server) => server.reply(404, {'message': 'Not Found'}),
      );

      // テスト実行: リクエストが失敗し、適切なエラーがスローされることを検証
      expect(
        dio.get(path),
        throwsA(
          predicate<DioException>((error) =>
              error.response?.statusCode == 404 &&
              error.response?.data['message'] == 'Not Found'),
        ),
      );
    });
  });
}
