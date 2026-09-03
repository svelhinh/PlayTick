import 'package:playtick/features/library/domain/game.dart';

final class IgdbGameDto {
  IgdbGameDto({
    required this.id,
    required this.name,
  });

  factory IgdbGameDto.fromJson(Map<String, dynamic> json) {
    return IgdbGameDto(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  final int id;
  final String name;

  Game toGame() => Game(id: id, name: name);
}
