part of eventModule;

void _bindEventImageConverter() {
  libs.route(
      CONTROLLER_FILTER_EVENTS_BASE64_IMAGES, () => new ConvertImageRC(),
      method: "POST",
      allowAnonymous: true,
      template: {
        "eventId": "int"
      },
      permission: Permissions.SHOW_EVENT);
}

class ConvertImageRC extends libs.RequestContext {

  @override
  Future<dynamic> execute() async {
    //parsing from request body
    int eventId = data["eventId"];
    Map<String, String> out = {};
    try {
      io.File imageFile = new io.File("${io.Directory.current.path}\\web\\app\\images\\events_images\\event_avatar_$eventId.png");
      if(imageFile.existsSync()){
        String contentType = "image/png";
        Uint8List byteList = imageFile.readAsBytesSync();
        String header = "data:$contentType;base64,";
        String base64 = convert.BASE64.encode(byteList);
        out["source"] = "$header$base64";
        out["imageType"]="image";
      } else{
        throw new Error();
      }
    } catch (_) {
      out["source"] = BG_COLORS_XAML_COMPATIBLE[new math.Random().nextInt(
          BG_COLORS_XAML_COMPATIBLE.length)];
      out["imageType"]="color";
    }
    envelope.withMap(out);
  }
}
