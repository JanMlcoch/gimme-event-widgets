part of tag_filter.test;

class Widgetoid {
  Element target;
  Widgetoid parent;
  List<Widgetoid> children;
  List<String> preTemplate;
  String template;
  String targetSelector;

  Widgetoid(this.targetSelector);

  void fillTemplate(List<String> strings) {
    String soonToBeTemplate = "";
    List<String> localPreTemplate = preTemplate.toList();
    while (strings.length < preTemplate.length) {
      strings.add("");
    }
    while (strings.length > preTemplate.length) {
      localPreTemplate.add("");
    }
    for(int i =0;i<localPreTemplate.length;i++){
      soonToBeTemplate = soonToBeTemplate+localPreTemplate[i]+strings[i];
    }
    template = soonToBeTemplate;
  }

  void render() {
    setEigenTarget();
    target.setInnerHtml(template);
    children.forEach((Widgetoid child) {
      child.render();
    });
    setFunctionality();
  }

  void setEigenTarget() {
    target = querySelector(targetSelector);
  }

  void setFunctionality(){}

  void destroy(){
    if(parent!=null){
      parent.children.remove(this);
    }
  }

  void addChild(Widgetoid child){
    children.add(child);
    child.parent = this;
  }
}
