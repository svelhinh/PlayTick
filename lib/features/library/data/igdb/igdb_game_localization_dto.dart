import 'package:playtick/features/library/data/igdb/igdb_cover_url.dart';

final class IgdbGameLocalizationDto {
  IgdbGameLocalizationDto({
    required this.regionIdentifier,
    required this.name,
    this.coverUrl,
  });

  final String regionIdentifier;
  final String? name;
  final String? coverUrl;

  static IgdbGameLocalizationDto? fromJson(Map<String, dynamic> json) {
    if (json['region'] is! Map<String, dynamic> ||
        (json['region'] as Map<String, dynamic>)['identifier'] is! String) {
      return null;
    }

    final rawName = json['name'];
    final rawRegionIdentifier =
        (json['region'] as Map<String, dynamic>)['identifier'];

    if (rawRegionIdentifier is! String || rawRegionIdentifier.trim().isEmpty) {
      return null;
    }

    return IgdbGameLocalizationDto(
      regionIdentifier: rawRegionIdentifier,
      name: rawName is String && rawName.trim().isNotEmpty
          ? rawName.trim()
          : null,
      coverUrl: igdbCoverUrl(json['cover']),
    );
  }
}
