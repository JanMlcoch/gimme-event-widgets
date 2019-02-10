part of akcnik.server.authenticator;

auth.UserLookupByUsername<PrincipalUser> lookupUser = (String login) async {
  server_model.User user = await storage_lib.storage.connectHandler((storage_lib.Connection connection) {
    return connection.users.getUserByLoginOrEmail(login);
  });
  if (user == null) return new None();
  return new Option<PrincipalUser>(new PrincipalUser(login, user));
};

class PrincipalUser extends auth.Principal {
  final server_model.User user;
  PrincipalUser(String name, this.user) : super(name);
}
