// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, GameRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> genres =
      GeneratedColumn<String>(
        'genres',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($GamesTable.$convertergenres);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> platforms =
      GeneratedColumn<String>(
        'platforms',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($GamesTable.$converterplatforms);
  static const VerificationMeta _developerMeta = const VerificationMeta(
    'developer',
  );
  @override
  late final GeneratedColumn<String> developer = GeneratedColumn<String>(
    'developer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedPlaytimesStoryMeta =
      const VerificationMeta('estimatedPlaytimesStory');
  @override
  late final GeneratedColumn<int> estimatedPlaytimesStory =
      GeneratedColumn<int>(
        'estimated_playtimes_story',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _estimatedPlaytimesMainMeta =
      const VerificationMeta('estimatedPlaytimesMain');
  @override
  late final GeneratedColumn<int> estimatedPlaytimesMain = GeneratedColumn<int>(
    'estimated_playtimes_main',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedPlaytimesCompletionMeta =
      const VerificationMeta('estimatedPlaytimesCompletion');
  @override
  late final GeneratedColumn<int> estimatedPlaytimesCompletion =
      GeneratedColumn<int>(
        'estimated_playtimes_completion',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    coverUrl,
    summary,
    releaseDate,
    genres,
    platforms,
    developer,
    publisher,
    estimatedPlaytimesStory,
    estimatedPlaytimesMain,
    estimatedPlaytimesCompletion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    if (data.containsKey('developer')) {
      context.handle(
        _developerMeta,
        developer.isAcceptableOrUnknown(data['developer']!, _developerMeta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('estimated_playtimes_story')) {
      context.handle(
        _estimatedPlaytimesStoryMeta,
        estimatedPlaytimesStory.isAcceptableOrUnknown(
          data['estimated_playtimes_story']!,
          _estimatedPlaytimesStoryMeta,
        ),
      );
    }
    if (data.containsKey('estimated_playtimes_main')) {
      context.handle(
        _estimatedPlaytimesMainMeta,
        estimatedPlaytimesMain.isAcceptableOrUnknown(
          data['estimated_playtimes_main']!,
          _estimatedPlaytimesMainMeta,
        ),
      );
    }
    if (data.containsKey('estimated_playtimes_completion')) {
      context.handle(
        _estimatedPlaytimesCompletionMeta,
        estimatedPlaytimesCompletion.isAcceptableOrUnknown(
          data['estimated_playtimes_completion']!,
          _estimatedPlaytimesCompletionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}release_date'],
      ),
      genres: $GamesTable.$convertergenres.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}genres'],
        )!,
      ),
      platforms: $GamesTable.$converterplatforms.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}platforms'],
        )!,
      ),
      developer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}developer'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      estimatedPlaytimesStory: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_playtimes_story'],
      ),
      estimatedPlaytimesMain: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_playtimes_main'],
      ),
      estimatedPlaytimesCompletion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_playtimes_completion'],
      ),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertergenres =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterplatforms =
      const StringListConverter();
}

