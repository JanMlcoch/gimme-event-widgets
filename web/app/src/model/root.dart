library model;

import "package:akcnik/common/library.dart";
import "dart:async";
import "dart:html";
import "dart:convert";
import "package:akcnik/constants/constants.dart";
import "package:intl/intl.dart";
import 'package:akcnik/resources.dart';
import "package:akcnik/envelope.dart" as envelope_lib;
import 'package:google_maps/google_maps.dart' as g_m;
import '../gateway/gateway.dart';
import '../test/test_manager.dart';


part "place/places.dart";

part "place/quick_place.dart";

part "place/create_place.dart";

part "place/places_model.dart";

part "place/gps.dart";

part "user.dart";

part "cost.dart";

part "smart_select_model.dart";

part "event.dart";

part "events.dart";

part "manage_event.dart";

part "organizer.dart";

part "map_data.dart";

part "registration.dart";

part "events_model.dart";

part "organizers_model.dart";

part "routes.dart";

part "tags.dart";

part "app_state.dart";

part "city_autocomplete.dart";

part "points_of_origin.dart";

List<Function> _onLangLoaded = [];
Lang lang;

void setLangInModel(Lang value) {
  lang = value;
  _onLangLoaded.forEach((Function f) => f());
}

Model model;

class Model {
  ClientUser user;
  ManageEventModel createEvent;
  OrganizersModel organizersModel;
  PlacesModel placesModel;
  EventsModel eventsModel;
  ClientTestModel testModel;
  AppState appState;
  MapData map;
  Routes routes;

  Model() {
    model = this;
    placesModel = new PlacesModel();
    organizersModel = new OrganizersModel();
    user = new ClientUser();
    routes = new Routes();
    appState = new AppState();
    eventsModel = new EventsModel();
    testModel = new ClientTestModel();
    map = new MapData();
    createEvent = new ManageEventModel();
  }

}