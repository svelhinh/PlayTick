import 'package:playtick/core/database/database_provider.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';
import 'package:playtick/features/library/domain/library_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_repository_provider.g.dart';

@riverpod
LibraryRepository libraryRepository(Ref ref) {
  final database = ref.read(databaseProvider);

  return DriftLibraryRepository(database);
}
