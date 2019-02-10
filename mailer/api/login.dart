part of server.mailer;

ResourcesProvider get resources => Mailer.instance.resources;

Future<bool> sendResetPasswordEmail(User user) {
  Map<String, String> partials = {
    "content": resources.resources.templates.emailer.resetPassword
  };
  Map<String, dynamic> data = {
    "token": user.authenticationToken,
    "emailType":"reset_password"
  };
  return sendEmail(user, data, partials);
}

Future<bool> sendConfirmUserEmail(User user) {
  Map<String, String> partials = {
    "content": resources.resources.templates.emailer.confirmUser
  };
  Map<String, dynamic> data = {
    "token": user.authenticationToken,
    "emailType":"confirm_user"
  };
  return sendEmail(user, data, partials);
}
Future<bool> sendMergeUserEmail(User user, User secondaryUser){
  Map<String, String> partials = {
    "content": resources.resources.templates.emailer.mergeUsers
  };
  Map<String, dynamic> data = {
    "token": user.authenticationToken,
    "secondToken": user.authenticationToken,
    "emailType":"merge_users"
  };
  return sendEmail(secondaryUser, data, partials);
}
