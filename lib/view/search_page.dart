import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';

import '../view_models/search_view_model.dart';

/// 検索ページ
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();

  late final SearchViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SearchViewModel(ref, context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(),
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
                    onFieldSubmitted: (value) =>
                        viewModel.performSearch(value), // 検索,
                  ),
                ),
                Container(
                  height: 50.0,
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: _controller.text.isNotEmpty
                        ? () => viewModel.performSearch(_controller.text)
                        : null, // テキストが空の場合はボタンを無効化
                    // 検索
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                    child: state.when(
                        error: (e, stack) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("見つかりませんでした"),
                                ],
                              ),
                            ),
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        data: (data) => ListView.builder(
                              shrinkWrap: true,
                              // ListViewが占めるべき高さを自動で計算
                              physics: NeverScrollableScrollPhysics(),
                              // ListView内のスクロールを無効化
                              itemCount: data.repositoryList.length,
                              itemBuilder: (context, index) {
                                final repository = data.repositoryList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.indigo,
                                    ),
                                    child: ListTile(
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
                                      subtitle: Text(
                                        repository.language,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                      // レポジトリ詳細
                                      onTap: () =>
                                          viewModel.onRepositoryTap(repository),
                                    ),
                                  ),
                                );
                              },
                            )),
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
