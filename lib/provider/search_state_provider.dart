// ライブラリのインポート
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 自動生成されたファイルのインポート
part 'search_state_provider.g.dart';

/// 検索状態を管理するNotifierです。
///
/// `startSearching` メソッドを使用して検索を開始できます。
///
/// 検索中は `true`、それ以外は `false` を返します。
@riverpod
class SearchStateNotifier extends _$SearchStateNotifier {
  /// 初期状態
  ///
  /// 検索中は `true`、それ以外は `false` を返します。
  @override
  bool build() {
    // 最初は検索していない状態
    return false;
  }

  /// 検索を開始
  void startSearching() {
    // 検索中状態に更新
    state = true;
  }
}
