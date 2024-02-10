import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_code_check_assignment/models/repository_state.dart';
import 'package:yumemi_code_check_assignment/repository/search_reapository.dart';

import '../models/repository_detail.dart';
import '../token.dart';

part 'search_notifier.g.dart';

@riverpod
class SearchAsyncNotifier extends _$SearchAsyncNotifier {

  SearchRepository get _api => ref.read(searchRepositoryProvider(token));

  @override
  Future<RepositoryState> build() => _loadApi();

  Future<RepositoryState> _loadApi() async {
    final response = await _api.getRepositories();
    return RepositoryState(repositoryList: response);
  }

  Future<void> reloadRepositories()async{
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadApi());
  }

  void addToBookmarklist(RepositoryDetail repositoryDetail) {
    state = AsyncValue.data(state.value!.copyWith(
      bookmarkList: {...state.value!.bookmarkList, repositoryDetail.name},
    ));
  }


}
