String? igdbCoverUrl(Object? cover) {
  if (cover is! Map<String, dynamic> ||
      cover['url'] is! String ||
      (cover['url'] as String).trim().isEmpty) {
    return null;
  }

  final coverBig = (cover['url'] as String).replaceAll(
    't_thumb',
    't_cover_big',
  );

  if (coverBig.startsWith('https:')) {
    return coverBig;
  }

  return 'https:$coverBig';
}
