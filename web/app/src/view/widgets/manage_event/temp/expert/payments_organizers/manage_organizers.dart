part of view;

class ManageOrganizersWidget extends Widget{
  bool _fire;
  String searchInputValue = "";
  InputElement searchInput;
  InputElement nameInput;
  InputElement identificationNumber;
  InputElement address;
  TextAreaElement description;
  TextAreaElement contact;
  Element useButton;
  Element createButton;
  Element confirmCreate;
  Element cancelCreate;
  Element createCont;
  Element listCont;
  Element searchCont;
  ElementList addButtons;
  StreamSubscription _keyUpStream;
  bool _createActive = false;
  bool focus = false;

  ManageOrganizersWidget(){
    template = parse(resources.templates.add_event.manage_organizers);
  }

  @override
  void destroy(){
    // TODO: implement destroy
  }

  @override
  Map out(){
    Map out = {};
    out["lang"] = lang.manageEvent.paymentsAndOrganizersLangs.toMap();;
    if(!model.createEvent.event.organizers.isEmpty){
      out["organizersInEvent"] = model.createEvent.event.getOrganizersViewJson()..forEach((p)=>p["descriptionLabel"]=lang.manageOrganizers.descriptionLabel);
      out["noOrganizer"] = false;
    }else{
      out["organizersInEvent"] = [];
      out["noOrganizer"] = true;
    }
    if(model.createEvent.filteredOrganizers != null){
      out["organizersSearchResult"] = model.createEvent.getFilteredOrganizersViewJson()..forEach((p)=>p["descriptionLabel"]=lang.manageOrganizers.descriptionLabel);
    }else{
      out["organizersSearchResult"] = [];
    }
    out["searchInputValue"] = searchInputValue;
    return out;
  }

  @override
  void setChildrenTargets(){
    // TODO: implement setChildrenTargets
  }

  @override
  void tideFunctionality(){
    searchInput = querySelector("#appOrganizerSearch");
    createCont = target.querySelector(".appCreateOrganizerCont");
    useButton = target.querySelector(".appUseOrganizer");
    createButton = target.querySelector(".appCreateOrganizer");
    nameInput = target.querySelector(".appOrganizerName");
    description = target.querySelector("#appOrganizerDescription");
    identificationNumber = target.querySelector(".appOrganizerIdentificationNumber");
    contact = target.querySelector("#appOrganizerContact");
    confirmCreate = target.querySelector(".appConfirmCreateOrganizer");
    cancelCreate = target.querySelector(".appCancelCreateOrganizer");
    listCont = target.querySelector(".appOrganizersInEvent");
    searchCont = target.querySelector(".appAddNewOrganizerInEvent");
    address = target.querySelector("#appOrganizerAddress");
    addButtons = target.querySelectorAll(".addOrganizerToEvent");

    searchInput.onKeyUp.listen(_keyUp);
    searchInput.focus();
    createButton.onClick.listen(_goToCreate);
    confirmCreate.onClick.listen(_confirmCreate);

    addButtons.onClick.listen((e){
      int id = int.parse((e.currentTarget as Element).parent.dataset["id"]);
      ClientOrganizer organizer = model.createEvent.getOrganizerById(id);
      model.createEvent.event.organizers.add(new ClientOrganizerInEvent()
        ..organizer=organizer..setEvent(model.createEvent.event));
      model.createEvent.filteredOrganizers.remove(organizer);
      requestRepaint();
    });
  }

  _confirmCreate([_]) async{
    ClientOrganizer organizer = new ClientOrganizer();
    organizer
    ..address = address.value
    ..contact = contact.value
    ..name = nameInput.value
    ..description = description.value
    ..identificationNumber = identificationNumber.value;

    if(organizer.name!=null && organizer.name!=""){
      await organizer.persist();
      ClientOrganizerInEvent organizerI = new ClientOrganizerInEvent();
      organizerI.organizer = organizer;
      organizerI.event = model.createEvent.event;
      model.createEvent.event.organizers.add(organizerI);
      repaintRequested = true;
      _createActive = false;
    }

    if(focus){
      searchInput.focus();
      focus = false;
    }
  }

  _keyUp(e){
    List<OrganizerBase> organizers = model.createEvent.filteredOrganizers;
    if(e.keyCode == KeyCode.ENTER){
      if(organizers == null){
        // fire means use first organizer immediately after load
        _fire = true;
        return;
      }
      if(organizers.isEmpty){
        _goToCreate();
      }else{
        _use(organizers.first);
      }
      return;
    }
    if(_keyUpStream != null){
      _keyUpStream.cancel();
    }
    _keyUpStream = new Future.delayed(const Duration(milliseconds: 500)).asStream()
        .listen((_)async {
      if(searchInput.value.length > 2 && !_createActive){
        model.createEvent.filteredOrganizers = await
        model.createEvent.getOrganizersBySubstring(searchInput.value);
        organizers = model.createEvent.filteredOrganizers;
        if(organizers.isEmpty){
          show(createButton);
          hide(useButton);
        }else if(organizers.length == 1){
          hide(createButton);
          show(useButton);
          searchInputValue = searchInput.value;
          focus = true;
          repaintRequested = true;
        }else{
          searchInputValue = searchInput.value;
          focus = true;
          repaintRequested = true;
        }
        if(_fire){
          if(organizers.isEmpty){
            _goToCreate();
          }else{
            _use(organizers.first);
          }
        }
      }
    });
  }

  bool _validate([_]){
    bool out = true;
    return out;
  }

  void _goToCreate([_]){
    show(createCont);
    hide(createButton);
    hide(searchCont);
    hide(listCont);
    nameInput.value = searchInput.value;
    nameInput.focus();
    _createActive = true;
  }

  void _use(PlacePlace){
    _createActive = false;
  }
}