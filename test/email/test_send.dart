library mail;

import "package:mailer/mailer.dart";
import "dart:io";

/// this test is no test, so it has to be run and check manually

void main() {
  var options = new GmailSmtpOptions()
    ..username = 'akcnikservice@gmail.com'
    ..password = 'u2fk0BRJ5kSycSE3TQr'; // Note: if you have Google's "app specific passwords" enabled,
  // you need to use one of those here.

  // How you use and store passwords is up to you. Beware of storing passwords in plain.

  // Create our email transport.
  var emailTransport = new SmtpTransport(options);

  // Create our mail/envelope.
  var envelope = new Envelope()
    ..from = 'akcnikservice@gmail.com'
    ..recipients.add('mlcoch.zdenek@seznam.cz')
//    ..bccRecipients.add('hidden@recipient.com')
    ..subject = 'Testing the Dart Mailer library 語 ěšščřřžžýá'
    ..attachments.add(new Attachment(file: new File('test/email/no_image.jpg')))
    ..text = 'This is a cool email message. Whats up? 語'
    ..html = '<h1>Test</h1><p>Hey!</p>';

  // Email it.
  emailTransport.send(envelope).then((envelope) => print('Email sent!')).catchError((e) => print('Error occurred: $e'));
}
