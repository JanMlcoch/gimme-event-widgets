library akcnik.web.google.helpers;

import "package:googleapis_auth/auth_browser.dart" as google_auth;
import 'dart:async';
import 'dart:html';
//import '../model/root.dart';

google_auth.ClientId _applicationId =
    new google_auth.ClientId("635260593170-eefq1ock9bmm3je9f47058bn6b84q2dh.apps.googleusercontent.com", null);
List<String> _basicScope = [
  "https://www.googleapis.com/auth/userinfo.email",
  "https://www.googleapis.com/auth/userinfo.profile"
];

Future<google_auth.BrowserOAuth2Flow> createFlow({List<String> fullScope, List<String> authScope}) {
  List<String> transformedScope;
  if (fullScope == null) {
    if (authScope != null) {
      transformedScope = authScope.map((String scope) => "https://www.googleapis.com/auth/$scope").toList();
    }
  }
  if (transformedScope == null) {
    transformedScope = _basicScope;
  }
  return google_auth
      .createImplicitBrowserFlow(_applicationId, transformedScope)
      .then((google_auth.BrowserOAuth2Flow flow) {
    return flow;
  });
}
void _defaultOnDecline(e){
  print("Google authentication failed");
}
void _defaultOnError(e){
  print("Google login failed: " + e.toString());
}

Future<bool> initAuthButton(Element button, Future<bool> onSuccess(String token),{void onDecline(e):_defaultOnDecline,void onError(e):_defaultOnError, List<String> scope: null}) {
  return createFlow(authScope: scope).then((google_auth.BrowserOAuth2Flow flow) {
    button.onClick.listen((_) {
      String token;
      flow.obtainAccessCredentialsViaUserConsent().then((google_auth.AccessCredentials credentials) {
        token = credentials.accessToken.data;
        return onSuccess(token);
      }).catchError((google_auth.UserConsentException e) {
        onDecline(e.message);
        button.setAttribute("disabled", "disabled");
        return false;
      }, test: (e) => e is google_auth.UserConsentException).catchError((e) {
        onError(e);
        button.setAttribute("disabled", "disabled");
        return false;
      }).whenComplete(() {
        flow.close();
      });
    });
  });
}
