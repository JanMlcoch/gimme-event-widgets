part of view;

class SignStep2Widget extends Widget {
  static String cannotBeEmpty = lang.forms.cannotBeEmpty;
  InputElement nameInput;
  InputElement surname;
  Element nameValidMessage;
  InputElement email;
  Element emailValidMessage;
  InputElement password1;
  Element password1ValidMessage;
  InputElement password2;
  Element password2ValidMessage;
  InputElement login;
  Element loginValidMessage;
  Element next;
  Element create;
  Registration reg;
  SignUpWidget signUp;
  FormValidator validator;

  FormSectionReport loginReport;
  FormSectionReport emailReport;
  FormSectionReport password1Report;
  FormSectionReport password2Report;

  NavbarModel get model => layoutModel.navbarModel;

  SignStep2Widget(this.signUp) {
    reg = model.user.registration;
    template = parse(resources.templates.userSigning.signStep2);
    widgetLang = lang.navbar.registration.toMap();
  }

  FormSectionReport _createLoginValidator() {
    loginReport = new FormSectionReport('login', login, loginValidMessage);
    FormSectionStringValidator notEmptyValidator = new FormSectionStringValidator.notEmpty(
        validityMessage: cannotBeEmpty, checkAfterKeyUp: true);
    loginReport.addSectionValidator(notEmptyValidator);
    return loginReport;
  }

  FormSectionReport _createEmailValidator() {
    emailReport = new FormSectionReport('email', email, emailValidMessage);
    FormSectionStringValidator notEmptyValidator = new FormSectionStringValidator.notEmpty(
        validityMessage: cannotBeEmpty, checkAfterKeyUp: true);
    FormSectionEmailValidator isEmailValidator = new FormSectionEmailValidator(
        validityMessage: lang.navbar.registration.invalidEmail);
    emailReport.addSectionValidator(notEmptyValidator);
    emailReport.addSectionValidator(isEmailValidator);
    return emailReport;
  }

  FormSectionReport _createPassword1Validator() {
    password1Report = new FormSectionReport('password1', password1, password1ValidMessage);
    FormSectionStringValidator notEmptyValidator = new FormSectionStringValidator.notEmpty(
        validityMessage: cannotBeEmpty);
    FormSectionStringValidator minCharValidator = new FormSectionStringValidator.minimalChars(
        5, validityMessage: lang.navbar.registration.minimalCharacters);
    password1Report.addSectionValidator(notEmptyValidator);
    password1Report.addSectionValidator(minCharValidator);
    return password1Report;
  }

  FormSectionReport _createPassword2Validator() {
    password2Report = new FormSectionReport('password2', password2, password2ValidMessage);
    FormSectionIdentityValidator passwordIdentity = new FormSectionIdentityValidator(
        password1, validityMessage: lang.navbar.registration.notSamePassword, checkAfterKeyUp: true);
    password2Report.addSectionValidator(passwordIdentity);
    return password2Report;
  }

  @override
  void destroy() {
  }

  @override
  Map out() {
    Map out = {
      "lang": widgetLang
    };
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
    nameInput = select(".firstName");
    surname = select(".surname");
    email = select(".email");
    password1 = select(".password1");
    password2 = select(".password2");
    create = select(".createAccount");
    next = select(".nextButton");
    login = select(".login");
    nameInput.focus();

    loginValidMessage = select(".errorMessage.login");
    emailValidMessage = select(".errorMessage.email");
    password1ValidMessage = select(".errorMessage .password1Message");
    password2ValidMessage = select(".errorMessage .password2Message");

    _createValidator();
    setNameFromInput();
    setSurNameFromInput();
    setEmailFromInput();
    setLoginFromInput();
    setPassword1FromInput();
    setPassword2FromInput();

    nameInput.onBlur.listen((_) {
      setNameFromInput();
    });
    surname.onBlur.listen((_) {
      setSurNameFromInput();
    });
    login.onBlur.listen((_) {
      setLoginFromInput();
    });
    email.onBlur.listen((_) {
      setEmailFromInput();
    });
    password1.onBlur.listen((_) {
      setPassword1FromInput();
    });

    password2.onKeyUp.listen((_) {
      setPassword2FromInput();
      password2Report.checkValidity();
    });

    next.onClick.listen((_) {
      if (validator.checkValidity()) {
        model.user.registration.step = 3;
      }
    });

    create.onClick.listen((_) {
      if (!validator.checkValidity()) {
        return;
      }
      reg.createUser().then((envelope_lib.Envelope result) {
        print(result.category);
        if (result.isSuccess) {
          signUp.doClose();
        } else {
          if (result.category == UserBase.EMAIL_DUPLICATE) {
            email.value = "";
            reg.email = "";
            email.classes.add("invalid");
            emailValidMessage.setInnerHtml(lang.navbar.registration.usedEmail);
          }
          if (result.category == UserBase.LOGIN_DUPLICATE) {
            login.value = "";
            reg.login = "";
            login.classes.add("invalid");
            loginValidMessage.setInnerHtml(lang.navbar.registration.usedLogin);
          }
        }
      });
    });
  }

  void setNameFromInput([Event _]) {
    reg.name = nameInput.value;
  }

  void setSurNameFromInput([Event _]) {
    reg.surname = surname.value;
  }

  void setLoginFromInput([Event _]) {
    reg.login = login.value;
  }

  void setEmailFromInput([Event _]) {
    reg.email = email.value;
  }

  void setPassword1FromInput([Event _]) {
    reg.password1 = password1.value;
  }

  void setPassword2FromInput([_]) {
    reg.password2 = password2.value;
  }


  void _createValidator() {
    validator = new FormValidator();
    validator.addSectionReport(_createLoginValidator());
    validator.addSectionReport(_createEmailValidator());
    validator.addSectionReport(_createPassword1Validator());
    validator.addSectionReport(_createPassword2Validator());
  }

  void validate() {
    validator.checkValidity(checkOnlyAfterBlur: true);
  }
}