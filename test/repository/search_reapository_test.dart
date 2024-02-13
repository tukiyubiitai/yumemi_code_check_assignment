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
    test('should return a list of repositories when API request succeeds',
        () async {
      await dotenv.load(fileName: ".env");
      final client = MockDio();
      final searchRepository = SearchRepository(client: client);
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
      // searchRepositoriesメソッドを実行
      final result = await searchRepository.searchRepositories('flutter');

      // 結果を検証
      expect(result, isA<List<RepositoryDetail>>());
      expect(result.isNotEmpty, true);
      expect(result.first.name, equals('flutter'));
      print(result);
    });

    test('should return a list of repositories when API request succeeds',
        () async {
      await dotenv.load(fileName: ".env");
      final dio = Dio(BaseOptions(
        baseUrl: "https://api.github.com/",
        headers: {"Authorization": "Bearer ${dotenv.env['TOKEN']}"},
      ));
      final dioAdapter = DioAdapter(dio: dio);

      // モック化するリクエスト先のパス。baseUrlに続く部分のみを指定します。
      const path = "search/repositories?q=flutter";

      // DioAdapterを使って、特定のパスに対するGETリクエストのモッキング設定を行います。
      dioAdapter.onGet(
        path, // 修正: dioから正しいパスに変更
        (server) => server.reply(
          200,
          {'message': 'Success!'},
        ),
      );

      // モックレスポンスの設定をしたパスに対してリクエストを送り、レスポンスを取得します。
      final response = await dio.get(path);

      // レスポンスの内容を確認します。
      print(response.data); // {message: Success!}
      // レスポンスのステータスコードが200であることを検証します。
      expect(response.statusCode, 200);
      // レスポンスのボディが{'message': 'Success!'}であることを検証します。
      expect(response.data, {'message': 'Success!'});
    });

    test('should return an error if the API request fails', () async {
      await dotenv.load(fileName: ".env");
      final dio = Dio(BaseOptions(
        baseUrl: "https://api.github.com/",
        headers: {"Authorization": "Bearer ${dotenv.env['TOKEN']}"},
      ));
      final dioAdapter = DioAdapter(dio: dio);

      // モック化するリクエスト先のパス。baseUrlに続く部分のみを指定します。
      const path = "search/repositories?q=flutter";

      // 指定したパスに対するGETリクエストが失敗した場合のモックを設定
      dioAdapter.onGet(
        path,
        (server) => server.reply(
          404, // HTTP ステータスコード
          {'message': 'Not Found'}, // レスポンスボディ
        ),
      );

      // テスト実行
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
