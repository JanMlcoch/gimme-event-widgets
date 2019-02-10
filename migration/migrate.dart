library akcnik.migrate;

import 'dart:io';
import '../server_libs/io_helper.dart';
import 'dart:async';
import 'package:postgresql/postgresql.dart' as pgsql;
import 'package:args/args.dart' as arg_lib;

const Map<String, String> databaseUrls = const {
  "test": 'postgres://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_test',
  "devel": 'postgres://akcnik:sidos@akcnik.vserver.cz:5432/akcnik',
  "production": 'postgres://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_production',
  "migration": 'postgresql://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_migration'
};

Future<bool> main(List<String> args) async {
  arg_lib.ArgResults parseResult = parseArgs(args);
  if (parseResult == null) return false;
  String database = parseResult["database"];
  bool productionData = parseResult["production_data"];
  bool force = parseResult["force"];
  bool verbose = parseResult["verbose"];
  String projectDir = getProjectDirectoryName();
  Directory migrationDir = new Directory("$projectDir/migration");
  RegExp pattern = new RegExp(r'\d[\ddt]+_\w+\.(sql|dart)');
//  RegExp pattern = new RegExp(r'\d[\ddt]+_\w+\.sql');
//  ResetSequences resetSequences = await new ResetSequences(new File("${migrationDir.path}/reset_sequences.sql")).init();
  List<FileCont> files = migrationDir
      .listSync()
      .where((FileSystemEntity file) => file is File && pattern.hasMatch(file.path))
      .map((FileSystemEntity file) => new FileCont(file))
      .toList();
  files.sort();
  //print(files);
  String uri = databaseUrls[database];
  if (uri == null) throw new ArgumentError("Wrong database name: $database");
//  uri = TEST_DATABASE_URI;
  pgsql.Connection connection = await pgsql.connect(uri, applicationName: "Migrate");
  if (connection.state != pgsql.ConnectionState.idle) {
    print(connection.state.toString());
    throw new StateError("Could not connect to database");
  }

  bool migrationStarted = false;
  String currentVersion;
  if (!force) {
    currentVersion = await connection.query("SELECT version FROM migrations").toList().then((List<pgsql.Row> rows) {
      return rows.first[0];
    });
  }
  if (currentVersion == null) migrationStarted = true;

  for (FileCont file in files) {
    if (productionData) {
      if (file.prefix[1] == "t") continue;
    } else {
      if (file.prefix[1] == "d") continue;
    }
    if (!migrationStarted) {
      if (file.prefix == currentVersion) migrationStarted = true;
      if (verbose) print("-- ${file.fileName}");
      continue;
    }
    String migrationQuery;
    if (file.fileName.endsWith(".dart")) {
      ProcessResult processResult = await Process.run("dart", [file.file.path, uri]);
      migrationQuery = processResult.stdout;
//      print(migrationQuery);
      if (processResult.stderr != "") {
        throw new StateError("Process ${file.prefix} failed: ${processResult.stderr}");
      }
    } else {
      migrationQuery = file.file.readAsStringSync();
    }
    await connection.execute(migrationQuery + ";UPDATE migrations SET \"version\"='${file.prefix}'");
    print("++ ${file.fileName}");
  }

  if (!migrationStarted) {
    throw new StateError("Unknown migration version saved in database");
  }
  connection.close();
  print("Database ${database.toUpperCase()} migrated" +
      (verbose ? " with${productionData ? "out" : ""} sample data${force ? " from scratch" : ""}" : ""));
  return true;
}

arg_lib.ArgResults parseArgs(List<String> args) {
  arg_lib.ArgParser parser = new arg_lib.ArgParser();
  parser.addOption("database",
      abbr: "d",
      allowed: ["test", "devel", "production", "migration"],
      defaultsTo: "devel",
      help: "Migrate selected database (default = devel database)");
  parser.addFlag("force", abbr: "f", defaultsTo: false, help: "Drop database and migrate from scratch");
  parser.addFlag("verbose", abbr: "v", defaultsTo: false);
  parser.addFlag("production_data",
      abbr: "p", defaultsTo: false, help: 'Load production data (with "d" in migration name)');
  parser.addFlag('help', abbr: 'h', negatable: false,
      help: "Displays this help information.");
  arg_lib.ArgResults results = parser.parse(args);
  if (results["help"]) {
    print(parser.usage);
    return null;
  }
  return results;
}

class FileCont extends Comparable<FileCont> {
  String prefix;
  String fileName;
  File file;

  FileCont(this.file) {
    String path = file.path;
    int start = path.lastIndexOf(new RegExp(r'[/\\]')) + 1;
    fileName = path.substring(start);
    prefix = path.substring(start, path.indexOf("_", start));
    if (prefix.length > 6) throw new ArgumentError('File prefix "$prefix" is longer than 6 letters');
  }

  int compareTo(FileCont other) => prefix.compareTo(other.prefix);
}

//class ResetSequences {
//  final File file;
//  String queryBuilderQuery;
//
//  ResetSequences(this.file);
//
//  Future<ResetSequences> init() {
//    return this.file.readAsString().then((String fileContent) {
//      queryBuilderQuery = fileContent;
//      return this;
//    });
//  }
//
//  Future<String> resetQuery(pgsql.Connection connection) async {
//    String query = "BEGIN TRANSACTION;\n";
//    List<pgsql.Row> rows = await connection.query(queryBuilderQuery).toList();
//    for (pgsql.Row row in rows) {
//      query += row[0] + "\n";
//    }
//    query += "COMMIT TRANSACTION;";
//    return query;
//  }
//}
