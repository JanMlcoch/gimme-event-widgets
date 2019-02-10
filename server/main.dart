library server;

import "dart:async";

import '../server_libs/io_helper.dart';
import '../conf/conf.dart' as conf;
import '../server_libs/server/library.dart';
import "src/storage/library.dart";
import "src/modules/user/library.dart";
import "src/modules/event/library.dart";
import "src/modules/points_of_origin/library.dart";
import "src/modules/place/library.dart";
import "src/modules/organizer/library.dart";
import "src/modules/tag_controller/loader.dart";
import "src/modules/currency_provider/loader.dart";
import 'src/modules/role_manager/role_controller.dart';
import 'package:args/args.dart' as arg_lib;
import 'package:logging/logging.dart';

const String CONTROLLER_EXAMPLE = "/example";
const String CONTROLLER_LIVE = "/live";

Logger akcnikServerLogger = new Logger("akcnik.server");

Future main([List<String> args = const []]) async {
  arg_lib.ArgResults parseResults = parseServerRunnerArgs(args);
  int servicePort = int.parse(parseResults["service-port"], onError: (e)=>conf.Ports.serverServicePort);
  int port = int.parse(parseResults["port"]);
  // TODO: discuss
  if(port== conf.Ports.serverApiPort){
    if(await terminateMe(servicePort)){
      print("previous server terminated");
    }else{
      print("no server started before launch");
    }
    createTerminator(servicePort);
  }


//  await migrateDatabase(parseResults["database"]);
  initServerLogger();
  loadRouter();
  await loadDefaultStorage(parseResults["database"]);
  loadUsersModule();
  loadEventModule();
  loadPointsOfOriginModule();
  loadOrganizerModule();
  loadPlaceModule();
  loadTagControllerModule();
  loadCurrencyProviderModule();
  loadRoleManager();
  //loadEventControllerModule();
  route(CONTROLLER_EXAMPLE, () => new ExampleRequestContext());
  route(CONTROLLER_LIVE, () => new LiveRequestContext());

  serve(port);
}

class ExampleRequestContext extends RequestContext {
  @override
  Future execute() {
    envelope.success("ahoj");
    return null;
  }
}

class LiveRequestContext extends RequestContext {
  @override
  Future execute() {
    envelope.success("live");
    return null;
  }
}
