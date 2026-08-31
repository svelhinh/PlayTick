import 'package:playtick/features/library/domain/library_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_filter_notifier_provider.g.dart';

@riverpod
class LibraryFilterNotifier extends _$LibraryFilterNotifier {
  @override
  LibraryFilter build() => LibraryFilter.all;

  void select(LibraryFilter filter) {
    if (state == filter) {
      return;
    }

    state = filter;
  }
}
