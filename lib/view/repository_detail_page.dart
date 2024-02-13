import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';

import '../provider/theme_provider.dart';

/// リポジトリ詳細画面
class RepositoryDetailPage extends ConsumerWidget {
  const RepositoryDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 選択されたリポジトリの情報を取得
    final repository = ref.watch(selectedRepositoryProvider);

    // テーマの状態を取得
    final isLightTheme = ref.watch(themeProvider);

    // 再利用されるテキストスタイルを定義
    final textStyleWhiteBold =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    final textStyleWhiteNormal =
        TextStyle(color: Colors.white, fontWeight: FontWeight.normal);

    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        actions: [
          // テーマ切り替えスイッチ
          Switch(
            value: isLightTheme,
            onChanged: (value) =>
                ref.read(themeProvider.notifier).state = value,
          ),
        ],
      ),
      body: repository != null
          ? // リポジトリが取得できた場合の表示
          Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // リポジトリオーナーのアバター画像
                          CircleAvatar(
                            maxRadius: 38,
                            backgroundImage:
                                NetworkImage(repository.owner.avatarUrl),
                          ),
                          const SizedBox(width: 20),
                          // リポジトリ名と言語
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(repository.name,
                                    style: textStyleWhiteBold.copyWith(
                                        fontSize: 25),
                                    maxLines: 2), // リポジトリ名
                                const SizedBox(height: 2),
                                Text(repository.language,
                                    style: textStyleWhiteBold.copyWith(
                                        fontSize: 15),
                                    maxLines: 1), // 言語
                              ],
                            ),
                          ),
                          // 閉じるボタン
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_fullscreen,
                                color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 18),
                      // リポジトリの統計情報
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoColumn(
                              repository.stargazers_count.toString(),
                              "Star",
                              textStyleWhiteBold,
                              textStyleWhiteNormal),
                          _buildInfoColumn(
                              repository.watchers_count.toString(),
                              "Watcher",
                              textStyleWhiteBold,
                              textStyleWhiteNormal),
                          _buildInfoColumn(repository.forks_count.toString(),
                              "Fork", textStyleWhiteBold, textStyleWhiteNormal),
                          _buildInfoColumn(
                              repository.open_issues_count.toString(),
                              "Issue",
                              textStyleWhiteBold,
                              textStyleWhiteNormal),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("エラーが発生しました　もう一度やり直して下さい",
                  style: TextStyle(color: Colors.redAccent)),
            )),
    );
  }

  Column _buildInfoColumn(
      String value, String label, TextStyle valueStyle, TextStyle labelStyle) {
    return Column(
      children: [
        Text(value, style: valueStyle),
        Text(label, style: labelStyle),
      ],
    );
  }
}
