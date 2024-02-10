import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yumemi_code_check_assignment/models/repository_detail.dart';
part 'repository_state.freezed.dart';

@freezed
class RepositoryState with _$RepositoryState {
  const factory RepositoryState({
    @Default([]) List<RepositoryDetail> repositoryList,
    @Default({}) Set<String> bookmarkList,
    RepositoryDetail? selectedRepository, // 選択されたリポジトリ
  }) = _RepositoryState;
}
