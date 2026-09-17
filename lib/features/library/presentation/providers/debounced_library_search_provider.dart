import 'dart:async';

import 'package:playtick/features/library/presentation/providers/library_search_notifier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debounced_library_search_provider.g.dart';

@riverpod
class DebouncedLibrarySearch extends _$DebouncedLibrarySearch {
  static const duration = Duration(milliseconds: 300);

  Timer? _timer;

  @override
  String build() {
    ref.onDispose(() => _timer?.cancel());
    ref.listen(librarySearchProvider, (_, next) {
      _schedule(next);
    });

    return '';
  }

  void _schedule(String query) {
    _timer?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = '';
      return;
    }

    _timer = Timer(duration, () {
      state = trimmed;
    });
  }
}
