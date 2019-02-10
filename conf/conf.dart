library conf;

const String RESOURCES_TARGET_FOLDER = "web/resources";
const String RESOURCES_TARGET_DART_FILE = "lib/resources.dart";
const String PATH_TO_RESOURCES_GENERATOR = "bin/resources_generator.dart";
const String PATH_TO_WEB = "web/app";
const String PATH_TO_COPY_TO_LIVE_SCRIPT = "bin/copy_to_live.dart";

class WebFolderRules {
  static List<String> notProductionFolders = [
    "packages", "src", "web_tests", "role_manager"];
}

class LinuxServerRules {
  static String pathToPub = "/usr/lib/dart/bin/pub";
  static String productionDirectory = "akcnik";
  static String gitDirectory = "git_akcnik";
}

class Ports{
  static int serverApiPort = 9999;
  static int loaderServicePort = 6854;
  static int serverServicePort = 6855;
  static int sidosApiPort = 4042;
  static int sidosServicePort = 6856;
}
