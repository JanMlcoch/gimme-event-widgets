import 'dart:async';
import '../server/src/storage/library.dart';


Future main() async {
//  Tags tags = temporaryTagsLoader();
//  DataStorage storage = new DataStorage(null,
//  //          'postgres://akcnik.thilisar.cz:brMO4i5mblfVcm@sql3.pipni.cz:5432/akcnik.thilisar.cz';
////          'postgres://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_test';
//      'postgres://akcnik:sidos@akcnik.vserver.cz:5432/akcnik'
//  );
//  await storage.init();
  storage.connectHandler((Connection connection) {
  bool withEvents = false;
  if (withEvents) {
//    Events events = await connection.events.load(filter_lib.RootFilter.pass, ["id", "tags"], limit: -1);
//    List<Map> tagList = [];
//    for (Event event in events.list) {
//      for (String tagName in event.oldTags) {
//        Tag tag = tags.getTagByName(tagName);
//        if (tag == null) continue;
//        tagList.add(tag.toFullMap());
//      }
//      await connection.events.updateModel({"id":event.id, "tags":tagList}, ["tags"]);
//    }
  } else {
//    Users users = await connection.users.load(filter_lib.RootFilter.pass,["id","preferenceTags"],limit: -1);
//    for(User user in users.list){
//      for(String tagName in user.oldPreferenceTags){
//        Tag tag = tags.getTagByName(tagName);
//        if(tag==null) continue;
//        user.preferenceTags.add(tag);
//      }
//      await connection.users.updateModel(user,["preferenceTags"]);
//    }
  }
  });
}