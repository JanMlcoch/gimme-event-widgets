part of view;

class FooterWidget extends Widget {
  FooterWidget(){
    template = parse(resources.templates.footer);
  }

  @override
  void destroy(){
    // do nothing
  }

  @override
  Map out(){
    return {};
  }

  @override
  void setChildrenTargets(){

  }

  @override
  void functionality(){

  }
}
