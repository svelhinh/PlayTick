import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_search_notifier_provider.g.dart';

@riverpod
class LibrarySearchNotifier extends _$LibrarySearchNotifier {
  @override
  String build() => '';

  void search(String query) {
    if (state == query) {
      return;
    }

    state = query;
  }
}
