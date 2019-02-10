library storage.pgsql.query_helpers;

import "package:postgresql/postgresql.dart" as pgsql;
import "dart:convert";

String safeConvert(dynamic value, {nullToDefault: false}) {
  if (value is String) {
    return pgsql.encodeString(value).trim();
  } else if (value == null) {
    if (nullToDefault) return "DEFAULT";
    return "NULL";
  } else if (value is Map || value is List) {
    return "'" + JSON.encode(value) + "'";
  } else if (value is num) {
    return value.toString();
  } else if (value is bool) {
    return value ? "TRUE" : "FALSE";
  }
  return "NULL";
}

String sqlSubstitute(String query, Map<String, dynamic> json, {Iterable<String> keys, String primaryKey: null}) {
  if (keys == null) {
    keys = json.keys;
  }
  keys.forEach((String key) {
    query = query.replaceAll("@$key", safeConvert(json[key]));
  });
  if (primaryKey != null) {
    query = query.replaceAll("@$primaryKey", json[primaryKey]);
  }
  return query;
}
