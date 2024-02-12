import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_code_check_assignment/provider/theme_provider.dart';
import 'package:yumemi_code_check_assignment/view/search_page.dart';

Future main() async {
  // .envファイルを読み取るため
  await dotenv.load(fileName: ".env");

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightTheme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: isLightTheme ? ThemeData.light() : ThemeData.dark(),
      home: SearchPage(),
    );
  }
}
