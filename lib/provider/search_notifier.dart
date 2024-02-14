import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_code_check_assignment/models/repository_state.dart';

import '../models/repository_detail.dart';
import '../repository/search_repository.dart';

// 自動生成されたファイルのインポート
part 'search_notifier.g.dart';

/// 検索機能を提供するAsyncNotifierです。
///
/// ユーザーは `searchRepos` メソッドを使用して検索を開始できます。
/// 検索結果は `state` プロパティで取得できます。
///
/// 選択されたリポジトリは `selectedRepository` プロパティで取得できます。
@riverpod
class SearchAsyncNotifier extends _$SearchAsyncNotifier {
  SearchRepository get _api => ref.read(searchRepositoryProvider);

  // ロガーのインスタンス生成
  final logger = Logger();

  /// 初期化処理
  ///
  /// 初期状態を設定する。ここでは何もロードしない。
  @override
  Future<RepositoryState> build() async {
    // 初期状態を生成
    return RepositoryState(repositoryList: []);
  }

  /// ユーザーが検索を開始するためのメソッド
  Future<void> searchRepos(String query) async {
    // 検索開始を通知
    state = AsyncValue.loading();

    // API通信を行い、検索結果を取得
    try {
      final response = await _api.searchRepositories(query);

      // 検索結果を状態に保存
      state = AsyncValue.data(RepositoryState(repositoryList: response));
    } catch (e, stack) {
      // エラー処理
      logger.e(
          'Error: ${e.toString()}\nStack trace: ${stack.toString()}'); // 先頭200文字だけ出力
      state = AsyncValue.error(e, stack); // エラー状態を view に伝える

      print(state.runtimeType);
    }
  }

  /// 選択されたリポジトリを更新
  void updateSelectedRepository(RepositoryDetail repository) {
    // 現在の状態を取得
    final currentValue = state.value;

    // currentValue が null の場合は何もしない
    if (currentValue == null) {
      return;
    }

    // currentValue をコピーし、`selectedRepository` を更新
    final updatedState = currentValue.copyWith(
      selectedRepository: repository,
    );

    // 状態を更新
    state = AsyncValue.data(updatedState);
  }

  /// 選択されたRepository情報をsearchAsyncNotifierProviderから取得し、RepositoryDetailに値を入れる
  RepositoryDetail? selectedRepository() {
    final asyncValue = state.value;

    if (asyncValue == null) {
      return null;
    }

    final selectedRepository = asyncValue.selectedRepository;

    if (selectedRepository == null) {
      return null;
    }

    return RepositoryDetail(
        id: selectedRepository.id,
        // リポジトリのID
        name: selectedRepository.name,
        // リポジトリの名前
        language: selectedRepository.language,
        // 使用されているプログラミング言語
        stargazers_count: selectedRepository.stargazers_count,
        // スターの数
        watchers_count: selectedRepository.watchers_count,
        // ウォッチャーの数
        forks_count: selectedRepository.forks_count,
        // フォークの数
        open_issues_count: selectedRepository.open_issues_count,
        // オープンされているイシューの数
        owner: selectedRepository.owner);
  }
}
