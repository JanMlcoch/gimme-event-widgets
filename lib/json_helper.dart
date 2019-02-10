library json_helper;

import 'dart:convert';

Map<String, dynamic> decodeJsonMap(String source) {
  dynamic decoded = JSON.decode(source);
  if (decoded is Map<String, dynamic>) return decoded;
  return null;
}

List<Map<String, dynamic>> decodeJsonMapList(String source) {
  dynamic decoded = JSON.decode(source);
  if (decoded is List<Map<String, dynamic>>) return decoded;
  return null;
}

List<dynamic> decodeJsonList(String source) {
  dynamic decoded = JSON.decode(source);
  if (decoded is List<dynamic>) return decoded;
  return null;
}

String encodeJsonMap(Map<String, dynamic> map) => JSON.encode(map);

String encodeJsonList(List<dynamic> list) => JSON.encode(list);