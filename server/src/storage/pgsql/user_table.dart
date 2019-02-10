part of storage.pgsql;

class UserPgsqlTable extends PgsqlTableCode<User> {
  static query_lib.UserSqlCompiler _queries = new query_lib.UserSqlCompiler();

  @override
  query_lib.SqlCompiler get queries => _queries;
  @override
  Map<String, dynamic> _fromDatabaseJson(Map<dynamic, dynamic> json) {
    if (json["clientSettings"] is Map) {
      json["currency"] = json["clientSettings"]["currency"];
    }
    if (json is Map<String, dynamic>) return json;
    return null;
  }

  Map<String, dynamic> _toDatabaseJson(Map<String, dynamic> json) {
    if (json["currency"] != null) {
      if (json["clientSettings"] == null) json["clientSettings"] = {};
      json["clientSettings"]["currency"] = json["currency"];
    }
    if (json["preferenceTags"] is List) {
      json["preferenceTags"] =
          (json["preferenceTags"] as List<Map<String, dynamic>>).map((Map<String, dynamic> tag) => tag["id"]).toList();
    }
    return json;
  }

  @override
  Users _rowsToModelList(List<pgsql.Row> rows) {
    Users users = new Users();
    rows.forEach((pgsql.Row row) {
//      print(JSON.encode(row.toMap()));
      User user = new User();
      Map<String, dynamic> entityJson = _fromDatabaseJson(row.toMap());
      user.fromMap(entityJson);
      users.add(user);
    });
    return users;
  }

  Future<User> getUserByLoginOrEmailAndPassword(Connection connection, String loginOrEmail, String password) async {
    String query = _queries.constructSelectQuery(null, useFullColumns: true);
    String constraint = _queries.getLoginOrEmailConstraint(loginOrEmail);
    query = query.replaceFirst("/* WHEREusers */", constraint);
    query = _enhanceSaveQuery(query);
    User user = (await _executeQueryWithProcessor(connection, query)).first;
    if (user == null) return null;
    if (new db_crypt.DBCrypt().checkpw(password, user.password)) {
      return user;
    }
    return null;
  }

  Future<User> getUserByLoginOrEmail(Connection connection, String login) async {
    String query = _queries.constructSelectQuery(null, useFullColumns: true);
    String constraint = _queries.getLoginOrEmailConstraint(login);
    query = query.replaceFirst("/* WHEREusers */", constraint);
    query = _enhanceSaveQuery(query);
    return (await _executeQueryWithProcessor(connection, query)).first;
  }

  Future<User> changePassword(Connection connection, int id, String password) async {
    String hashedPassword = User.encryptPassword(password);
    String query = _queries.constructUpdateQuery(["password"], {"id": id, "password": hashedPassword});
    query = _enhanceSaveQuery(query);
    return (await _executeQueryWithProcessor(connection, query)).first;
  }

  Future<User> getUserByToken(Connection connection, String token) async {
    String query = _queries.constructSelectQuery(null, useFullColumns: true);
    query = query.replaceFirst("/* WHEREusers */", "WHERE \"authenticationToken\"=${pgsql.encodeString(token).trim()}");
    query = _enhanceSaveQuery(query);
    User user = (await _executeQueryWithProcessor(connection, query)).first;
    return user;
  }

  Future<User> resetToken(Connection connection, User user) async {
    String newToken = generateToken();
    String query =
    _queries.constructUpdateQuery(["authenticationToken"], {"id": user.id, "authenticationToken": newToken});
    query = _enhanceSaveQuery(query);
    user = (await _executeQueryWithProcessor(connection, query)).first;
    return user;
  }

  Future<User> getUserBySocialId(Connection connection, int id, String idKey) async {
    String query = _queries.constructSelectQuery(null, useFullColumns: true);
    query = query.replaceFirst("/* WHEREusers */", "WHERE \"clientSettings\" @> '{\"$idKey\": $id}'");
    query = _enhanceSaveQuery(query);
    User user = (await _executeQueryWithProcessor(connection, query)).first;
    return user;
  }
}
