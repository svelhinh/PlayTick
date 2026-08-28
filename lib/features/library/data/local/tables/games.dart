import 'package:drift/drift.dart';
import 'package:playtick/features/library/data/local/converters/string_list_converter.dart';

@DataClassName('GameRow')
class Games extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get summary => text().nullable()();
  DateTimeColumn get releaseDate => dateTime().nullable()();
  TextColumn get genres => text().map(const StringListConverter())();
  TextColumn get platforms => text().map(const StringListConverter())();
  TextColumn get developer => text().nullable()();
  TextColumn get publisher => text().nullable()();
  IntColumn get estimatedPlaytimesStory => integer().nullable()();
  IntColumn get estimatedPlaytimesMain => integer().nullable()();
  IntColumn get estimatedPlaytimesCompletion => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
