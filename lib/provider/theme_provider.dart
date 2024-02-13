import 'package:flutter_riverpod/flutter_riverpod.dart';

// ダークモード状態管理用のProvider
///
/// アプリのテーマがダークモードかどうかを管理します。
///
/// デフォルトではライトモード
final themeProvider = StateProvider<bool>((ref) => true);
