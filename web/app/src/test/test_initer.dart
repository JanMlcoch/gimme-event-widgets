library akcnik.web.test;

import 'dart:async';
import 'basic/basic_test.dart' as basic;
import 'create_event_form/create_event_test.dart' as create_event;
import 'test_helpers.dart';
import '../model/root.dart';
import 'package:matcher/matcher.dart';
import 'dart:html' as html;

part 'user/login.dart';

part 'user/registration.dart';

part 'user/other.dart';

Future main() async {
  basic.main();
  create_event.main();
  loginTest();
  registrationTest();
  userOtherTest();
}

//  io.Directory current = new io.Directory("./");
//  List<io.FileSystemEntity> subDirs = current.listSync();
//  for(io.FileSystemEntity dir in subDirs){
//    if(dir is! io.Directory) continue;
//    List<io.FileSystemEntity> tests = (dir as io.Directory).listSync();
//    for(io.FileSystemEntity file in tests){
//      if(file is! io.File) continue;
//      if(!file.path.endsWith("_test")) continue;
//
//    }
//  }
