// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayTickTableTable extends PlayTickTable
    with TableInfo<$PlayTickTableTable, PlayTickTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayTickTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'play_tick_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayTickTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayTickTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayTickTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $PlayTickTableTable createAlias(String alias) {
    return $PlayTickTableTable(attachedDatabase, alias);
  }
}

class PlayTickTableData extends DataClass
    implements Insertable<PlayTickTableData> {
  final int id;
  final String title;
  const PlayTickTableData({required this.id, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    return map;
  }

  PlayTickTableCompanion toCompanion(bool nullToAbsent) {
    return PlayTickTableCompanion(id: Value(id), title: Value(title));
  }

  factory PlayTickTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayTickTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  PlayTickTableData copyWith({int? id, String? title}) =>
      PlayTickTableData(id: id ?? this.id, title: title ?? this.title);
  PlayTickTableData copyWithCompanion(PlayTickTableCompanion data) {
    return PlayTickTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayTickTableData(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayTickTableData &&
          other.id == this.id &&
          other.title == this.title);
}

class PlayTickTableCompanion extends UpdateCompanion<PlayTickTableData> {
  final Value<int> id;
  final Value<String> title;
  const PlayTickTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
  });
  PlayTickTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
  }) : title = Value(title);
  static Insertable<PlayTickTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
    });
  }

  PlayTickTableCompanion copyWith({Value<int>? id, Value<String>? title}) {
    return PlayTickTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayTickTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayTickTableTable playTickTable = $PlayTickTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [playTickTable];
}

typedef $$PlayTickTableTableCreateCompanionBuilder =
    PlayTickTableCompanion Function({Value<int> id, required String title});
typedef $$PlayTickTableTableUpdateCompanionBuilder =
    PlayTickTableCompanion Function({Value<int> id, Value<String> title});

class $$PlayTickTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlayTickTableTable> {
  $$PlayTickTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayTickTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayTickTableTable> {
  $$PlayTickTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayTickTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayTickTableTable> {
  $$PlayTickTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);
}

class $$PlayTickTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayTickTableTable,
          PlayTickTableData,
          $$PlayTickTableTableFilterComposer,
          $$PlayTickTableTableOrderingComposer,
          $$PlayTickTableTableAnnotationComposer,
          $$PlayTickTableTableCreateCompanionBuilder,
          $$PlayTickTableTableUpdateCompanionBuilder,
          (
            PlayTickTableData,
            BaseReferences<
              _$AppDatabase,
              $PlayTickTableTable,
              PlayTickTableData
            >,
          ),
          PlayTickTableData,
          PrefetchHooks Function()
        > {
  $$PlayTickTableTableTableManager(_$AppDatabase db, $PlayTickTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayTickTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayTickTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayTickTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
          }) => PlayTickTableCompanion(id: id, title: title),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
          }) => PlayTickTableCompanion.insert(id: id, title: title),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayTickTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayTickTableTable,
      PlayTickTableData,
      $$PlayTickTableTableFilterComposer,
      $$PlayTickTableTableOrderingComposer,
      $$PlayTickTableTableAnnotationComposer,
      $$PlayTickTableTableCreateCompanionBuilder,
      $$PlayTickTableTableUpdateCompanionBuilder,
      (
        PlayTickTableData,
        BaseReferences<_$AppDatabase, $PlayTickTableTable, PlayTickTableData>,
      ),
      PlayTickTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayTickTableTableTableManager get playTickTable =>
      $$PlayTickTableTableTableManager(_db, _db.playTickTable);
}
