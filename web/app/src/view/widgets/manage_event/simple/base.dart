part of view;

class ManageEventBaseWidget extends ManageEventWidget {
  static const int height = 200;
  static const int width = 200;
  static String cannotBeEmpty = lang.forms.cannotBeEmpty;
  bool forceValidate = false;

  SmartSelectContWidget _tagSelect;
  ImagePickerWidget _imagePicker;
  LeftSidebarWidget sidebarWidget;

  InputElement _from;
  InputElement _to;
  InputElement _fromTime;
  InputElement _toTime;
  InputElement _nameInput;
  TextAreaElement _annotation;

  DivElement _ssContainer;

  Element _imageContainer;
  Element _findAndSelectPlaceOnMap;

  Element eventNameValidatorMessage;
  Element eventFromValidatorMessage;
  Element eventFromTimeValidatorMessage;
  Element eventToValidatorMessage;
  Element eventToTimeValidatorMessage;
  Element eventAnnotationValidatorMessage;

  FormSectionReport nameReport;
  FormSectionReport dateFromReport;
  FormSectionReport dateToReport;
  FormSectionReport timeFromReport;
  FormSectionReport timeToReport;
  FormSectionReport annotationReport;

  NewPlaceDialog newPlaceDialog;
  ClientPlace emptyPlaceToFill;

  Element _slider;

  LeftPanelModel get model => layoutModel.leftPanelModel;

  ManageEventBaseWidget(String name, this.sidebarWidget) : super(name) {
    template = parse(resources.templates.manageEvent.simple.base);
    widgetLang = lang.manageEvent.baseLangs.toMap();
    resetWidget();
    children = [_tagSelect, _imagePicker];
    model.createEvent.onPlacesChanged.add(_onPlaceChanged);
    sidebarWidget.onMinimizationChange.add(_minimizeChanged);
    model.onNewPlaceRequested.add(_createPlaceDialog);
  }

  void _onPlaceChanged(){
    sidebarWidget.maximizePanel();
    requestRepaint();
  }

  void _minimizeChanged(){
    if(!sidebarWidget.minimized){
      model.selectEventMode();
    }
  }

  @override
  void destroy() {
    model.createEvent.onPlacesChanged.remove(_onPlaceChanged);
    model.onNewPlaceRequested.remove(_createPlaceDialog);
    sidebarWidget.onMinimizationChange.remove(_minimizeChanged);
  }

  @override
  Map out() {
    ClientEvent clientEvent = model.createEvent.event;
    Map out = {};
    out["lang"] = widgetLang;
    out["name"] = clientEvent.name;
    if (clientEvent.from != null) {
      out["from"] = model.createEvent.dateFormat.format(clientEvent.from);
      out["fromTime"] =
          model.createEvent.timeFormat.format(clientEvent.from);
    } else {
      out["from"] = "";
      out["fromTime"] = "10:00";
    }
    if (clientEvent.to != null) {
      out["to"] = model.createEvent.dateFormat.format(clientEvent.to);
      out["toTime"] = model.createEvent.timeFormat.format(clientEvent.to);
    } else {
      out["to"] = "";
      out["toTime"] = "12:00";
    }
    out["annotation"] = clientEvent.annotation;
    out["image"] = clientEvent.imageData;

    out["hasPlace"] = clientEvent.mapPlace != null;
    out["placeName"] = clientEvent.mapPlace == null ? "" : clientEvent.mapPlace.name;

    out["editImageSRC"] = "images/icons/question_mark.png";
    return out;
  }

  @override
  void setChildrenTargets() {
    _tagSelect.target = _ssContainer;
    _imagePicker.target = _imageContainer;
  }

