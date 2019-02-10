part of server.mailer.private;


class PlainConverter {
  static const Map<String, String> headerUnderscores = const {
    "1": " ______ ",
    "2": " _____ ",
    "3": " ____ ",
    "4": " ___ ",
    "5": " __ ",
    "6": " _ "
  };
  static final RegExp commentHeadRegExp = new RegExp(r'<!--[\s\S]*?-->|<head[\s\S]*head>');
  static final RegExp linkRegExp = new RegExp('<a [^<>]*href=("|\')([^"\'<>]*)\\1.*?>.*?<\\/a>');
  static final RegExp headingRegExp = new RegExp(r'<h(\d)>([^<>]*)<\/h\1>');
  static final RegExp newLineRegExp = new RegExp(r'(<\/?(div|p|br)>\s*)+');
  static final RegExp tagsRegExp = new RegExp(r'<[^<>]*>\s*');

  static String convert(String html) {
    html = html.replaceAll(commentHeadRegExp, "");
    html = html.replaceAllMapped(
        linkRegExp, (Match match) => match.group(2));
    html = html.replaceAll("<hr>", "<p>------------------------------</p>");
    html = html.replaceAllMapped(headingRegExp, (Match match) {
      return headerUnderscores[match.group(1)] + match.group(2) + headerUnderscores[match.group(1)] + "\n<p>";
    });
    html = html.replaceAll(newLineRegExp, "\n");
    html = html.replaceAll(tagsRegExp, "");
    return html;
  }
}
