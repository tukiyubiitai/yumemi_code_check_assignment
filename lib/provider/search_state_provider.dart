import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_state_provider.g.dart';

@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  bool build() {
    return false;
  }

  void startSearching() {
    state = true;
  }

  void endSearching() {
    state = false;
  }
}
