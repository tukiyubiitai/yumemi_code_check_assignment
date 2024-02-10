import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/provider/search_notifier.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.blue),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple.shade300),
                  ),
                  labelStyle: const TextStyle(color: Colors.deepPurple)),
            ),
          ),
          Container(
            height: 50.0,
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(searchAsyncNotifierProvider.notifier)
                    .searchRepositories(_controller.text);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Colors.transparent), // 背景色を透明に
                // 影を無効にする
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
                  constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
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
          SingleChildScrollView(
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
                loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                data: (data) => ListView.builder(
                      itemCount: data.repositoryList.length,
                      itemBuilder: (context, index) {
                        final repository = data.repositoryList[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(repository.owner.avatarUrl),
                          ),
                          title: Text(repository.name),
                          subtitle: Text(repository.language),
                          trailing: Icon(Icons.arrow_forward),
                        );
                      },
                    )),
          ),
        ],
      ),
    );
  }
}
