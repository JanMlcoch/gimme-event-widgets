part of model;

class Users extends ModelList<User> {
  String type = "users";

  int get length => _list.length;

  List<User> get list => _list;

  User getById(int id) => _map[id];

  User getUserByLogin(String login) {
    for (User user in _list) {
      if (user.login == login) {
        return user;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> toFullList() {
    List<Map<String, dynamic>> out = [];
    for (User user in _list) {
      out.add(user.toFullMap());
    }
    return out;
  }

  Object toSafeList() {
    List out = [];
    for (User user in _list) {
      out.add(user.toSafeMap());
    }
    return out;
  }

  @override
  User entityFactory() => new User();

  @override
  Users copyType() => new Users();
}
