part of userModule;

void _bindCreateUser() {
  libs.route(CONTROLLER_CREATE_USER, () => new CreateUserRequestContext(),
      method: "POST",
      template: {
        "login": "string",
        "email": "string",
        "password": "string",
        "clientSettings": "Map",
        "firstName": "string",
        "surname": "string",
        "residenceTown": "string",
        "currency": "string",
        "imageData": "?string",
        "language": "string",
        "!role": "string",
        "!proven": "string"
      },
      allowAnonymous: true);
  libs.route(CONTROLLER_CREATE_USER_FROM_FACEBOOK, () => new CreateUserFromFacebookRequestContext(),
      method: "POST", template: {"token": "string"}, allowAnonymous: true);
  libs.route(CONTROLLER_CREATE_USER_FROM_GOOGLE, () => new CreateUserFromGoogleRequestContext(),
      method: "POST", template: {"token": "string"}, allowAnonymous: true);
}

class CreateUserRequestContext extends libs.RequestContext {
  String email;
  static const List<String> allowedColumns = const [
    "surname",
    "clientSettings",
//    "password",   // go around cleaning
    "email",
    "firstName",
    "middleNames",
    "residenceLatitude",
    "residenceLongitude",
    "residenceTown",
    "login",
    "currency",
    "imageData",
    "language",
    "maleGender",
    "preferenceTagsIds",
    "birthDate"
  ];

  @override
  Future validate() async {
    email = data["email"];
    if (!validator.isEmail(email)) {
      envelope.error(INCORRECT_EMAIL);
      return null;
    }
    if (await connection.users.anyoneExists(new entity_filters.EmailUserFilter([email]).upgrade())) {
      User sameUser = await connection.users.getUserByLoginOrEmail(email);
      envelope.error("email \"$email\" already occupied by ${sameUser.login}", EMAIL_DUPLICATE);
      return null;
    }
    String login = data["login"];
    if (await connection.users.anyoneExists(new entity_filters.LoginUserFilter([login]).upgrade())) {
      envelope.error("login \"$login\" already occupied", LOGIN_DUPLICATE);
      return null;
    }
    return null;
  }

  @override
  Future execute() async {
    String password = User.encryptPassword(data["password"]);
    Map<String, dynamic> cleanedMap = {};
    data.forEach((String key, dynamic value) {
      if (allowedColumns.contains(key)) {
        cleanedMap[key] = value;
      }
    });
    User createdUser = await connection.users.saveModel(cleanedMap..["password"] = password);
    if (createdUser == null) {
      envelope.error(ERROR_IN_USER_CREATION);
      return null;
    }
    envelope.withMap(createdUser.toSafeMap());
    new log.Logger("akcnik.server.context.create_user").fine("user ${createdUser?.login} created");
    mailer.sendConfirmUserEmail(createdUser);
    return null;
  }
}

class CreateUserFromFacebookRequestContext extends libs.RequestContext {
  String token;
  User foundUser;
  Map<String, dynamic> facebookJson;

  Future validate() async {
    token = data["token"];
    http.Response response = await http.get(new Uri.https("graph.facebook.com", "/v2.6/me",
        {"access_token": token, "fields": "id,name,email,first_name,last_name,locale,currency"}));
    try {
      facebookJson = JSON.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      envelope.error("JSON is unparsable: " + response.body, DATA_NOT_VALID_JSON);
    }
  }

