part of view;

class TimePicker {
  InputElement input;
  Template template;
  Element cont;
  Function onFinish;
  static const List<String> morning = const[
    "7:00",
    "8:00",
    "9:00",
    "10:00",
    "11:00",
    "12:00",
  ];
  static const List<String> afternoon = const[
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
  ];
  static const List<String> evening = const[
    "18:30",
    "19:00",
    "19:30",
    "20:00",
    "20:30",
    "21:00",
    "22:00",
    "23:00",
  ];

  TimePicker(this.input, this.onFinish) {
    template = parse("""
       <div class="timePickerCont">
         <div class="datePart">
          {{#morning}}
            <span class='timePickerValue'>{{.}}</span>
          {{/morning}}
          </div>
          <div class="datePart">
          {{#afternoon}}
            <span class='timePickerValue'>{{.}}</span>
          {{/afternoon}}
          </div>
          <div class="datePart">
          {{#evening}}
            <span class='timePickerValue'>{{.}}</span>
          {{/evening}}
          </div>
       </div>
    """);
    input.onFocus.listen((_) {
      OverlayDiv overlay = new OverlayDiv();
      overlay.div.innerHtml = getHtml();
      overlay.div.style.zIndex = "10";
      cont = overlay.div.querySelector(".timePickerCont");
      CssRect rect = input.marginEdge;
      cont.style
        ..top = "${rect.bottom}px"
        ..left = "${rect.left}px";
      overlay.div.querySelectorAll(".timePickerValue").forEach((Element e) {
        e.onClick.listen((_) {
          input.value = e.text;
          overlay.destroy();
          onFinish();
        });
      });
      overlay.div.onClick.listen((_) => overlay.destroy());
    });
  }

  String getHtml() {
    Map out = {};
    out["morning"] = morning;
    out["afternoon"] = afternoon;
    out["evening"] = evening;
    return template.renderString(out);
  }
}