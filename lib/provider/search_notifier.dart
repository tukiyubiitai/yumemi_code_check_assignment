import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_code_check_assignment/models/repository_state.dart';

import '../key/token.dart';
import '../models/repository_detail.dart';
import '../repository/search_reapository.dart';

part 'search_notifier.g.dart';

/// 検索機能を提供するAsyncNotifierです。
///
/// ユーザーは `searchRepos` メソッドを使用して検索を開始できます。
/// 検索結果は `state` プロパティで取得できます。
///
/// 選択されたリポジトリは `selectedRepository` プロパティで取得できます。
@riverpod
class SearchAsyncNotifier extends _$SearchAsyncNotifier {
  SearchRepository get _api => ref.read(searchRepositoryProvider(token));

  final logger = Logger();

  @override
  Future<RepositoryState> build() async {
    // 初期状態を設定する。ここでは何もロードしない。
    return RepositoryState(repositoryList: []);
  }

  /// ユーザーが検索を開始するためのメソッド
  Future<void> searchRepos(String query) async {
    // 検索開始を通知し、画面にローディング表示を表示します。
    state = AsyncValue.loading();

    // API通信を行い、検索結果を取得します。
    try {
      final response = await _api.searchRepositories(query);

      // 検索結果を状態に保存し、画面に表示します。
      state = AsyncValue.data(RepositoryState(repositoryList: response));
    } catch (e, stack) {
      // エラーが発生した場合、エラーログを出力し、エラー状態を画面に表示します。
      logger.e(
          'Error: ${e.toString()}\nStack trace: ${stack.toString().substring(0, 200)}'); // 先頭200文字だけ出力
      state = AsyncValue.error(e, stack); // エラー状態を view に伝える
    }
  }

  /// 選択されたリポジトリを `selectedRepository` に更新します。
  void updateSelectedRepository(RepositoryDetail repository) {
    // `state.value` をローカル変数 `currentValue` に代入し、null チェック
    final currentValue = state.value;
    if (currentValue == null) {
      return;
    }

    // `currentValue` をコピーし、`selectedRepository` を更新します。
    final updatedState = currentValue.copyWith(
      selectedRepository: repository,
    );

    // `state` を更新された状態に更新します。
    state = AsyncValue.data(updatedState);
  }
}

/// 選択されたRepository情報をsearchAsyncNotifierProviderから取得し、RepositoryDetailに値を入れる
@riverpod
RepositoryDetail? selectedRepository(SelectedRepositoryRef ref) {
  try {
    // searchAsyncNotifierProviderから現在の状態を取得
    final asyncValue = ref.watch(searchAsyncNotifierProvider).value;

    // asyncValueがnullの場合、何も選択されていないことを意味するので、nullを返す
    if (asyncValue == null) {
      return null;
    }

    // 選択されたリポジトリの情報を取得
    final selectedRepository = asyncValue.selectedRepository;

    // selectedRepositoryがnullの場合、リポジトリが選択されていないか、取得に失敗したことを意味するので、nullを返す
    if (selectedRepository == null) {
      return null;
    }

    // 選択されたリポジトリの詳細情報を持つ新しいRepositoryDetailオブジェクトを作成して返す
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
        owner: selectedRepository.owner); // リポジトリのオーナー情報
  } catch (e) {
    // 何らかのエラーが発生した場合、エラーログを出力し、例外を再スローする
    logger.e('Error: リポジトリ情報の取得に失敗しました'); // エラーログの出力
    throw 'リポジトリ情報の取得に失敗しました';
  }
}
