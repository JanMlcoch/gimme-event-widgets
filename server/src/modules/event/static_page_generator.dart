part of eventModule;
class EncodeCSRNG {
  String alphaNumericalCode = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
      "abcdefghijklmnopqrstuvwxyz" + "0123456789";
  int length;
  int intInput;
  int range;
  StringBuffer buffer= new StringBuffer();
  EncodeCSRNG.fromInt(this.length,[ this.intInput]);
  String getToken() {
    //todo program to take in account input (is it even needed? )
    for (int i = 0; i < length; i++) {
      buffer.write(alphaNumericalCode[randSecure(0, alphaNumericalCode.length - 1)]);
    }
    String token=buffer.toString();
    return token;
  }
  int randSecure(int min, int max) {
    final number = new math.Random.secure();
    int randNumber = min + number.nextInt(max - min);
    return randNumber;
  }
}
void createEventFile(Event event){
  Map createData = event.toEventDetailMap();
  String projectDir = getProjectDirectoryName();
  EncodeCSRNG encode = new EncodeCSRNG.fromInt(20,createData["id"]);
  String uniquePageID= encode.getToken();
  ResourcesProvider resources;
  resources = ResourcesProvider.instance;
  try{
    Template template = parse(resources.resources.templates.leftSidebar.eventDetail);
    io.File eventPage = new io.File("$projectDir/web/event_pages/$uniquePageID.html")..createSync(recursive: true);
    StringSink sink = eventPage.openWrite();
    template.render(createData,sink);
  }catch(e){
    log.Logger.root.fine("error in render static generated site");
  }
}