  Future execute() async {
    // connect to existing user by email
    foundUser = await connection.users.getUserByLoginOrEmail(facebookJson["email"]);
    if (foundUser != null) {
      foundUser.clientSettings["facebook_id"] = int.parse(facebookJson["id"]);
      foundUser = await connection.users
          .updateModel({"id": foundUser.id, "clientSettings": foundUser.clientSettings}, ["clientSettings"]);
      envelope.withMap(foundUser.toSafeMap());
      return null;
    }
    // create new user from facebook data
    String password = User.encryptPassword(facebookJson["first_name"] +
        "_" +
        facebookJson["last_name"] +
        "_" +
        new DateTime.now().microsecondsSinceEpoch.toString());
    Map<String, dynamic> userMap = {
      "login": facebookJson["email"],
      "email": facebookJson["email"],
      "firstName": facebookJson["first_name"],
      "surname": facebookJson["last_name"],
      "language": facebookJson["locale"],
      "clientSettings": {
        "currency": facebookJson["currency"]["user_currency"],
        "facebook_id": int.parse(facebookJson["id"])
      },
      "proven": true, // already proven user - email was validated by facebook
      "role": "user",
      "password": password,
    };
    User createdUser = await connection.users.saveModel(userMap);
    if (createdUser == null) {
      envelope.error(ERROR_IN_USER_CREATION);
      return null;
    }
    envelope.withMap(createdUser.toSafeMap());
    new log.Logger("akcnik.server.context.create_user_from_facebook").fine("user ${createdUser?.login} created");
    //mailer.sendConfirmUserEmail(createdUser);
    return null;
  }
}

class CreateUserFromGoogleRequestContext extends libs.RequestContext {
  String token;
  User foundUser;
  Map<String, dynamic> googleJson;

  Future validate() async {
    token = data["token"];
    http.Response response =
        await http.get(new Uri.https("www.googleapis.com", "/oauth2/v3/userinfo", {"access_token": token}));
    try {
      googleJson = JSON.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      envelope.error("JSON is unparsable: " + response.body, DATA_NOT_VALID_JSON);
      return null;
    }
    if (googleJson["sub"] == null) {
      envelope.error("Wrong googleAPI body: " + response.body, EXTERNAL_REQUEST_FAILED);
    }
  }

  Future execute() async {
    // connect to existing user by email
    foundUser = await connection.users.getUserByLoginOrEmail(googleJson["email"]);
    if (foundUser != null) {
      foundUser.clientSettings["google_id"] = int.parse(googleJson["sub"]);
      foundUser = await connection.users
          .updateModel({"id": foundUser.id, "clientSettings": foundUser.clientSettings}, ["clientSettings"]);
      envelope.withMap(foundUser.toSafeMap());
      return null;
    }
    // create new user from facebook data
    String password =
        User.encryptPassword(googleJson["name"] + "_" + new DateTime.now().microsecondsSinceEpoch.toString());
    Map<String, dynamic> userMap = {
      "login": googleJson["email"],
      "email": googleJson["email"],
      "firstName": googleJson["given_name"],
      "surname": googleJson["family_name"],
      "language": googleJson["locale"],
      "clientSettings": {
        "google_id": int.parse(googleJson["sub"]),
        "google_link": googleJson["profile"],
        "haveImage": googleJson["picture"] != null && googleJson["picture"] != ""
      },
      "maleGender": googleJson["gender"] == "male",
      "proven": true, // already proven user - email was validated by google
      "role": "user",
      "password": password,
    };
    User createdUser = await connection.users.saveModel(userMap);
    if (createdUser == null) {
      envelope.error(ERROR_IN_USER_CREATION);
      return null;
    }
    if (createdUser.clientSettings["haveImage"]) {
      await _saveImage(createdUser.id, googleJson["picture"]);
    }
    envelope.withMap(createdUser.toSafeMap());
    new log.Logger("akcnik.server.context.create_user_from_google").fine("user ${createdUser?.login} created");
    //mailer.sendConfirmUserEmail(createdUser);
    return null;
  }

  Future _saveImage(int id, String url) async {
    return http.get(url).then((http.Response response) {
      image_lib.Image image = image_lib.decodeImage(response.bodyBytes);
      new io.File('web/app/images/user_images/user_avatar_$id.png')
        ..createSync()
        ..writeAsBytes(image_lib.encodePng(image));
      return image;
    });
  }
}
