import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_detail.freezed.dart';
part 'repository_detail.g.dart';

@freezed
class RepositoryDetail with _$RepositoryDetail {
  const factory RepositoryDetail({
    required String name,
    required String ownerIcon,
    required String language,
    required int stars,
    required int watchers,
    required int forks,
    required int issues,
  }) = _RepositoryDetail;

  factory RepositoryDetail.fromJson(Map<String, dynamic> json) => _$RepositoryDetailFromJson(json);
}
