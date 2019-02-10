library storage.code;

import 'dart:async';
import 'library.dart';
import '../model/library.dart';
import "../modules/filter/common/library.dart" as filter_module;

import 'package:akcnik/common/library.dart';

abstract class BaseTableCode<T extends Jsonable> {
  Future<T> saveModel(Connection connection, Map<String, dynamic> entity);

  Future<T> updateModel(Connection connection, Map<String, dynamic> entity, List<String> columns);

  Future<ModelList<T>> load(Connection connection, filter_module.RootFilter filter, List<String> columns,
      {int limit: 50, bool fullColumns: false});

  Future<Map> deleteModel(Connection connection, Map<String, dynamic> map);

  Future<Set<int>> missing(Connection connection, Iterable<int> ids, filter_module.RootFilter filter);

  Future<bool> anyoneExists(Connection connection, filter_module.RootFilter filter);
}
