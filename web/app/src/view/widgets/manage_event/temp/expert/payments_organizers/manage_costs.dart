part of view;

class ManageCostsWidget extends Widget{
  ClientCosts modelCosts;
  String currency;
//  ButtonInputElement addCost;
  StreamSubscription addButtonListener;

  ManageCostsWidget(this.modelCosts,[this.currency= null]){
    template = parse(resources.templates.addEvent.paymentsOrganizers.costs);
    if(currency==null){
      currency=model.user.currency;
    }
  }


  @override
  void destroy() {
    _unsubscribe();
    children.forEach((Widget w){w.destroy();});
  }

  @override
  Map out() {
    _setChildren();

    Map out = {};
    out["lang"] = lang.manageEvent.paymentsAndOrganizersLangs.toMap();
    out["childrenOrder"] = modelCosts.permutationToDisplayList;
    return out;
  }

  @override
  void setChildrenTargets() {
    //todo: upgrade to check children types
    for(int i=0;i<children.length;i++){
      children[i].target = target.querySelector(".appCostTarget_"+i.toString());
    }
  }

  @override
  void functionality() {
    _unsubscribe();
//    addCost = target.querySelector(".appAddCost");
//    addButtonListener = addCost.onClick.listen((Event e){
//      modelCosts.addCost(currency);
//      repaintRequested = true;
//    });
  }

  void _unsubscribe(){
    if(addButtonListener!=null){addButtonListener.cancel();}
  }

  void _setChildren(){
    List<Widget> childrenToDestroy = children.toList();
    children.clear();
    childrenToDestroy.forEach((Widget w){w.destroy();});
    for(int i=0;i<modelCosts.list.length;i++){
      children.add(new ManageCostWidget(modelCosts.list[i],this));
    }
  }
}