final class JsonPlaceholderPostDto {
  const JsonPlaceholderPostDto({
    required this.id,
    required this.title,
  });

  factory JsonPlaceholderPostDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];

    if (id is! int) {
      throw const FormatException('Invalid post id');
    }

    if (title is! String) {
      throw const FormatException('Invalid post title');
    }

    return JsonPlaceholderPostDto(
      id: id,
      title: title,
    );
  }

  final int id;
  final String title;
}
