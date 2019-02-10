part of model;

class Tags extends ModelList<Tag> {
  String type = "tags";
//  void replaceSynonyms() {
//    _fillLabeledTags();
//    Map<int, ServerTag> synonymKeyToBeReplacedWith = {};
//
//    for (int i = 0; i < labeledTags.length; i++) {
//      if (model.synonymProvider.isSynonymById(labeledTags[i].id)) {
//        synonymKeyToBeReplacedWith[i] = model.tags.getById(model.synonymProvider.getTargetId(labeledTags[i].id));
//      }
//    }
//
//    synonymKeyToBeReplacedWith.forEach((int key, ServerTag synonymTarget) {
//      String previousName = labeledTags[key].name;
//      labeledTags[key] = new LabeledServerTag.fromServerTag(synonymTarget, previousName + "-->");
//    });
//  }

  Tag getTagByName(String name) {
    return list.firstWhere((Tag tag) => tag.name == name, orElse: () => null);
  }

  List<Map<String, dynamic>> toListList() => list.map((Tag tag) => tag.toListMap()).toList();

  @override
  Tags copyType() => new Tags();

  @override
  Tag entityFactory() => new Tag();
}
