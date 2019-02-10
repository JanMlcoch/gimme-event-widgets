library view;

import "dart:html";
import "dart:js" as js;
import "dart:async";
import "dart:math" as math;
import 'dart:typed_data' as typed_array;
import 'dart:convert';
import "package:intl/intl.dart";
import 'package:akcnik/envelope.dart' as envelope_lib;
import 'package:akcnik/resources.dart';
import 'package:akcnik/ui.dart';
import 'package:akcnik/constants/constants.dart';
import 'package:akcnik/common/library.dart';
import 'package:google_maps/google_maps.dart' as g_m;
import 'package:google_maps/google_maps_places.dart' as g_m_p;
import 'package:css_animation/css_animation.dart' as animation_lib;
import '../model/root.dart';
import '../model/view_model/library.dart';
import "../form/library.dart";
import '../gateway/gateway.dart';
import '../test/test_manager.dart';
import '../helpers/facebook_helpers.dart' as fb_helpers;

// google_helpers contains mirrors
import '../helpers/google_helpers.dart' as google_helpers;

part "widgets/map.dart";

part "widgets/layout.dart";

part "widgets/navbar.dart";

part "widgets/pages/confirm_user.dart";

part "widgets/pages/forgotten_password.dart";

part "widgets/pages/reset_password.dart";

part "widgets/map/create_search.dart";

part 'widgets/pages/test_manager.dart';

part 'widgets/planned_events/planned_events.dart';

part "widgets/user_signing/login.dart";

part "widgets/user_settings/user_settings.dart";

part 'widgets/user_settings/base.dart';

part 'widgets/ui/city_autocomplete/city_autocomplete.dart';

part 'widgets/ui/city_autocomplete/city_autocomplete_options.dart';

part "widgets/user_settings/my_events.dart";

part "widgets/user_settings/calendar.dart";

part "widgets/user_settings/personal_preferences.dart";

part "widgets/user_settings/places_and_organizers.dart";

part "widgets/user_settings/social.dart";

part "widgets/user_settings/place_card.dart";

part "widgets/user_settings/event_card.dart";

part "widgets/ui/smart_select/cont_widget.dart";

part "widgets/ui/smart_select/options_widget.dart";

part "widgets/ui/smart_select/option_widget.dart";

part "widgets/ui/smart_select/tag_widget.dart";

part "widgets/ui/smart_select/tags_widget.dart";

part "widgets/ui/image_picker.dart";

part "widgets/ui/time_picker.dart";

part "widgets/left_sidebar/left_sidebar.dart";

part "widgets/central.dart";

part "widgets/left_sidebar/event_detail/event_detail.dart";

part "widgets/ui/rating.dart";

part "widgets/left_sidebar/events/footer.dart";

part "widgets/left_sidebar/events/event_filter_widget_base.dart";

part "widgets/left_sidebar/events/event.dart";

part "widgets/left_sidebar/events/events.dart";

part "widgets/left_sidebar/events/events_list.dart";

part "widgets/manage_event/layout.dart";

part "widgets/manage_event/manage_event_widget.dart";

part "widgets/manage_event/simple/base.dart";
part "widgets/manage_event/simple/new_place_dialog.dart";

part "widgets/manage_event/simple/extended.dart";
part "widgets/manage_event/common/gallery.dart";

part "widgets/manage_event/common/social.dart";
part 'widgets/manage_event/facebook/manage_facebook_events.dart';
part 'widgets/manage_event/facebook/facebook_event.dart';

part "widgets/user_signing/sign_up.dart";

part "widgets/user_signing/sign_step_1.dart";

part "widgets/user_signing/sign_step_2.dart";

part "widgets/user_signing/sign_step_3.dart";

part "widgets/user_signing/sign_step_4.dart";

Lang lang;
GeneratedResources resources;
View view;

LayoutModel layoutModel;

class View {
  Element root;
  LayoutWidget layoutWidget;
  List<Widget> widgets = [];
  MapWidget mapWidget;

  View(this.root) {
    init();
  }

  void init() {
    view = this;
    layoutWidget = new LayoutWidget();
    layoutWidget.target = root;
    widgets.add(layoutWidget);

    mapWidget = new MapWidget();
    mapWidget.target = querySelector("#appMapWidgetCont");
    widgets.add(mapWidget);

    repaint(null);
  }

  void repaint(dynamic _) {
    for (Widget w in widgets) {
      w.repaint();
    }
    window.requestAnimationFrame(repaint);
  }
}

void setResourcesInView(GeneratedResources val) {
  resources = val;
}

void setLangInView(Lang val) {
  lang = val;
}

void setViewModelInView(LayoutModel insertedModel) {
  layoutModel = insertedModel;
}

void hide(Element element) {
  element.classes.add("hidden");
}

void show(Element element) {
  element.classes.remove("hidden");
}

void fireChanges(List<Function> list) {
  for (Function f in list) {
    f();
  }
}
