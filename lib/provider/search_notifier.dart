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

  Future<void> reloadRepositories() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadApi());
  }

  void addToBookmarklist(RepositoryDetail repositoryDetail) {
    state = AsyncValue.data(state.value!.copyWith(
      bookmarkList: {...state.value!.bookmarkList, repositoryDetail.name},
    ));
  }
}