  @override
  void functionality() {
    _ssContainer = target.querySelector(".tagSmartSelectContainer");

    _toTime = target.querySelector("#eventToTime");
    _fromTime = target.querySelector("#eventFromTime");
    _nameInput = target.querySelector(".appManageEventName");
    _from = target.querySelector("#eventFrom");
    _to = target.querySelector("#eventTo");
    _annotation = target.querySelector("#appEventAnnotation");

    eventNameValidatorMessage = select(".eventNameValidatorMessage");
    eventFromValidatorMessage = select(".eventFromValidatorMessage");
    eventToValidatorMessage = select(".eventToValidatorMessage");
    eventFromTimeValidatorMessage = select(".eventFromTimeValidatorMessage");
    eventToTimeValidatorMessage = select(".eventToTimeValidatorMessage");
    eventAnnotationValidatorMessage = select(".eventAnnotationValidatorMessage");

    _findAndSelectPlaceOnMap = select(".findAndSelectPlaceOnMap");

    _imageContainer = target.querySelector(".eventImageBlock");

    _nameInput.onKeyUp.listen((_) {
      model.createEvent.setName(_nameInput.value);
      nameReport.checkValidity();
    });

    _annotation.onKeyUp.listen((_) {
      model.createEvent.setAnnotation(_annotation.value);
    });

    void confirmFromTime([_]) {
      model.createEvent.setFromTime(_fromTime.value);
      _checkTimeToIsAfterTimeFrom();
    }

    _fromTime.onKeyUp.listen(confirmFromTime);

    void confirmToTime([_]) {
      model.createEvent.setToTime(_toTime.value);
      timeToReport.checkValidity();
      if (model.createEvent.event.from != null && model.createEvent.event.to != null) {
        dateToReport.checkValidity();
      }
    }

    _toTime.onKeyUp.listen(confirmToTime);

    new TimePicker(_fromTime, confirmFromTime);
    new TimePicker(_toTime, confirmToTime);

    _imagePicker.onChange.add(() {
      if (_imagePicker.imgSrc == null || _imagePicker.imgSrc == "") {
        return;
      }
      model.createEvent.setImageData(_imagePicker.imgSrc);
    });

    _slider = select("#cropperZoom");


    js.context.callMethod(
        "setDatePickerRegional", [model.userLanguage, new js.JsObject.jsify(lang.datePicker.toMap())]);
    js.context.callMethod(r'$', ['#eventFrom']).callMethod('datepicker', [
      new js.JsObject.jsify({"onSelect": _fromChanged, "onClose": _validateDateFrom, "minDate": 0})
    ]);

    js.context.callMethod(r'$', ['#eventTo']).callMethod('datepicker', [
      new js.JsObject.jsify({"onSelect": _toChanged, "onClose": _validateDateTo, "minDate": 0})
    ]);

    _from.onKeyUp.listen((_) {
      _fromChanged();
    });
    _to.onKeyUp.listen((_) {
      _toChanged();
    });

    _createValidator();
    if (checkAfterRepainted) {
      validator.checkValidity();
    }
    if (forceValidate) {
      forceValidate = false;
    }
    if (model.isEdit()) {
      validator.checkValidity();
    }

    _findAndSelectPlaceOnMap.onClick.listen((_) {
      sidebarWidget.minimizePanel();
      model.selectPlaceMode();
      model.sendMapMessage(lang.manageEvent.baseLangs.createPlaceTooltip);
    });
  }

  void _createPlaceDialog(){
    if(newPlaceDialog!=null){
      newPlaceDialog.destroy();
    }
    emptyPlaceToFill = new ClientPlace();
    emptyPlaceToFill.gpsCont = new Gps.fromLatLng(model.newPlaceLatLng);
    emptyPlaceToFill.name = model.newPlaceName;
    newPlaceDialog = new NewPlaceDialog(emptyPlaceToFill,model);
  }

  void _validateDateFrom([_, dynamic _nope]) {
    bool dateFromValid = dateFromReport.checkValidity();
    if (dateFromValid) {
      dateToReport.checkValidity();
    } else {
      dateToReport.hideValidityMessage();
    }
  }

  void _validateDateTo([_, dynamic _nope]) {
    dateToReport?.checkValidity();
  }

  void _createValidator() {
    validator.clearValidators();
    validator.addSubValidator(_tagSelect.validator);
    validator.addSectionReport(_createEventNameReport());
    validator.addSectionReport(_createEventDateFromReport());
    validator.addSectionReport(_createEventTimeFromReport());
    validator.addSectionReport(_createEventDateToReport());
    validator.addSectionReport(_createEventTimeToReport());
    validator.addSectionReport(_createEventAnnotationReport());
  }

  FormSectionReport _createEventNameReport() {
    nameReport = new FormSectionReport("eventName", _nameInput, eventNameValidatorMessage);
    nameReport.addSectionValidator(new FormSectionStringValidator.notEmpty(validityMessage: cannotBeEmpty));
    nameReport.addSectionValidator(
        new FormSectionStringValidator.minimalChars(3, validityMessage: lang.manageEvent.validators.base.tooShortName));
    return nameReport;
  }

