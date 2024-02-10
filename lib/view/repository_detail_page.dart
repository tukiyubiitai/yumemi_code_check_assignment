import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';

//リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数
/// 詳細ページ

class RepositoryDetailPage extends ConsumerWidget {
  const RepositoryDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(selectedRepositoryProvider);
    return Scaffold(
      appBar: AppBar(),
      body: repository != null
          ? Center(
              child: Text(repository.name),
            )
          : SizedBox(),
    );
  }
}
