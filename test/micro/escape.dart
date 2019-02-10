library escape;

//import "package:mailer/mailer.dart";
//import "dart:io";
import "dart:convert";

void main() {
  String input = """
      <div class="eventPlacesHintsBlock">
    <h4>{{lang.eventPlacesHintsLabel}}</h4>
    {{#hints}}
        <div class="eventPlacesHint">
            <span class="col-md-9">{{text}}</span>
            <button class="akcButton small">{{lang.eventPlacesUseHint}}</button>
        </div>
    {{/hints}}
    </div>

  """;

  print(escapeAndShorten(input));
}

String escapeAndShorten(String input) {
  String out = input;
  if (out.length > 400) {
    out = out.substring(0, 399);
  }
  var sanitizer = const HtmlEscape();
  out = sanitizer.convert(out);
  out = "\\\\\\" + out;
  out = out.replaceAll("\n", "<br />\n\\\\\\");
  return out;
}
