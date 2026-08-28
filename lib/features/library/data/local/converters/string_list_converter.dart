import 'dart:convert';

import 'package:drift/drift.dart';

final class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return List<String>.unmodifiable(
      (jsonDecode(fromDb) as List).cast<String>(),
    );
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}
