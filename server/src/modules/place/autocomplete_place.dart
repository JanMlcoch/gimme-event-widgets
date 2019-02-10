part of placeModule;

void _bindAutocompletePlace() {
  libs.route(CONTROLLER_AUTOCOMPLETE_PLACES, () => new AutocompletePlacesRC(),
      method: "POST", template: {"substring": "string"});
}

class AutocompletePlacesRC extends libs.RequestContext {
  Future validate() {
    return null;
  }

  @override
  Future<dynamic> execute() {
    String substring = data["substring"];
    List<String> subStrings = [];
    String word = "";
    for (int i = 0; i < substring.length; i++) {
      String s = substring[i];
      if (s != " ") {
        word += s;
      } else {
        subStrings.add(word);
        word = "";
      }
    }
    if (word.length > 0) {
      subStrings.add(word);
    }
    Map<Place, int> found = {};
    for (String substring in subStrings) {
      RegExp search = new RegExp(substring, caseSensitive: false);
      for (Place place in storage.memory.model.places.list) {
        bool foundAtStart = false;

        for (String word in place.wordsForSearchInName) {
          if (word.startsWith(search)) {
            foundAtStart = true;
            break;
          }
        }

        if (foundAtStart) {
          if (found.containsKey(place)) {
            found[place] += 10;
          } else {
            found[place] = 10;
          }
        } else if (place.name.contains(search)) {
          if (found.containsKey(place)) {
            found[place] += 2;
          } else {
            found[place] = 2;
          }
        } else if (place.description != null && place.description.startsWith(search)) {
          if (found.containsKey(place)) {
            found[place]++;
          } else {
            found[place] = 1;
          }
        }
      }
    }

    List<Place> out = new List(found.length);
    int index = 0;
    found.forEach((Place key, int value) {
      key.tempSearchRating = value;
      out[index] = key;
      index++;
    });

    out.sort((Place place1, Place place2) {
      return place2.tempSearchRating - place1.tempSearchRating;
    });

    if (out.length > 15) {
      out = out.sublist(0, 15);
    }

    List<Map> listOut = [];
    for (Place p in out) {
      listOut.add(p.toFullMap());
    }

    envelope.withList(listOut);
    return null;
  }
}
