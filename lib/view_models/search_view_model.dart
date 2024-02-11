import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';
import 'package:yumemi_code_check_assignment/view/repository_detail_page.dart';

import '../models/repository_detail.dart';

class SearchViewModel {
  final WidgetRef ref;
  final BuildContext context;

  SearchViewModel(this.ref, this.context);

  /// 検索処理
  void performSearch(String query) {
    FocusScope.of(context).unfocus(); // キーボードを閉じる
    // 検索処理を実行
    ref.read(searchAsyncNotifierProvider.notifier).searchRepositories(query);
  }

  /// 選択されたrepositoryを追加処理
  void onRepositoryTap(RepositoryDetail repository) {
    FocusScope.of(context).unfocus(); // キーボードを閉じる

    // 選択されたrepositoryを追加
    ref
        .read(searchAsyncNotifierProvider.notifier)
        .updateSelectedRepository(repository);

    // 詳細画面へ遷移
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RepositoryDetailPage(),
    ));
  }
}
