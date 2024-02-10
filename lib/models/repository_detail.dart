import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_detail.freezed.dart';
part 'repository_detail.g.dart';

//リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数

@freezed
class RepositoryDetail with _$RepositoryDetail {
  const factory RepositoryDetail({
    required String id,
    required String name,// リポジトリ名
    required String language,// プロジェクト言語
    required int stargazers_count,// star
    required int watchers_count,// watcher
    required int forks_count,// fork
    required int open_issues_count,// issues
    required Owner owner,
  }) = _RepositoryDetail;

  factory RepositoryDetail.fromJson(Map<String, dynamic> json) => _$RepositoryDetailFromJson(json);
}

@freezed
class Owner with _$Owner {
  factory Owner ({
    @JsonKey(name: 'avatar_url') required String avatarUrl,// オーナーアイコン
}) =_Owner;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
}
