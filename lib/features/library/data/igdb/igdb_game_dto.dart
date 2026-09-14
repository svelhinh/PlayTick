import 'package:playtick/features/library/data/igdb/igdb_cover_url.dart';
import 'package:playtick/features/library/data/igdb/igdb_game_localization_dto.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';

final class IgdbGameDto {
  IgdbGameDto({
    required this.id,
    required this.name,
    this.summary,
    this.coverUrl,
    this.genres = const [],
    this.platforms = const [],
    this.developer,
    this.publisher,
    this.firstReleaseDate,
    this.gameTimeToBeat,
    this.localizations = const [],
  });

  final int id;
  final String name;
  final String? summary;
  final String? coverUrl;
  final List<String> genres;
  final List<String> platforms;
  final String? developer;
  final String? publisher;
  final DateTime? firstReleaseDate;
  final EstimatedPlaytimes? gameTimeToBeat;
  final List<IgdbGameLocalizationDto> localizations;

  static IgdbGameDto? fromJson(Map<String, dynamic> json) {
    if (json['id'] is! int || json['name'] is! String) {
      return null;
    }

    return IgdbGameDto(
      id: json['id'] as int,
      name: json['name'] as String,
      summary: json['summary'] as String?,
      coverUrl: igdbCoverUrl(json['cover']),
      genres: _names(json['genres']),
      platforms: _names(json['platforms']),
      developer: _companyName(json['involved_companies'], 'developer'),
      publisher: _companyName(json['involved_companies'], 'publisher'),
      firstReleaseDate: _firstReleaseDate(json['first_release_date']),
      gameTimeToBeat: _gameTimeToBeat(json['game_time_to_beat']),
      localizations: _localizations(json['game_localizations']),
    );
  }

  Game toGame({String? preferredRegionIdentifier}) {
    final localization = localizations
        .where(
          (localization) =>
              localization.regionIdentifier == preferredRegionIdentifier,
        )
        .firstOrNull;

    return Game(
      id: id,
      name: localization?.name ?? name,
      summary: summary,
      coverUrl: localization?.coverUrl ?? coverUrl,
      genres: genres,
      platforms: platforms,
      developer: developer,
      publisher: publisher,
      releaseDate: firstReleaseDate,
      estimatedPlaytimes: gameTimeToBeat,
    );
  }
}

DateTime? _firstReleaseDate(Object? value) {
  if (value is! int) {
    return null;
  }

  return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
}

List<String> _names(Object? value) {
  final items = value as List<dynamic>? ?? const [];

  return [
    for (final item in items)
      if (item is Map<String, dynamic> && item['name'] is String)
        item['name'] as String,
  ];
}

String? _companyName(Object? value, String role) {
  final companies = value as List<dynamic>? ?? const [];
  final match = companies.where((raw) {
    return raw is Map<String, dynamic> && raw[role] == true;
  }).firstOrNull;
  if (match is! Map<String, dynamic>) {
    return null;
  }

  final company = match['company'] as Map<String, dynamic>?;
  return company?['name'] as String?;
}

EstimatedPlaytimes? _gameTimeToBeat(Object? value) {
  if (value is! Map<String, dynamic>) {
    return null;
  }

  final hastily = value['hastily'];
  final normally = value['normally'];
  final completely = value['completely'];
  final playtimes = EstimatedPlaytimes(
    story: hastily is int ? Duration(seconds: hastily) : null,
    main: normally is int ? Duration(seconds: normally) : null,
    completion: completely is int ? Duration(seconds: completely) : null,
  );

  return playtimes.hasValues ? playtimes : null;
}

List<IgdbGameLocalizationDto> _localizations(Object? value) {
  if (value is! List<dynamic>) return const [];

  return value
      .whereType<Map<String, dynamic>>()
      .map(IgdbGameLocalizationDto.fromJson)
      .whereType<IgdbGameLocalizationDto>()
      .toList();
}
