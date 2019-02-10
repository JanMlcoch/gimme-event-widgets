part of akcnik.web.test;

void registrationTest() {
  void setValue(html.InputElement input, dynamic value) {
    input
      ..focus()
      ..value = value
      ..blur();
    //input.onKeyUp.dispatch();
  }
  group("Registration (end-to-end)");
  test("validation check", () async {
    html.ButtonElement nextButton =
    await openPageAndWaitForElement(ROUTE_SIGN_UP, ".newAccount.center-block.akcButton");
    expect(nextButton, isNotNull);
    nextButton.click();
    await waitForElement(".createAccount.akcButton");
    html.DivElement cont = html.querySelector(".registrationCont");
    ClientUser user = new ClientUser()
      ..fromMap({
        "login": randomString(),
        "firstName": randomString(),
        "surname": randomString(),
        "email": randomString() + "@akcnik.cz",
        "password": randomString()
      });
    (cont.querySelector(".akcInput.firstName") as html.InputElement).value = user.firstName;
    (cont.querySelector(".akcInput.surname") as html.InputElement).value = user.surname;
    html.InputElement loginInput = cont.querySelector(".akcInput.login");
    setValue(loginInput, "");
    expect(loginInput.classes, contains("invalid"));
    expect(cont
        .querySelector(".errorMessage.login")
        .text, contains("Položka musí být vyplněna"));
    setValue(loginInput, user.login);
    expect(loginInput.classes, isNot(contains("invalid")));
    html.InputElement emailInput = cont.querySelector(".akcInput.email");
    setValue(emailInput, randomString());
    expect(emailInput.classes, contains("invalid"));
    setValue(emailInput, user.email);
    expect(emailInput.classes, isNot(contains("invalid")));
    setValue(emailInput, randomString(10) + "@" + randomString(10));
    expect(emailInput.classes, contains("invalid"));
    html.InputElement pass1 = cont.querySelector(".akcInput.password1");
    html.InputElement pass2 = cont.querySelector(".akcInput.password2");
    html.DivElement passwordErrors = cont.querySelector(".errorMessage.password");
    setValue(pass1, "");
    expect(pass1.classes, contains("invalid"));
    expect(passwordErrors.text, contains("Položka musí být vyplněna"));
    setValue(pass1, "aa");
    expect(passwordErrors.text, contains("Heslo musí mít aplespoň 5 znaků"));
    setValue(pass2, "");
    expect(pass2.classes, contains("invalid"));
    expect(passwordErrors.text, contains("Hesla se musí shodovat"));
    setValue(pass2, "aa");
    expect(pass2.classes, isNot(contains("invalid")));
    expect(passwordErrors.text, isNot(contains("Hesla se musí shodovat")));
    html.querySelectorAll("button.ui-dialog-titlebar-close").forEach((html.Element element) => element.click());
  },
      description:
      "Test of client validation. It tests wide range of invalid states as missing input, short password," +
          " different second password etc.");

  test("Server validation", () async {
    print("phase 1");
    (await openPageAndWaitForElement(ROUTE_SIGN_UP, ".newAccount.center-block.akcButton")).click();
    print("phase 2");
    html.ButtonElement submitButton = await waitForElement(".createAccount.akcButton");
    html.DivElement cont = html.querySelector(".registrationCont");
    ClientUser user = new ClientUser()
      ..fromMap({
        "login": "gratzky",
        "firstName": "Gregor",
        "surname": "Grátzký",
        "email": "gratzky@akcnik.cz",
        "password": randomString()
      });
    html.InputElement firstNameInput = cont.querySelector(".akcInput.firstName");
    setValue(firstNameInput, user.firstName);
    html.InputElement surnameInput = cont.querySelector(".akcInput.surname");
    setValue(surnameInput, user.surname);
    html.InputElement loginInput = cont.querySelector(".akcInput.login");
    setValue(loginInput, user.login);
    html.InputElement emailInput = cont.querySelector(".akcInput.email");
    setValue(emailInput, user.email);
    html.InputElement password1Input = cont.querySelector(".akcInput.password1");
    setValue(password1Input, user.password);
    html.InputElement password2Input = cont.querySelector(".akcInput.password2");
    setValue(password2Input, user.password);

    setValue(loginInput, randomString());
    submitButton.click();
    await waitForElement(".akcInput.email.invalid", container: cont);
    expect(cont
        .querySelector(".errorMessage.email")
        .text, contains("Váš email je již použit"));
    print("phase 3");

    setValue(loginInput, user.login);
    setValue(emailInput, randomString() + "@akcnik.cz");
    submitButton.click();
    await waitForElement(".akcInput.login.invalid", container: cont);
    expect(cont
        .querySelector(".errorMessage.login")
        .text, contains("Vaše přihlašovací jméno je již použito"));
    html.querySelectorAll("button.ui-dialog-titlebar-close").forEach((html.Element element) => element.click());
  },
      description: "Test of create user validation conducted on server. " +
          "This validation consists of email duplication check, login duplication check and email validity");
  test("Creation successful", () async {
    (await openPageAndWaitForElement(ROUTE_SIGN_UP, ".newAccount.center-block.akcButton")).click();
    html.ButtonElement submitButton = await waitForElement(".createAccount.akcButton");
    html.DivElement cont = html.querySelector(".registrationCont");
    ClientUser user = new ClientUser()
      ..fromMap({
        "login": randomString(),
        "firstName": randomString(),
        "surname": randomString(),
        "email": randomString() + "@akcnik.cz",
        "password": randomString()
      });
    html.InputElement firstNameInput = cont.querySelector(".akcInput.firstName");
    setValue(firstNameInput, user.firstName);
    html.InputElement surnameInput = cont.querySelector(".akcInput.surname");
    setValue(surnameInput, user.surname);
    html.InputElement loginInput = cont.querySelector(".akcInput.login");
    setValue(loginInput, user.login);
    html.InputElement emailInput = cont.querySelector(".akcInput.email");
    setValue(emailInput, user.email);
    html.InputElement password1Input = cont.querySelector(".akcInput.password1");
    setValue(password1Input, user.password);
    html.InputElement password2Input = cont.querySelector(".akcInput.password2");
    setValue(password2Input, user.password);
    submitButton.click();

    expect((await waitForElement(".appNavbarWidgetUserLogin")).text, contains(user.login));
    (html.querySelector(".appUserLogOut.akcButton")).click();
    expect(await waitForElement(".appSignUpRoute.akcButton"), isNotNull);
  },
      description:
      "Test of successful user registration. Form is filled with random but valid data and everything is send to server," +
          " where new User should be created");
}
