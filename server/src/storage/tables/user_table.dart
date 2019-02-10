part of storage.tables;

class UserTable extends TableBase<User> {
  static UserMemoryTable _memoryTable = new UserMemoryTable();
  static UserPgsqlTable _pgsqlTable = new UserPgsqlTable();

  MemoryTableCode get memoryTable => _memoryTable;

  PgsqlTableCode get pgsqlTable => _pgsqlTable;
  Users modelListFactory() => new Users();

  UserTable(Connection connection) : super(connection);
  User factory() => new User();

  Future<User> getUserByLoginOrEmailAndPassword(String login, String password) {
    if (connection.connection != null) {
      return _pgsqlTable.getUserByLoginOrEmailAndPassword(connection, login, password);
    }
    if (connection.model != null) {
      return new Future.value(_memoryTable.getUserByLoginOrEmailAndPassword(connection, login, password));
    }
    throwFakedConnectionError();
    return null;
  }

  Future<User> getUserByLoginOrEmail(String login) {
    if (connection.connection != null) {
      return _pgsqlTable.getUserByLoginOrEmail(connection, login);
    }
    if (connection.model != null) {
      return new Future.value(_memoryTable.getUserByLoginOrEmail(connection, login));
    }
    throwFakedConnectionError();
    return null;
  }

  Future<User> getUserByTokenAndReset(String token) async {
    User user;
    if (connection.connection != null) {
      user = await _pgsqlTable.getUserByToken(connection, token);
    } else
    if (connection.model != null) {
      user = await _memoryTable.getUserByToken(connection, token);
    }
    if (user == null) return null;
    if (connection.connection != null) {
      return _pgsqlTable.resetToken(connection, user);
    }
    if (connection.model != null) {
      return _memoryTable.resetToken(connection, user);
    }
    throwFakedConnectionError();
    return null;
  }

  Future<User> changePassword(int id, String password) {
    if (connection.connection != null) {
      return _pgsqlTable.changePassword(connection, id, password);
    }
    if (connection.model != null) {
      return new Future.value(_memoryTable.changePassword(connection, id, password));
    }
    throwFakedConnectionError();
    return null;
  }

  Future<User> getUserBySocialId(int id, {bool facebook: false, bool google: false}) {
    if (!facebook && !google) throw new ArgumentError("getUserBySocialId have to have specified social network");
    String idKey;
    if (facebook) {
      idKey = FACEBOOK_ID_KEY;
    } else if (google) {
      idKey = GOOGLE_ID_KEY;
    }
    ;
    if (connection.connection != null) {
      return _pgsqlTable.getUserBySocialId(connection, id, idKey);
    }
    if (connection.model != null) {
      return new Future.value(_memoryTable.getUserBySocialId(connection, id, idKey));
    }
    throwFakedConnectionError();
    return null;
  }
}
