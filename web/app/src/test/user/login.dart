part of akcnik.web.test;


void loginTest() {
  group("Password login");
  test("wrong user", () async {
    bool result = await model.user.submitCredentials("test unknown user", "pass");
    expect(result, isFalse);
  });
  test("user with wrong password", () async {
    bool result = await model.user.submitCredentials("gratzky", "pass");
    expect(result, isFalse);
  });
  test("user with correct password", () async {
    ClientUser user = model.user;
    bool result = await user.submitCredentials("gratzky", "gratzky");
    expect(result, isTrue);
    expect(user.firstName, "Gregor");
    await user.logout();
  });
  xtest("login by login popup", () {
    html.ButtonElement loginButton = html.querySelector(".appSignIn.akcButton");
    expect(loginButton, isNotNull);
  });
}