part of storage.memory;

class UserMemoryTable extends MemoryTableCode<User> {
  Users _getModelList(Connection connection) => connection.model.users;

  User getUserByLoginOrEmailAndPassword(Connection connection, String emailOrLogin, String password) {
    User user = getUserByLoginOrEmail(connection, emailOrLogin);
    if (user == null) return null;
    if (new db_crypt.DBCrypt().checkpw(password, user.password)) {
      return user;
    }
    return null;
  }

  User getUserByLoginOrEmail(Connection connection, String emailOrLogin) {
    for (User user in getModelList(connection).list) {
      if (user.login == emailOrLogin || user.email == emailOrLogin) {
        return user;
      }
    }
    return null;
  }

  User changePassword(Connection connection, int id, String password) {
    User user = getModelList(connection).getById(id);
    if (user == null) return null;
    user.password = User.encryptPassword(password);
    return user;
  }

  User getUserByToken(Connection connection, String token) {
    return getModelList(connection)
        .list
        .firstWhere((User user) => user.authenticationToken == token, orElse: () => null);
  }

  User resetToken(Connection connection, User user) {
    user.authenticationToken = generateToken();
    getModelList(connection).add(user);
    return user;
  }

  User getUserBySocialId(Connection connection, int id, String idKey) {
    for (User user in getModelList(connection).list) {
      if (user.clientSettings[idKey] == id) {
        return user;
      }
    }
    return null;
  }
}
