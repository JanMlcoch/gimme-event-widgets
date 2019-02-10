part of model;

class SmartSelectModel {
  bool active = false;

  // list for output

  List<Tag> _chosenTags = [];
  List<Tag> get chosenTags => _chosenTags;

  // full filtered list from server
  List<Tag> options = [];
  Tag _activeOption;
  Tag get activeOption=>_activeOption;

  List<Function> onActiveOptionChange = [];
  List<Function> onChosenChanged = [];

  // needed to clear input only for add
  List<Function> onChosenAdded = [];
  List<Function> onOptionsChanged = [];

  String placeholder = "";
  String _substring;
  String get substring => _substring;

  SmartSelectModel();

  void setSubstring(String val) {
    _substring = val;
    if (_substring.length > 1) {
      getOptions();
    } else {
      options.clear();
      for (Function f in onOptionsChanged) {
        f();
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    List out = [];
    for(Tag tag in _chosenTags){
      out.add(tag.toMap());
    }
    map["selectedTags"] = out;
    return map;
  }

  void setActiveOption(Tag val) {
    if (activeOption == val) return;
    _activeOption = val;
    onActiveOptionChange.forEach((Function f) => f());
  }

  void reset() {
    _chosenTags.clear();
    options.clear();
    _activeOption = null;
    _substring = "";
  }

  Future getOptions() async {
    envelope_lib.Envelope envelope = (await Gateway.instance.post(CONTROLLER_TAG_FILTER_GET_OPTIONS, data: {
      "substring": _substring
    }));

    if(envelope.isError){
      // TODO: display system message
      return;
    }

    options.clear();
    for (Map tag in envelope.list) {
      options.add(new Tag()..fromMap(tag));
    }

    if (options.isNotEmpty) {
      setActiveOption(options.first);
    }

    for (Function f in onOptionsChanged) {
      f();
    }
  }

  void addChosenTag(Tag tag) {
    if (_chosenTags.contains(tag)) return;
    _chosenTags.add(tag);
    _substring = "";
    onChosenAdded.forEach((Function f) => f());
    onChosenChanged.forEach((Function f) => f());
  }

  void removeChosenTag(Tag tag) {
    chosenTags.remove(tag);
    onChosenChanged.forEach((Function f) => f());
  }

  void moveDown() {
    if (activeOption == null) {
      if (options.isNotEmpty) {
        _activeOption = options.first;
      }
      return;
    }
    int index = options.indexOf(activeOption);
    if (index == -1 || index > options.length - 2) return;
    setActiveOption(options[index + 1]);
  }

  void onMoveUp() {
    if (activeOption == null) return;
    int index = options.indexOf(activeOption);
    if (index < 1) return;
    setActiveOption(options[index - 1]);
  }

  void confirm() {
    if (activeOption == null) return;
    if (!activeOption.tagName.toLowerCase().contains(substring.toLowerCase())) return;
    setSubstring("");
    addChosenTag(activeOption);
  }

  void fromEvent(ClientEvent event) {
    _chosenTags.clear();
    for(Tag tag in event.tags){
      addChosenTag(tag);
    }
    onOptionsChanged.forEach((f)=>f());
    onChosenChanged.forEach((f)=>f());
  }
}
