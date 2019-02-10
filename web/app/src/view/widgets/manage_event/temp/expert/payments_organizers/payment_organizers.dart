part of view;

class ManageEventPaymentAndOrganizersWidget extends Widget {
  ManageCostsWidget costsWidget;
  AddOrganizerWidget addOrganizerWidget;
  bool _paymentEditing = false;

  ManageEventPaymentAndOrganizersWidget() {
    template = parse(resources.templates.addEvent.paymentsOrganizers.paymentsOrganizers);
    costsWidget = new ManageCostsWidget(model.createEvent.costs);
    addOrganizerWidget = new AddOrganizerWidget();
//    children.add(costsWidget);
  }

  @override
  void destroy() {
    children.forEach((Widget w) {
      w.destroy();
    });
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.manageEvent.paymentsAndOrganizersLangs.toMap();
    out["languages"] = LANGUAGES;
    out["defaultCurrency"] = lang.defaultCurrency;
//    out["hasPlaces"] = !model.createEvent.event.places.isEmpty;
//    out["eventPlaces"] = model.createEvent.event.getPlacesViewJson();
    out["isOrganizerSelected"] = !model.createEvent.event.organizers.isEmpty;
    out["admissions"] = _getAdmissions();
    out["admissionFlags"] = [];
    out["admissionCurrencies"] = [];
    out["organizers"] = _getOrganizers();
    return out;
  }

  List _getAdmissions(){
    List admissions = [];
    admissions = model.createEvent.event.getAdmissionsJson();
    if(admissions.isEmpty){
      ClientCost newCost = new ClientCost.fromData(0,model.user.currency,null,1);
      admissions.add(newCost.toViewMap());
    }
    return admissions;
  }

  List _getOrganizers(){
    List organizers = [];
//    TODO: remove and replace with model data
    Map testOrganizer = {};
    testOrganizer["name"] = "Ministersvo Kultury ČR";
    testOrganizer["flag"] = "Hlavní organizátor";
    organizers.add(testOrganizer);
    return organizers;
  }

  @override
  void setChildrenTargets() {
    costsWidget.target = target.querySelector(".appManageCostsTarget");
    addOrganizerWidget.target = target.querySelector(".eventNewOrganizer");
  }

  @override
  void functionality() {
    ElementList removeButtons = target.querySelectorAll(".remove");
    ElementList editButtons = target.querySelectorAll(".edit");
    Element addAdmission = target.querySelector(".addAdmission");
    Element addOrganizer = target.querySelector(".addOrganizer");
    removeButtons.onClick.listen((MouseEvent e){
      int costFlagId = int.parse((e.currentTarget as Element).parent.id);
      ClientCost costToRemove = model.createEvent.event.costs.list.firstWhere((ClientCost cost) => cost.flag == costFlagId);
      costToRemove.removeFromParentList();
      repaintRequested = true;
    });

    editButtons.onClick.listen((MouseEvent e){
      if(_paymentEditing){
        _deactivateEditForCost((e.currentTarget as Element).parent);
      }else{
        _activateEditForCost((e.currentTarget as Element).parent);
      }
    });

    addAdmission.onClick.listen((_){
      children.add(costsWidget);
    });

    addOrganizer.onClick.listen((_){
      children.add(addOrganizerWidget);
    });
  }

  void _activateEditForCost(Element costDetail){
    _paymentEditing = true;
    int costFlagId = int.parse(costDetail.id);
    ClientCost cost = model.createEvent.costs.list.firstWhere((ClientCost cost) => cost.flag == costFlagId);
    _showSaveButton(costDetail.querySelector(".edit"));

    Element description = costDetail.querySelector(".eventAdmissionDescription");
    InputElement input = new InputElement()..value = cost.description;
    description.setInnerHtml("");
    description.append(input);

    Element flag = costDetail.querySelector(".eventCostFlagCont");
    SelectElement select = new SelectElement();
    OptionElement flagOption1 = new OptionElement()
      ..value = "BASIC"
      ..text = "BASIC"
      ..selected = cost.flag == "BASIC";
    OptionElement flagOption2 = new OptionElement()
      ..value = "STUDENT"
      ..text = "STUDENT"
      ..selected = cost.flag == "STUDENT";
    select.add(flagOption1, null);
    select.add(flagOption2, null);
    flag.setInnerHtml("");
    flag.append(select);

  }

  void _deactivateEditForCost(Element costDetail){
    _paymentEditing = false;
    int costFlagId = int.parse(costDetail.id);
    ClientCost cost = model.createEvent.costs.list.firstWhere((ClientCost cost) => cost.flag == costFlagId);
    _showChangeButton(costDetail.querySelector(".edit"));

    Element description = costDetail.querySelector(".eventAdmissionDescription");
    InputElement input = description.querySelector("input");
    cost.description = input.value;

//    TODO: implement function for getting int id from string flag
//    Element mapFlagEl = costDetail.querySelector(".eventCostFlagCont");
//    SelectElement select = mapFlagEl.querySelector("select");
//    String flag = select.selectedOptions.first.value;
    cost.flag = 1;
    repaintRequested = true;
  }

  void _showChangeButton(ButtonElement editButton){
    editButton.setInnerHtml(lang.manageEvent.paymentsAndOrganizersLangs.eventCostEditButton);
    editButton.classes.remove("active");
  }

  void _showSaveButton(ButtonElement editButton){
    editButton.setInnerHtml(lang.manageEvent.paymentsAndOrganizersLangs.eventCostSaveButton);
    editButton.classes.add("active");
  }

}
