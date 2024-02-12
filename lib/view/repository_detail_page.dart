import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';

import '../provider/theme_provider.dart';

class RepositoryDetailPage extends ConsumerWidget {
  const RepositoryDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 選択されたrepositoryを入れる
    final repository = ref.watch(selectedRepositoryProvider);

    // ダークモードの実装
    final isLightTheme = ref.watch(themeProvider);

    // 再利用されるテキストスタイル
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
          Switch(
            value: isLightTheme,
            onChanged: (value) =>
                ref.read(themeProvider.notifier).state = value,
          ),
        ],
      ),
      body: repository != null
          ? Column(
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
                          CircleAvatar(
                            maxRadius: 38,
                            backgroundImage:
                                NetworkImage(repository.owner.avatarUrl),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(repository.name,
                                    style: textStyleWhiteBold.copyWith(
                                        fontSize: 25),
                                    maxLines: 2),
                                const SizedBox(height: 2),
                                Text(repository.language,
                                    style: textStyleWhiteBold.copyWith(
                                        fontSize: 15),
                                    maxLines: 1),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_fullscreen,
                                color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 18),
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
