part of server.mailer.private;

class Mailer {
  static mailer.SmtpOptions options = new mailer.GmailSmtpOptions()
    ..username = 'akcnikservice@gmail.com'
    ..password = 'u2fk0BRJ5kSycSE3TQr';
  // Note: if you have Google's "app specific passwords" enabled,
  // you need to use one of those here.
  // How you use and store passwords is up to you. Beware of storing passwords in plain.

  // Create our email transport.
  mailer.SmtpTransport emailTransport;
  ResourcesProvider resources;
  StreamController<String> testOut;
  static Mailer _instance = new Mailer._();
  static Mailer get instance => _instance;
  Mailer._() {
    emailTransport = new mailer.SmtpTransport(options);
    resources = ResourcesProvider.instance;
  }

  Future<bool> _sendEnvelope(mailer.Envelope envelope) async {
    if (testOut != null) {
      testOut.add(await envelope.getContents());
      return true;
    }
    try {
      await emailTransport.send(envelope);
      print("Email sent!");
      return true;
    } catch (e) {
      print('Error occurred while sending email: $e');
      return false;
    }
  }

  mailer.Envelope _constructEmail(User user, Map<String, dynamic> data, Map<String, String> partials) {
    String emailTemplate = resources.resources.templates.emailer.emailTemplate;
    Lang lang = resources.getLangByShortcut(user.language);
    Map<String, dynamic> fullData = lang.mailer.toMap()
      ..addAll(data)
      ..["plain"] = false;
//    data..addAll(lang.mailer.toMap())..["plain"]=false;
    String title = data["title"];
    if (title == null) {
      if (data["emailType"] == null) throw new ArgumentError("missing emailType");
      if (fullData[data["emailType"]] == null) throw new ArgumentError("wrong emailType (without lang group)");
      title = fullData[data["emailType"]]["header"] + lang.mailer.on_portal;
      fullData["title"] = title;
    }
    Map<String, String> fullPartials = {
      "afterNote": resources.resources.templates.emailer.afterNote,
      "contact": resources.resources.templates.emailer.contact
    }
      ..addAll(partials);
    mailer.Envelope email = new mailer.Envelope()
      ..from = options.username
      ..recipients.add(user.email)
//    ..bccRecipients.add('hidden@recipient.com')
      ..subject = title
//      ..attachments.add(new Attachment(file: new File('test/email/no_image.jpg')))
      ..html = _enhanceHtml(emailTemplate, fullData, fullPartials, false);
    fullData["plain"] = true;
    email.text = _enhanceHtml(emailTemplate, fullData, fullPartials, true);
    return email;
  }

  String _enhanceHtml(String template, Map<String, dynamic> data, Map<String, String> partials, bool makePlain) {
    template = ResourcesProvider.enhanceByPartials(template, partials);
    if (makePlain) {
      template = PlainConverter.convert(template);
    }
    return mustache.parse(template).renderString(data);
  }
}
