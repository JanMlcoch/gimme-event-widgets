part of view;

class EventDetailRatingWidget extends Widget {
  static const ACTIVE_CLASS = "active";
  static const SELECTED_CLASS = "selected";
  int defaultRating;
  int _selectedValue;
  bool changeable = true;
  StreamController<NewRatingEvent> _onValueSelectController = new StreamController();

  void set selectedValue(Object value) {
    _selectedValue = value;
    _onValueSelectController.add(new NewRatingEvent(value));
  }

  Stream<NewRatingEvent> get onValueSelect => _onValueSelectController.stream;

  EventDetailRatingWidget(this.defaultRating) {
    if (defaultRating == null) defaultRating = -1;
    template = parse(resources.templates.ui.rating);
  }

  @override
  Map out() {
    Map out = {};
    return out;
  }

  @override
  void functionality() {
    ElementList stars = querySelectorAll(".ratingItem");
    _resolveEndHover(stars);
    stars.forEach((Element star) {
      star.onMouseEnter.listen((_) {
        int index = int.parse(star.dataset["index"]);
        _resolveStarsHover(stars, index);
      });
      star.onMouseLeave.listen((_) {
        _resolveEndHover(stars);
      });
      star.onClick.listen((_) {
        if (!changeable && _selectedValue != null) {
          return;
        }
        int index = int.parse(star.dataset["index"]);
        _resolveStarsSelect(stars, index);
      });
    });
    Element container = select(".ratingStars");
    container.onMouseLeave.listen((_) {
      _resolveEndHover(stars);
    });
  }

  void _resolveStarsSelect(ElementList<Element> stars, int index) {
    selectedValue = index;
    for (int i = 0; i < stars.length; i++) {
      if (i <= index) {
        stars[i].classes.add(SELECTED_CLASS);
      } else {
        stars[i].classes.remove(SELECTED_CLASS);
      }
    }
  }

  void _resolveStarsHover(ElementList stars, int index) {
    for (int i = 0; i < stars.length; i++) {
      if (i <= index) {
        stars[i].classes.add(ACTIVE_CLASS);
      } else {
        stars[i].classes.remove(ACTIVE_CLASS);
      }
    }
  }

  Future _resolveEndHover(ElementList stars) async {
    for (int i = 0; i < stars.length; i++) {
      if (i <= defaultRating) {
        stars[i].classes.add(ACTIVE_CLASS);
      } else {
        stars[i].classes.remove(ACTIVE_CLASS);
      }
    }
  }

  @override
  void setChildrenTargets() {}

  @override
  void destroy() {}
}

class NewRatingEvent {
  int value;

  NewRatingEvent(this.value);
}
