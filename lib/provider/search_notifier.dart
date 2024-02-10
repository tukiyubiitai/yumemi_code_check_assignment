import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_code_check_assignment/models/repository_state.dart';

import '../key/token.dart';
import '../models/repository_detail.dart';
import '../repository/search_reapository.dart';

part 'search_notifier.g.dart';

@riverpod
class SearchAsyncNotifier extends _$SearchAsyncNotifier {
  SearchRepository get _api => ref.read(searchRepositoryProvider(token));

  @override
  Future<RepositoryState> build() async {
    // 初期状態を設定する。ここでは何もロードしない。
    return RepositoryState(repositoryList: []);
  }

  Future<RepositoryState> _loadApi() async {
    final response = await _api.getRepositories();
    return RepositoryState(repositoryList: response);
  }

  // ユーザーが検索を開始するためのメソッド
  Future<void> searchRepositories(String query) async {
    state = AsyncValue.loading();

    final response = await _api.getRepositories();
    state = AsyncValue.data(RepositoryState(repositoryList: response));
  }

  void addToBookmarklist(RepositoryDetail repositoryDetail) {
    state = AsyncValue.data(state.value!.copyWith(
      bookmarkList: {...state.value!.bookmarkList, repositoryDetail.name},
    ));
  }

  // 選択されたRepositoryをselectedRepositoryの中に入れる
  void updateSelectedRepository(RepositoryDetail repository) {
    state = AsyncValue.data(state.value!.copyWith(
      selectedRepository: repository,
    ));
  }
}

/// 選択されたRepositoryの情報をsearchAsyncNotifierProviderから取得し、RepositoryDetailに値を入れる
@riverpod
RepositoryDetail? selectedRepository(SelectedRepositoryRef ref) {
  try {
    final state =
        ref.watch(searchAsyncNotifierProvider).value!.selectedRepository;
    if (state == null) {
      return null;
    }
    return RepositoryDetail(
        id: state.id,
        name: state.name,
        language: state.language,
        stargazers_count: state.stargazers_count,
        watchers_count: state.watchers_count,
        forks_count: state.forks_count,
        open_issues_count: state.open_issues_count,
        owner: state.owner);
  } catch (e) {
    print(e);
    throw e;
  }
}
