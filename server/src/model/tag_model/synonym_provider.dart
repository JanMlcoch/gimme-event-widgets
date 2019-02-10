part of model;

class SynonymProvider {
  Map<int, int> synonymousOrientedIdVectors = {};
  SynonymProvider();

  void init(List<Map> dbTags) {
    for (Map tag in dbTags) {
      if (tag["type"] == 1) {
        int target;
        tag["relas"].forEach((String k, _) {
          target = int.parse(k);
        });
        synonymousOrientedIdVectors[tag["id"]] = target;
      }
    }
  }

  int getTargetId(int id) {
    ///returns id of target of synonym of imputted id
    return synonymousOrientedIdVectors[id];
  }

//  bool isSynonymById(int id) {
//    if (model.tags.getById(id).type == 1) {
//      return true;
//    } else {
//      return false;
//    }
//  }
  //TODO: more features
}
