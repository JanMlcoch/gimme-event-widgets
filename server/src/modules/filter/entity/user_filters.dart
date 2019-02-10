part of filter_module.entity;

abstract class UserFilter extends FilterBase<User> {
  final String filterType = TABLE_USERS;

  UserFilter(String filterName, List<String> validateTemplate, List data) : super(filterName, validateTemplate, data);
}

//##############################################################################
class LoginUserFilter extends UserFilter {
  String _login;

  LoginUserFilter(List data) : super("user_login", const ["string"], data);

  void fromList(List<dynamic> jsonArray) {
    _login = jsonArray.first;
  }

  String get sqlConstraint => "$filterType.\"login\" = ${safeConvert(_login)}";

  bool match(User user) => user.login == _login;
}

//##############################################################################
class EmailUserFilter extends UserFilter {
  String _email;

  EmailUserFilter(List data) : super("user_email", const ["string"], data);

  void fromList(List<dynamic> jsonArray) {
    _email = jsonArray.first;
  }

  String get sqlConstraint => "$filterType.\"email\" = ${safeConvert(_email)}";

  bool match(User user) => user.email == _email;
}

//##############################################################################
class LoginOrEmailUserFilter extends UserFilter {
  String _loginOrEmail;

  LoginOrEmailUserFilter(List data) : super("user_login_or_email", const ["string"], data);

  void fromList(List<dynamic> jsonArray) {
    _loginOrEmail = jsonArray.first;
  }

  String get sqlConstraint {
    String safeLogin = safeConvert(_loginOrEmail);
    return "($filterType.\"login\" = $safeLogin OR $filterType.\"email\" = $safeLogin)";
  }

  bool match(User user) => user.login == _loginOrEmail || user.email == _loginOrEmail;
}

//##############################################################################
class TokenUserFilter extends UserFilter {
  String _token;

  TokenUserFilter(List data) : super("user_token", const ["string"], data);

  void fromList(List<dynamic> jsonArray) {
    _token = jsonArray.first;
  }

  String get sqlConstraint => "$filterType.\"authenticationToken\" = ${safeConvert(_token)}";

  bool match(User user) => user.authenticationToken == _token;
}

//##############################################################################
