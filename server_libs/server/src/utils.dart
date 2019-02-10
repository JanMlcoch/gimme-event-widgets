part of server_common;

Future<String> readFile(String url) {
  File dataFile = new File(url);
  return dataFile.readAsString();
}

void saveFile(String url, Object data, {String suffix: null}) {
  String modUrl = url;
  if (suffix != null) {
    int dotPos = modUrl.lastIndexOf(".");
    if (dotPos >= 0) {
      modUrl = url.substring(0, dotPos) + suffix;
    }
  }
  File dataFile = new File(modUrl);
  dataFile.writeAsString(JSON.encode(data));
}
