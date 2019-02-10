part of akcnik.tests.database_sql;

void userQueryTest() {
  queries_lib.UserSqlCompiler compiler;
  group("User query", () {
    test("eventCompiler", () {
      compiler = new queries_lib.UserSqlCompiler();
      expect(compiler, isNotNull);
      expect(compiler.ownTable, "users");
    });
    group("load", () {
      test("list", () {
        List<String> columns = [
          "id",
          "firstName",
          "surname",
          "middleNames",
          "maleGender",
          "residenceTown",
          "profileQuality",
          "email",
          "language"
        ];
        String query = compiler.constructSelectQuery(columns);
        expect(
            query,
            'SELECT users."id", users."firstName", users."surname", ' +
                'users."middleNames", users."maleGender", users."residenceTown", ' +
                'users."profileQuality", users."email", users."language" ' +
                'FROM users /* WHEREusers */ /* otherWHERE */ /* LIMIT */;');
      });
      test("detail", () {
        List<String> columns = [
          "id",
          "login",
          "role",
          "permissions",
          "firstName",
          "surname",
          "middleNames",
          "maleGender",
          "residenceTown",
          "email",
          "language",
          "serverSettings"
        ];
        String query = compiler.constructSelectQuery(columns);
        expect(
            query,
            'SELECT users."id", users."login", users."role", ' +
                'user_roles."permissions", ' +
                'users."firstName", users."surname", ' +
                'users."middleNames", users."maleGender", ' +
                'users."residenceTown", ' +
                'users."email", users."language", ' +
                'users."serverSettings" ' +
                'FROM users JOIN user_roles ON users.role = user_roles.role ' +
                '/* WHEREusers */ ' +
                '/* otherWHERE */ ' +
                '/* LIMIT */;');
      });
    });
  });
}