class GameRow extends DataClass implements Insertable<GameRow> {
  final int id;
  final String name;
  final String? coverUrl;
  final String? summary;
  final DateTime? releaseDate;
  final List<String> genres;
  final List<String> platforms;
  final String? developer;
  final String? publisher;
  final int? estimatedPlaytimesStory;
  final int? estimatedPlaytimesMain;
  final int? estimatedPlaytimesCompletion;
  const GameRow({
    required this.id,
    required this.name,
    this.coverUrl,
    this.summary,
    this.releaseDate,
    required this.genres,
    required this.platforms,
    this.developer,
    this.publisher,
    this.estimatedPlaytimesStory,
    this.estimatedPlaytimesMain,
    this.estimatedPlaytimesCompletion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    {
      map['genres'] = Variable<String>(
        $GamesTable.$convertergenres.toSql(genres),
      );
    }
    {
      map['platforms'] = Variable<String>(
        $GamesTable.$converterplatforms.toSql(platforms),
      );
    }
    if (!nullToAbsent || developer != null) {
      map['developer'] = Variable<String>(developer);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || estimatedPlaytimesStory != null) {
      map['estimated_playtimes_story'] = Variable<int>(estimatedPlaytimesStory);
    }
    if (!nullToAbsent || estimatedPlaytimesMain != null) {
      map['estimated_playtimes_main'] = Variable<int>(estimatedPlaytimesMain);
    }
    if (!nullToAbsent || estimatedPlaytimesCompletion != null) {
      map['estimated_playtimes_completion'] = Variable<int>(
        estimatedPlaytimesCompletion,
      );
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      name: Value(name),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      genres: Value(genres),
      platforms: Value(platforms),
      developer: developer == null && nullToAbsent
          ? const Value.absent()
          : Value(developer),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      estimatedPlaytimesStory: estimatedPlaytimesStory == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedPlaytimesStory),
      estimatedPlaytimesMain: estimatedPlaytimesMain == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedPlaytimesMain),
      estimatedPlaytimesCompletion:
          estimatedPlaytimesCompletion == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedPlaytimesCompletion),
    );
  }

  factory GameRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      summary: serializer.fromJson<String?>(json['summary']),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
      genres: serializer.fromJson<List<String>>(json['genres']),
      platforms: serializer.fromJson<List<String>>(json['platforms']),
      developer: serializer.fromJson<String?>(json['developer']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      estimatedPlaytimesStory: serializer.fromJson<int?>(
        json['estimatedPlaytimesStory'],
      ),
      estimatedPlaytimesMain: serializer.fromJson<int?>(
        json['estimatedPlaytimesMain'],
      ),
      estimatedPlaytimesCompletion: serializer.fromJson<int?>(
        json['estimatedPlaytimesCompletion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'summary': serializer.toJson<String?>(summary),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
      'genres': serializer.toJson<List<String>>(genres),
      'platforms': serializer.toJson<List<String>>(platforms),
      'developer': serializer.toJson<String?>(developer),
      'publisher': serializer.toJson<String?>(publisher),
      'estimatedPlaytimesStory': serializer.toJson<int?>(
        estimatedPlaytimesStory,
      ),
      'estimatedPlaytimesMain': serializer.toJson<int?>(estimatedPlaytimesMain),
      'estimatedPlaytimesCompletion': serializer.toJson<int?>(
        estimatedPlaytimesCompletion,
      ),
    };
  }

  GameRow copyWith({
    int? id,
    String? name,
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> summary = const Value.absent(),
    Value<DateTime?> releaseDate = const Value.absent(),
    List<String>? genres,
    List<String>? platforms,
    Value<String?> developer = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<int?> estimatedPlaytimesStory = const Value.absent(),
    Value<int?> estimatedPlaytimesMain = const Value.absent(),
    Value<int?> estimatedPlaytimesCompletion = const Value.absent(),
  }) => GameRow(
    id: id ?? this.id,
    name: name ?? this.name,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    summary: summary.present ? summary.value : this.summary,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
    genres: genres ?? this.genres,
    platforms: platforms ?? this.platforms,
    developer: developer.present ? developer.value : this.developer,
    publisher: publisher.present ? publisher.value : this.publisher,
    estimatedPlaytimesStory: estimatedPlaytimesStory.present
        ? estimatedPlaytimesStory.value
        : this.estimatedPlaytimesStory,
    estimatedPlaytimesMain: estimatedPlaytimesMain.present
        ? estimatedPlaytimesMain.value
        : this.estimatedPlaytimesMain,
    estimatedPlaytimesCompletion: estimatedPlaytimesCompletion.present
        ? estimatedPlaytimesCompletion.value
        : this.estimatedPlaytimesCompletion,
  );
  GameRow copyWithCompanion(GamesCompanion data) {
    return GameRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      summary: data.summary.present ? data.summary.value : this.summary,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
      genres: data.genres.present ? data.genres.value : this.genres,
      platforms: data.platforms.present ? data.platforms.value : this.platforms,
      developer: data.developer.present ? data.developer.value : this.developer,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      estimatedPlaytimesStory: data.estimatedPlaytimesStory.present
          ? data.estimatedPlaytimesStory.value
          : this.estimatedPlaytimesStory,
      estimatedPlaytimesMain: data.estimatedPlaytimesMain.present
          ? data.estimatedPlaytimesMain.value
          : this.estimatedPlaytimesMain,
      estimatedPlaytimesCompletion: data.estimatedPlaytimesCompletion.present
          ? data.estimatedPlaytimesCompletion.value
          : this.estimatedPlaytimesCompletion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('summary: $summary, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('genres: $genres, ')
          ..write('platforms: $platforms, ')
          ..write('developer: $developer, ')
          ..write('publisher: $publisher, ')
          ..write('estimatedPlaytimesStory: $estimatedPlaytimesStory, ')
          ..write('estimatedPlaytimesMain: $estimatedPlaytimesMain, ')
          ..write('estimatedPlaytimesCompletion: $estimatedPlaytimesCompletion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    coverUrl,
    summary,
    releaseDate,
    genres,
    platforms,
    developer,
    publisher,
    estimatedPlaytimesStory,
    estimatedPlaytimesMain,
    estimatedPlaytimesCompletion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.coverUrl == this.coverUrl &&
          other.summary == this.summary &&
          other.releaseDate == this.releaseDate &&
          other.genres == this.genres &&
          other.platforms == this.platforms &&
          other.developer == this.developer &&
          other.publisher == this.publisher &&
          other.estimatedPlaytimesStory == this.estimatedPlaytimesStory &&
          other.estimatedPlaytimesMain == this.estimatedPlaytimesMain &&
          other.estimatedPlaytimesCompletion ==
              this.estimatedPlaytimesCompletion);
}

class GamesCompanion extends UpdateCompanion<GameRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> coverUrl;
  final Value<String?> summary;
  final Value<DateTime?> releaseDate;
  final Value<List<String>> genres;
  final Value<List<String>> platforms;
  final Value<String?> developer;
  final Value<String?> publisher;
  final Value<int?> estimatedPlaytimesStory;
  final Value<int?> estimatedPlaytimesMain;
  final Value<int?> estimatedPlaytimesCompletion;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.summary = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.genres = const Value.absent(),
    this.platforms = const Value.absent(),
    this.developer = const Value.absent(),
    this.publisher = const Value.absent(),
    this.estimatedPlaytimesStory = const Value.absent(),
    this.estimatedPlaytimesMain = const Value.absent(),
    this.estimatedPlaytimesCompletion = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.coverUrl = const Value.absent(),
    this.summary = const Value.absent(),
    this.releaseDate = const Value.absent(),
    required List<String> genres,
    required List<String> platforms,
    this.developer = const Value.absent(),
    this.publisher = const Value.absent(),
    this.estimatedPlaytimesStory = const Value.absent(),
    this.estimatedPlaytimesMain = const Value.absent(),
    this.estimatedPlaytimesCompletion = const Value.absent(),
  }) : name = Value(name),
       genres = Value(genres),
       platforms = Value(platforms);
  static Insertable<GameRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? coverUrl,
    Expression<String>? summary,
    Expression<DateTime>? releaseDate,
    Expression<String>? genres,
    Expression<String>? platforms,
    Expression<String>? developer,
    Expression<String>? publisher,
    Expression<int>? estimatedPlaytimesStory,
    Expression<int>? estimatedPlaytimesMain,
    Expression<int>? estimatedPlaytimesCompletion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (summary != null) 'summary': summary,
      if (releaseDate != null) 'release_date': releaseDate,
      if (genres != null) 'genres': genres,
      if (platforms != null) 'platforms': platforms,
      if (developer != null) 'developer': developer,
      if (publisher != null) 'publisher': publisher,
      if (estimatedPlaytimesStory != null)
        'estimated_playtimes_story': estimatedPlaytimesStory,
      if (estimatedPlaytimesMain != null)
        'estimated_playtimes_main': estimatedPlaytimesMain,
      if (estimatedPlaytimesCompletion != null)
        'estimated_playtimes_completion': estimatedPlaytimesCompletion,
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? coverUrl,
    Value<String?>? summary,
    Value<DateTime?>? releaseDate,
    Value<List<String>>? genres,
    Value<List<String>>? platforms,
    Value<String?>? developer,
    Value<String?>? publisher,
    Value<int?>? estimatedPlaytimesStory,
    Value<int?>? estimatedPlaytimesMain,
    Value<int?>? estimatedPlaytimesCompletion,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
      summary: summary ?? this.summary,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      platforms: platforms ?? this.platforms,
      developer: developer ?? this.developer,
      publisher: publisher ?? this.publisher,
      estimatedPlaytimesStory:
          estimatedPlaytimesStory ?? this.estimatedPlaytimesStory,
      estimatedPlaytimesMain:
          estimatedPlaytimesMain ?? this.estimatedPlaytimesMain,
      estimatedPlaytimesCompletion:
          estimatedPlaytimesCompletion ?? this.estimatedPlaytimesCompletion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (genres.present) {
      map['genres'] = Variable<String>(
        $GamesTable.$convertergenres.toSql(genres.value),
      );
    }
    if (platforms.present) {
      map['platforms'] = Variable<String>(
        $GamesTable.$converterplatforms.toSql(platforms.value),
      );
    }
    if (developer.present) {
      map['developer'] = Variable<String>(developer.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (estimatedPlaytimesStory.present) {
      map['estimated_playtimes_story'] = Variable<int>(
        estimatedPlaytimesStory.value,
      );
    }
    if (estimatedPlaytimesMain.present) {
      map['estimated_playtimes_main'] = Variable<int>(
        estimatedPlaytimesMain.value,
      );
    }
    if (estimatedPlaytimesCompletion.present) {
      map['estimated_playtimes_completion'] = Variable<int>(
        estimatedPlaytimesCompletion.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('summary: $summary, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('genres: $genres, ')
          ..write('platforms: $platforms, ')
          ..write('developer: $developer, ')
          ..write('publisher: $publisher, ')
          ..write('estimatedPlaytimesStory: $estimatedPlaytimesStory, ')
          ..write('estimatedPlaytimesMain: $estimatedPlaytimesMain, ')
          ..write('estimatedPlaytimesCompletion: $estimatedPlaytimesCompletion')
          ..write(')'))
        .toString();
  }
}

class $UserGamesTable extends UserGames
    with TableInfo<$UserGamesTable, UserGameRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GameStatus>($UserGamesTable.$converterstatus);
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [gameId, status, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_games';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserGameRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId};
  @override
  UserGameRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGameRow(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      status: $UserGamesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $UserGamesTable createAlias(String alias) {
    return $UserGamesTable(attachedDatabase, alias);
  }

  static TypeConverter<GameStatus, String> $converterstatus =
      const GameStatusConverter();
}

class UserGameRow extends DataClass implements Insertable<UserGameRow> {
  final int gameId;
  final GameStatus status;
  final DateTime addedAt;
  const UserGameRow({
    required this.gameId,
    required this.status,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<int>(gameId);
    {
      map['status'] = Variable<String>(
        $UserGamesTable.$converterstatus.toSql(status),
      );
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  UserGamesCompanion toCompanion(bool nullToAbsent) {
    return UserGamesCompanion(
      gameId: Value(gameId),
      status: Value(status),
      addedAt: Value(addedAt),
    );
  }

  factory UserGameRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGameRow(
      gameId: serializer.fromJson<int>(json['gameId']),
      status: serializer.fromJson<GameStatus>(json['status']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<int>(gameId),
      'status': serializer.toJson<GameStatus>(status),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  UserGameRow copyWith({int? gameId, GameStatus? status, DateTime? addedAt}) =>
      UserGameRow(
        gameId: gameId ?? this.gameId,
        status: status ?? this.status,
        addedAt: addedAt ?? this.addedAt,
      );
  UserGameRow copyWithCompanion(UserGamesCompanion data) {
    return UserGameRow(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      status: data.status.present ? data.status.value : this.status,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserGameRow(')
          ..write('gameId: $gameId, ')
          ..write('status: $status, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, status, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGameRow &&
          other.gameId == this.gameId &&
          other.status == this.status &&
          other.addedAt == this.addedAt);
}

class UserGamesCompanion extends UpdateCompanion<UserGameRow> {
  final Value<int> gameId;
  final Value<GameStatus> status;
  final Value<DateTime> addedAt;
  const UserGamesCompanion({
    this.gameId = const Value.absent(),
    this.status = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  UserGamesCompanion.insert({
    this.gameId = const Value.absent(),
    required GameStatus status,
    required DateTime addedAt,
  }) : status = Value(status),
       addedAt = Value(addedAt);
  static Insertable<UserGameRow> custom({
    Expression<int>? gameId,
    Expression<String>? status,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (status != null) 'status': status,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  UserGamesCompanion copyWith({
    Value<int>? gameId,
    Value<GameStatus>? status,
    Value<DateTime>? addedAt,
  }) {
    return UserGamesCompanion(
      gameId: gameId ?? this.gameId,
      status: status ?? this.status,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $UserGamesTable.$converterstatus.toSql(status.value),
      );
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGamesCompanion(')
          ..write('gameId: $gameId, ')
          ..write('status: $status, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $PlaySessionsTable extends PlaySessions
    with TableInfo<$PlaySessionsTable, PlaySessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaySessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_games (game_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, gameId, date, duration, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'play_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaySessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaySessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaySessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PlaySessionsTable createAlias(String alias) {
    return $PlaySessionsTable(attachedDatabase, alias);
  }
}

class PlaySessionRow extends DataClass implements Insertable<PlaySessionRow> {
  final int id;
  final int gameId;
  final DateTime date;
  final int duration;
  final String? note;
  const PlaySessionRow({
    required this.id,
    required this.gameId,
    required this.date,
    required this.duration,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['date'] = Variable<DateTime>(date);
    map['duration'] = Variable<int>(duration);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PlaySessionsCompanion toCompanion(bool nullToAbsent) {
    return PlaySessionsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      date: Value(date),
      duration: Value(duration),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PlaySessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaySessionRow(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      date: serializer.fromJson<DateTime>(json['date']),
      duration: serializer.fromJson<int>(json['duration']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'date': serializer.toJson<DateTime>(date),
      'duration': serializer.toJson<int>(duration),
      'note': serializer.toJson<String?>(note),
    };
  }

  PlaySessionRow copyWith({
    int? id,
    int? gameId,
    DateTime? date,
    int? duration,
    Value<String?> note = const Value.absent(),
  }) => PlaySessionRow(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    date: date ?? this.date,
    duration: duration ?? this.duration,
    note: note.present ? note.value : this.note,
  );
  PlaySessionRow copyWithCompanion(PlaySessionsCompanion data) {
    return PlaySessionRow(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      date: data.date.present ? data.date.value : this.date,
      duration: data.duration.present ? data.duration.value : this.duration,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaySessionRow(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('date: $date, ')
          ..write('duration: $duration, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gameId, date, duration, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaySessionRow &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.date == this.date &&
          other.duration == this.duration &&
          other.note == this.note);
}

class PlaySessionsCompanion extends UpdateCompanion<PlaySessionRow> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<DateTime> date;
  final Value<int> duration;
  final Value<String?> note;
  const PlaySessionsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.date = const Value.absent(),
    this.duration = const Value.absent(),
    this.note = const Value.absent(),
  });
  PlaySessionsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required DateTime date,
    required int duration,
    this.note = const Value.absent(),
  }) : gameId = Value(gameId),
       date = Value(date),
       duration = Value(duration);
  static Insertable<PlaySessionRow> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<DateTime>? date,
    Expression<int>? duration,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (date != null) 'date': date,
      if (duration != null) 'duration': duration,
      if (note != null) 'note': note,
    });
  }

  PlaySessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<DateTime>? date,
    Value<int>? duration,
    Value<String?>? note,
  }) {
    return PlaySessionsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaySessionsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('date: $date, ')
          ..write('duration: $duration, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ActivePlaySessionsTable extends ActivePlaySessions
    with TableInfo<$ActivePlaySessionsTable, ActivePlaySessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivePlaySessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_games (game_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, gameId, startedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_play_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivePlaySessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivePlaySessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivePlaySessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
    );
  }

  @override
  $ActivePlaySessionsTable createAlias(String alias) {
    return $ActivePlaySessionsTable(attachedDatabase, alias);
  }
}

class ActivePlaySessionRow extends DataClass
    implements Insertable<ActivePlaySessionRow> {
  final int id;
  final int gameId;
  final DateTime startedAt;
  const ActivePlaySessionRow({
    required this.id,
    required this.gameId,
    required this.startedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['started_at'] = Variable<DateTime>(startedAt);
    return map;
  }

  ActivePlaySessionsCompanion toCompanion(bool nullToAbsent) {
    return ActivePlaySessionsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      startedAt: Value(startedAt),
    );
  }

  factory ActivePlaySessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivePlaySessionRow(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
    };
  }

  ActivePlaySessionRow copyWith({int? id, int? gameId, DateTime? startedAt}) =>
      ActivePlaySessionRow(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        startedAt: startedAt ?? this.startedAt,
      );
  ActivePlaySessionRow copyWithCompanion(ActivePlaySessionsCompanion data) {
    return ActivePlaySessionRow(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivePlaySessionRow(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('startedAt: $startedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gameId, startedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivePlaySessionRow &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.startedAt == this.startedAt);
}

class ActivePlaySessionsCompanion
    extends UpdateCompanion<ActivePlaySessionRow> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<DateTime> startedAt;
  const ActivePlaySessionsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.startedAt = const Value.absent(),
  });
  ActivePlaySessionsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required DateTime startedAt,
  }) : gameId = Value(gameId),
       startedAt = Value(startedAt);
  static Insertable<ActivePlaySessionRow> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<DateTime>? startedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (startedAt != null) 'started_at': startedAt,
    });
  }

  ActivePlaySessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<DateTime>? startedAt,
  }) {
    return ActivePlaySessionsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivePlaySessionsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('startedAt: $startedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $UserGamesTable userGames = $UserGamesTable(this);
  late final $PlaySessionsTable playSessions = $PlaySessionsTable(this);
  late final $ActivePlaySessionsTable activePlaySessions =
      $ActivePlaySessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    games,
    userGames,
    playSessions,
    activePlaySessions,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('play_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('active_play_sessions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> coverUrl,
  Value<String?> summary,
  Value<DateTime?> releaseDate,
  required List<String> genres,
  required List<String> platforms,
  Value<String?> developer,
  Value<String?> publisher,
  Value<int?> estimatedPlaytimesStory,
  Value<int?> estimatedPlaytimesMain,
  Value<int?> estimatedPlaytimesCompletion,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> coverUrl,
  Value<String?> summary,
  Value<DateTime?> releaseDate,
  Value<List<String>> genres,
  Value<List<String>> platforms,
  Value<String?> developer,
  Value<String?> publisher,
  Value<int?> estimatedPlaytimesStory,
  Value<int?> estimatedPlaytimesMain,
  Value<int?> estimatedPlaytimesCompletion,
});

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, GameRow> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserGamesTable, List<UserGameRow>>
  _userGamesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userGames,
    aliasName: 'games__id__user_games__game_id',
  );

  $$UserGamesTableProcessedTableManager get userGamesRefs {
    final manager = $$UserGamesTableTableManager(
      $_db,
      $_db.userGames,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userGamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get platforms => $composableBuilder(
    column: $table.platforms,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get developer => $composableBuilder(
    column: $table.developer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedPlaytimesStory => $composableBuilder(
    column: $table.estimatedPlaytimesStory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedPlaytimesMain => $composableBuilder(
    column: $table.estimatedPlaytimesMain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedPlaytimesCompletion => $composableBuilder(
    column: $table.estimatedPlaytimesCompletion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userGamesRefs(
    Expression<bool> Function($$UserGamesTableFilterComposer f) f,
  ) {
    final $$UserGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userGames,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserGamesTableFilterComposer(
            $db: $db,
            $table: $db.userGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platforms => $composableBuilder(
    column: $table.platforms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get developer => $composableBuilder(
    column: $table.developer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedPlaytimesStory => $composableBuilder(
    column: $table.estimatedPlaytimesStory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedPlaytimesMain => $composableBuilder(
    column: $table.estimatedPlaytimesMain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedPlaytimesCompletion => $composableBuilder(
    column: $table.estimatedPlaytimesCompletion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get genres =>
      $composableBuilder(column: $table.genres, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get platforms =>
      $composableBuilder(column: $table.platforms, builder: (column) => column);

  GeneratedColumn<String> get developer =>
      $composableBuilder(column: $table.developer, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<int> get estimatedPlaytimesStory => $composableBuilder(
    column: $table.estimatedPlaytimesStory,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedPlaytimesMain => $composableBuilder(
    column: $table.estimatedPlaytimesMain,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedPlaytimesCompletion => $composableBuilder(
    column: $table.estimatedPlaytimesCompletion,
    builder: (column) => column,
  );

  Expression<T> userGamesRefs<T extends Object>(
    Expression<T> Function($$UserGamesTableAnnotationComposer a) f,
  ) {
    final $$UserGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userGames,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.userGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          GameRow,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (GameRow, $$GamesTableReferences),
          GameRow,
          PrefetchHooks Function({bool userGamesRefs})
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<List<String>> genres = const Value.absent(),
                Value<List<String>> platforms = const Value.absent(),
                Value<String?> developer = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<int?> estimatedPlaytimesStory = const Value.absent(),
                Value<int?> estimatedPlaytimesMain = const Value.absent(),
                Value<int?> estimatedPlaytimesCompletion = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                name: name,
                coverUrl: coverUrl,
                summary: summary,
                releaseDate: releaseDate,
                genres: genres,
                platforms: platforms,
                developer: developer,
                publisher: publisher,
                estimatedPlaytimesStory: estimatedPlaytimesStory,
                estimatedPlaytimesMain: estimatedPlaytimesMain,
                estimatedPlaytimesCompletion: estimatedPlaytimesCompletion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                required List<String> genres,
                required List<String> platforms,
                Value<String?> developer = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<int?> estimatedPlaytimesStory = const Value.absent(),
                Value<int?> estimatedPlaytimesMain = const Value.absent(),
                Value<int?> estimatedPlaytimesCompletion = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                name: name,
                coverUrl: coverUrl,
                summary: summary,
                releaseDate: releaseDate,
                genres: genres,
                platforms: platforms,
                developer: developer,
                publisher: publisher,
                estimatedPlaytimesStory: estimatedPlaytimesStory,
                estimatedPlaytimesMain: estimatedPlaytimesMain,
                estimatedPlaytimesCompletion: estimatedPlaytimesCompletion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({userGamesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userGamesRefs) db.userGames],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userGamesRefs)
                    await $_getPrefetchedData<
                      GameRow,
                      $GamesTable,
                      UserGameRow
                    >(
                      currentTable: table,
                      referencedTable: $$GamesTableReferences
                          ._userGamesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GamesTableReferences(db, table, p0).userGamesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.gameId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      GameRow,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (GameRow, $$GamesTableReferences),
      GameRow,
      PrefetchHooks Function({bool userGamesRefs})
    >;
typedef $$UserGamesTableCreateCompanionBuilder = UserGamesCompanion Function({
  Value<int> gameId,
  required GameStatus status,
  required DateTime addedAt,
});
typedef $$UserGamesTableUpdateCompanionBuilder = UserGamesCompanion Function({
  Value<int> gameId,
  Value<GameStatus> status,
  Value<DateTime> addedAt,
});

final class $$UserGamesTableReferences
    extends BaseReferences<_$AppDatabase, $UserGamesTable, UserGameRow> {
  $$UserGamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('user_games__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserGamesTableFilterComposer
    extends Composer<_$AppDatabase, $UserGamesTable> {
  $$UserGamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<GameStatus, GameStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserGamesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserGamesTable> {
  $$UserGamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserGamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserGamesTable> {
  $$UserGamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<GameStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserGamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserGamesTable,
          UserGameRow,
          $$UserGamesTableFilterComposer,
          $$UserGamesTableOrderingComposer,
          $$UserGamesTableAnnotationComposer,
          $$UserGamesTableCreateCompanionBuilder,
          $$UserGamesTableUpdateCompanionBuilder,
          (UserGameRow, $$UserGamesTableReferences),
          UserGameRow,
          PrefetchHooks Function({bool gameId})
        > {
  $$UserGamesTableTableManager(_$AppDatabase db, $UserGamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> gameId = const Value.absent(),
                Value<GameStatus> status = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => UserGamesCompanion(
                gameId: gameId,
                status: status,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> gameId = const Value.absent(),
                required GameStatus status,
                required DateTime addedAt,
              }) => UserGamesCompanion.insert(
                gameId: gameId,
                status: status,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserGamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.gameId,
                        referencedTable: $$UserGamesTableReferences
                            ._gameIdTable(db),
                        referencedColumn: $$UserGamesTableReferences
                            ._gameIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserGamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserGamesTable,
      UserGameRow,
      $$UserGamesTableFilterComposer,
      $$UserGamesTableOrderingComposer,
      $$UserGamesTableAnnotationComposer,
      $$UserGamesTableCreateCompanionBuilder,
      $$UserGamesTableUpdateCompanionBuilder,
      (UserGameRow, $$UserGamesTableReferences),
      UserGameRow,
      PrefetchHooks Function({bool gameId})
    >;
typedef $$PlaySessionsTableCreateCompanionBuilder =
    PlaySessionsCompanion Function({
      Value<int> id,
      required int gameId,
      required DateTime date,
      required int duration,
      Value<String?> note,
    });
typedef $$PlaySessionsTableUpdateCompanionBuilder =
    PlaySessionsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<DateTime> date,
      Value<int> duration,
      Value<String?> note,
    });

class $$PlaySessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaySessionsTable> {
  $$PlaySessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaySessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaySessionsTable> {
  $$PlaySessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaySessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaySessionsTable> {
  $$PlaySessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PlaySessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaySessionsTable,
          PlaySessionRow,
          $$PlaySessionsTableFilterComposer,
          $$PlaySessionsTableOrderingComposer,
          $$PlaySessionsTableAnnotationComposer,
          $$PlaySessionsTableCreateCompanionBuilder,
          $$PlaySessionsTableUpdateCompanionBuilder,
          (
            PlaySessionRow,
            BaseReferences<_$AppDatabase, $PlaySessionsTable, PlaySessionRow>,
          ),
          PlaySessionRow,
          PrefetchHooks Function()
        > {
  $$PlaySessionsTableTableManager(_$AppDatabase db, $PlaySessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaySessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaySessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaySessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => PlaySessionsCompanion(
                id: id,
                gameId: gameId,
                date: date,
                duration: duration,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required DateTime date,
                required int duration,
                Value<String?> note = const Value.absent(),
              }) => PlaySessionsCompanion.insert(
                id: id,
                gameId: gameId,
                date: date,
                duration: duration,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaySessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaySessionsTable,
      PlaySessionRow,
      $$PlaySessionsTableFilterComposer,
      $$PlaySessionsTableOrderingComposer,
      $$PlaySessionsTableAnnotationComposer,
      $$PlaySessionsTableCreateCompanionBuilder,
      $$PlaySessionsTableUpdateCompanionBuilder,
      (
        PlaySessionRow,
        BaseReferences<_$AppDatabase, $PlaySessionsTable, PlaySessionRow>,
      ),
      PlaySessionRow,
      PrefetchHooks Function()
    >;
typedef $$ActivePlaySessionsTableCreateCompanionBuilder =
    ActivePlaySessionsCompanion Function({
      Value<int> id,
      required int gameId,
      required DateTime startedAt,
    });
typedef $$ActivePlaySessionsTableUpdateCompanionBuilder =
    ActivePlaySessionsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<DateTime> startedAt,
    });

class $$ActivePlaySessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivePlaySessionsTable> {
  $$ActivePlaySessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivePlaySessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivePlaySessionsTable> {
  $$ActivePlaySessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivePlaySessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivePlaySessionsTable> {
  $$ActivePlaySessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);
}

class $$ActivePlaySessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivePlaySessionsTable,
          ActivePlaySessionRow,
          $$ActivePlaySessionsTableFilterComposer,
          $$ActivePlaySessionsTableOrderingComposer,
          $$ActivePlaySessionsTableAnnotationComposer,
          $$ActivePlaySessionsTableCreateCompanionBuilder,
          $$ActivePlaySessionsTableUpdateCompanionBuilder,
          (
            ActivePlaySessionRow,
            BaseReferences<
              _$AppDatabase,
              $ActivePlaySessionsTable,
              ActivePlaySessionRow
            >,
          ),
          ActivePlaySessionRow,
          PrefetchHooks Function()
        > {
  $$ActivePlaySessionsTableTableManager(
    _$AppDatabase db,
    $ActivePlaySessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivePlaySessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivePlaySessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivePlaySessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
              }) => ActivePlaySessionsCompanion(
                id: id,
                gameId: gameId,
                startedAt: startedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required DateTime startedAt,
              }) => ActivePlaySessionsCompanion.insert(
                id: id,
                gameId: gameId,
                startedAt: startedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivePlaySessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivePlaySessionsTable,
      ActivePlaySessionRow,
      $$ActivePlaySessionsTableFilterComposer,
      $$ActivePlaySessionsTableOrderingComposer,
      $$ActivePlaySessionsTableAnnotationComposer,
      $$ActivePlaySessionsTableCreateCompanionBuilder,
      $$ActivePlaySessionsTableUpdateCompanionBuilder,
      (
        ActivePlaySessionRow,
        BaseReferences<
          _$AppDatabase,
          $ActivePlaySessionsTable,
          ActivePlaySessionRow
        >,
      ),
      ActivePlaySessionRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$UserGamesTableTableManager get userGames =>
      $$UserGamesTableTableManager(_db, _db.userGames);
  $$PlaySessionsTableTableManager get playSessions =>
      $$PlaySessionsTableTableManager(_db, _db.playSessions);
  $$ActivePlaySessionsTableTableManager get activePlaySessions =>
      $$ActivePlaySessionsTableTableManager(_db, _db.activePlaySessions);
}
