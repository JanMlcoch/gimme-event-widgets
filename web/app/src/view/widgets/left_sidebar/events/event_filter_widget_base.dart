part of view;

abstract class EventFilterWidgetBase extends Widget {
  List<Map> getFilterData() {
    return [{"name": "none", "data":[]}];
  }
}