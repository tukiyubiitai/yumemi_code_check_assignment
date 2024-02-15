// // テスト対象のNotifierとRepositoryのインポート
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:yumemi_code_check_assignment/models/repository_detail.dart';
// import 'package:yumemi_code_check_assignment/models/repository_state.dart';
// import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';
// import 'package:yumemi_code_check_assignment/repository/search_repository.dart';
//
// // モックの生成
// import 'search_notifier_test.mocks.dart';
//
// // モッククラスの定義
// @GenerateMocks([SearchRepository])
// void main() {
//   // ProviderContainerとモックのセットアップ
//   ProviderContainer setUpProviderContainer(
//       MockSearchRepository mockSearchRepository) {
//     return ProviderContainer(overrides: [
//       searchRepositoryProvider.overrideWithValue(mockSearchRepository),
//     ]);
//   }
//
//   group('SearchAsyncNotifier Tests', () {
//     late MockSearchRepository mockSearchRepository;
//     late ProviderContainer container;
//
//     setUp(() {
//       mockSearchRepository = MockSearchRepository();
//       container = setUpProviderContainer(mockSearchRepository);
//     });
//
//     tearDown(() {
//       container.dispose();
//     });
//
//     test('検索結果が正常に取得できた場合のテスト', () async {
//       // 模擬的な検索結果
//       final mockData = [
//         RepositoryDetail(
//           id: 1,
//           name: "Test Repo",
//           language: "Dart",
//           stargazers_count: 100,
//           watchers_count: 50,
//           forks_count: 20,
//           open_issues_count: 10,
//           owner: Owner(avatarUrl: "https://example.com/avatar.png"),
//         ),
//       ];
//
//       // モックの設定
//       when(mockSearchRepository.searchRepositories(any))
//           .thenAnswer((_) async => mockData);
//
//       // 非同期処理の実行
//       final notifier = container.read(searchAsyncNotifierProvider.notifier);
//       // "flutter"というクエリでリポジトリ検索をシミュレート
//       await notifier.searchRepos("flutter");
//
//       // 状態の検証
//       final state = container.read(searchAsyncNotifierProvider);
//
//       // stateがAsyncData<RepositoryState>型であることを検証
//       expect(state, isA<AsyncData<RepositoryState>>());
//       // state.value?.repositoryListがmockDataと等しいかを検証
//       expect(state.value?.repositoryList, equals(mockData));
//       print(state.value?.repositoryList);
//     });
//
//     test('検索結果の取得に失敗した場合', () async {
//       // エラーを模倣
//       final exception = Exception("Failed to fetch data");
//       when(mockSearchRepository.searchRepositories(any)).thenThrow(exception);
//
//       // Notifierの実行
//       final notifier = container.read(searchAsyncNotifierProvider.notifier);
//       await notifier.searchRepos("flutter");
//
//       // 非同期処理が完了するのを待ってから状態を検証
//       // await Future.delayed(Duration.zero);
//
//       // 状態の検証
//       final state = await container.read(searchAsyncNotifierProvider);
//       await Future.delayed(Duration.zero);
//       expect(state, isA<AsyncError<RepositoryState>>());
//       expect(state.isLoading, isTrue);
//     });
//
//     // 他のテストケース...
//   });
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_code_check_assignment/models/repository_detail.dart';
import 'package:yumemi_code_check_assignment/models/repository_state.dart';
import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';
import 'package:yumemi_code_check_assignment/repository/search_repository.dart';

import 'search_notifier_test.mocks.dart';

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

@GenerateMocks([SearchRepository])
void main() {
  ProviderContainer makeProviderContainer(
      MockSearchRepository searchRepository) {
    final container = ProviderContainer(
      overrides: [
        searchRepositoryProvider.overrideWithValue(searchRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('initial state is AsyncData', () async {
    final searchRepository = MockSearchRepository();

    final container = makeProviderContainer(searchRepository);
    final listener = Listener<AsyncValue<RepositoryState>>();
    container.listen(
      searchAsyncNotifierProvider,
      listener,
      fireImmediately: true,
    );
    await Future.delayed(Duration.zero);

    expect(container.read(searchAsyncNotifierProvider),
        isA<AsyncData<RepositoryState>>());
    return container;
  });

  test('検索結果が正常に取得できた場合のテスト', () async {
    final searchRepository = MockSearchRepository();

    final container = makeProviderContainer(searchRepository);
    // 模擬的な検索結果
    final mockData = [
      RepositoryDetail(
        id: 1,
        name: "Test Repo",
        language: "Dart",
        stargazers_count: 100,
        watchers_count: 50,
        forks_count: 20,
        open_issues_count: 10,
        owner: Owner(avatarUrl: "https://example.com/avatar.png"),
      ),
    ];

    // モックの設定
    when(searchRepository.searchRepositories(any))
        .thenAnswer((_) async => mockData);

    // 非同期処理の実行
    final notifier = container.read(searchAsyncNotifierProvider.notifier);
    // "flutter"というクエリでリポジトリ検索をシミュレート
    await notifier.searchRepos("flutter");

    // 状態の検証
    final state = container.read(searchAsyncNotifierProvider);

    // stateがAsyncData<RepositoryState>型であることを検証
    expect(state, isA<AsyncData<RepositoryState>>());
    // state.value?.repositoryListがmockDataと等しいかを検証
    expect(state.value?.repositoryList, equals(mockData));
    print(state.value?.repositoryList);
  });

  test('fetching data fails with AsyncError', () async {
    final searchRepository = MockSearchRepository();
    final container = makeProviderContainer(searchRepository);

    // 通信が失敗するようにモックの設定
    when(searchRepository.searchRepositories(any))
        .thenThrow(Exception('Failed to fetch data'));

    // searchReposメソッドを呼び出して通信を試みる
    await container
        .read(searchAsyncNotifierProvider.notifier)
        .searchRepos('query');

    final listener = Listener<AsyncValue<RepositoryState>>();
    container.listen(
      searchAsyncNotifierProvider,
      listener,
      fireImmediately: true,
    );

    // 非同期処理の完了を待つ
    await Future.delayed(Duration.zero);

    // 状態がAsyncErrorになっていることを検証
    expect(container.read(searchAsyncNotifierProvider),
        isA<AsyncError<RepositoryState>>());
  });
}
