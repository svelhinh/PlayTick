import 'package:playtick/features/library/domain/estimated_playtimes.dart';

final class Game {
  Game({
    required this.id,
    required this.name,
    this.coverUrl,
    this.summary,
    this.releaseDate,
    List<String> genres = const [],
    this.developer,
    this.publisher,
    List<String> platforms = const [],
    this.estimatedPlaytimes,
  }) : genres = List.unmodifiable(genres),
       platforms = List.unmodifiable(platforms);

  final int id;
  final String name;
  final String? coverUrl;
  final String? summary;
  final DateTime? releaseDate;
  final List<String> genres;
  final String? developer;
  final String? publisher;
  final List<String> platforms;
  final EstimatedPlaytimes? estimatedPlaytimes;
}