  FormSectionReport _createEventDateFromReport() {
    dateFromReport = new FormSectionReport("eventFromDate", _from, eventFromValidatorMessage, validateAfterBlur: false);
    dateFromReport.addSectionValidator(new FormSectionStringValidator.notEmpty(validityMessage: cannotBeEmpty));
    dateFromReport.addSectionValidator(
        new FormSectionDateValidator(validityMessage: lang.manageEvent.validators.base.dateInvalidFormat));
    return dateFromReport;
  }

  FormSectionReport _createEventTimeFromReport() {
    timeFromReport =
    new FormSectionReport("eventFromTime", _fromTime, eventFromTimeValidatorMessage, beforeBlur: _editTimeFormat);
    timeFromReport.addSectionValidator(
        new FormSectionTimeValidator(validityMessage: lang.manageEvent.validators.base.timeInvalidFormat));
    return timeFromReport;
  }

  FormSectionReport _createEventDateToReport() {
    dateToReport = new FormSectionReport("eventDateTo", _to, eventToValidatorMessage, validateAfterBlur: false);
    dateToReport.addSectionValidator(new FormSectionStringValidator.notEmpty(validityMessage: cannotBeEmpty));
    dateToReport.addSectionValidator(
        new FormSectionDateValidator(validityMessage: lang.manageEvent.validators.base.dateInvalidFormat));
    dateToReport.addSectionValidator(new FormSectionDateTimeCompareValidator(
        _getDateTimeFrom, _getDateTimeTo, validityMessage: lang.manageEvent.validators.base.endBeforeStart));
    return dateToReport;
  }

  FormSectionReport _createEventTimeToReport() {
    timeToReport =
    new FormSectionReport("eventTimeTo", _toTime, eventToTimeValidatorMessage, beforeBlur: _editTimeFormat);
    timeToReport.addSectionValidator(
        new FormSectionTimeValidator(validityMessage: lang.manageEvent.validators.base.timeInvalidFormat));
    return timeToReport;
  }

  FormSectionReport _createEventAnnotationReport() {
    annotationReport = new FormSectionReport("eventAnnotation", _annotation, eventAnnotationValidatorMessage);
    annotationReport.addSectionValidator(new FormSectionStringValidator.notEmpty(validityMessage: cannotBeEmpty));
    return annotationReport;
  }

  DateTime _getDateTimeFrom() {
    return model.createEvent.event.from;
  }

  DateTime _getDateTimeTo() {
    return model.createEvent.event.to;
  }

  String _editTimeFormat(String value) {
    RegExp to24 = new RegExp("^[0-9]\$|^[01][0-9]\$|^2[0-4]\$");
    if (to24.hasMatch(value)) {
      value = "$value:00";
    }
    return value;
  }

  void resetWidget() {
    _imagePicker = new ImagePickerWidget(USER_AVATAR_WIDTH, USER_AVATAR_HEIGHT,
        imgSrc: model.createEvent.event.imageData, label: widgetLang["imageLabel"]);
    _tagSelect = new SmartSelectContWidget(model.createEvent.smartSelectModel);
  }

  void _checkTimeToIsAfterTimeFrom() {
    String fromInput = _from.value;
    String toInput = _to.value;
    DateTime from = model.createEvent.event.from;
    DateTime to = model.createEvent.event.to;
    if (to == null) {
      _setTimeTo(_fromTime.value);
      return;
    }
    if (fromInput == toInput && to.isBefore(from)) {
      _setTimeTo(_fromTime.value);
    }
  }

  void _setTimeTo(String newTime) {
    _toTime.value = newTime;
    _toChanged();
  }

  void _fromChanged([_, dynamic _nope]) {
    model.createEvent.setFromDate(_from.value);
    if (model.createEvent.event.to == null) {
      _to.value = _from.value;
      _toChanged();
    }
    dateFromReport.checkValidity();
  }

  void _toChanged([_, dynamic _nope]) {
    model.createEvent.setToDate(_to.value);
  }

  String convertDateFormat(String jQueryFormat) {
    jQueryFormat = jQueryFormat.replaceAll("mm", "MM");
    return jQueryFormat;
  }
}