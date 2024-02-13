import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';
import 'package:yumemi_code_check_assignment/provider/search_state_provider.dart';
import 'package:yumemi_code_check_assignment/view/repository_detail_page.dart';

import '../provider/theme_provider.dart';

/// 検索ページ
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchAsyncNotifierProvider);
    final isLightTheme = ref.watch(themeProvider); // テーマ
    final isSearched = ref.watch(searchNotifierProvider); // 検索の状態

    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
            value: isLightTheme,
            onChanged: (value) =>
                ref.read(themeProvider.notifier).state = value,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 15.0,
                  ),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.search_rounded, color: Colors.blue),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple.shade300),
                        ),
                        labelStyle: const TextStyle(color: Colors.deepPurple)),
                  ),
                ),
                Container(
                  height: 50.0,
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: _controller.text.isNotEmpty
                        ? () {
                            FocusScope.of(context).unfocus(); // キーボードを閉じる

                            //検索処理
                            ref
                                .read(searchAsyncNotifierProvider.notifier)
                                .searchRepos(_controller.text);

                            //検索を開始
                            ref
                                .read(searchNotifierProvider.notifier)
                                .startSearching();
                          }
                        : null, // textに入力されていない場合は検索できない
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.transparent), // 背景色を透明に
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "検索",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: state.when(
                        error: (e, stack) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("問題が発生しました"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        //再読み込み処理
                                        ref
                                            .read(searchAsyncNotifierProvider
                                                .notifier)
                                            .searchRepos(_controller.text);
                                      },
                                      child: Text("やり直す"))
                                ],
                              ),
                            ),
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        data: (data) {
                          // 検索が実行されていない場合は何も表示しない
                          if (!isSearched) {
                            return SizedBox.shrink(); // 何も表示しない
                          }
                          // 検索が実行されていて、検索結果がない場合はメッセージを表示
                          if (data.repositoryList.isEmpty) {
                            return Center(
                                child: Text(
                              "リポジトリが見つかりませんでした",
                              style: TextStyle(
                                color:
                                    isLightTheme ? Colors.black : Colors.white,
                                fontSize: 18,
                              ),
                            ));
                          }
                          // 検索結果をリストで表示
                          return ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: data.repositoryList.length,
                            itemBuilder: (context, index) {
                              final repository = data.repositoryList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OpenContainer(
                                  closedElevation: 0,
                                  closedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  closedColor: Colors.indigo,
                                  closedBuilder: (BuildContext context,
                                      VoidCallback openContainer) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            repository.owner.avatarUrl),
                                      ),
                                      title: Text(
                                        repository.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(repository.language,
                                          style:
                                              TextStyle(color: Colors.white)),
                                      trailing: Icon(Icons.expand,
                                          color: Colors.white),
                                    );
                                  },
                                  openBuilder:
                                      (BuildContext context, VoidCallback _) {
                                    // Futureを使ってビルドフェーズが完了した後に状態変更
                                    Future(() {
                                      ref
                                          .read(searchAsyncNotifierProvider
                                              .notifier)
                                          .updateSelectedRepository(repository);
                                    });

                                    return RepositoryDetailPage();
                                  },
                                ),
                              );
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
