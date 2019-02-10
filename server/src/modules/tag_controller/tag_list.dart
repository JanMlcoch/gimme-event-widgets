part of tag_controller;

class TagList {
  List<ServerTag> tags = [];
  List<LabeledServerTag> labeledTags = [];
  List<List<String>> options = [];

  TagList();

  void createOptions() {
    options = [];
    for (LabeledServerTag tag in labeledTags) {
      options.add([tag.name, tag.label]);
    }
  }

  void _fillLabeledTags() {
    labeledTags.clear();
    for (int i = 0; i < tags.length; i++) {
      labeledTags.add(new LabeledServerTag.fromServerTag(tags[i], ""));
    }
  }

  void replaceSynonyms() {
    _fillLabeledTags();
    Map<int, ServerTag> synonymKeyToBeReplacedWith = {};

    for (int i = 0; i < labeledTags.length; i++) {
      if (model.synonymProvider.isSynonymById(labeledTags[i].id)) {
        synonymKeyToBeReplacedWith[i] = model.tags.getById(model.synonymProvider.getTargetId(labeledTags[i].id));
      }
    }

    synonymKeyToBeReplacedWith.forEach((int key, ServerTag synonymTarget) {
      String previousName = labeledTags[key].name;
      labeledTags[key] = new LabeledServerTag.fromServerTag(synonymTarget, previousName + "-->");
    });
  }

  void removeDuplicitousTags() {
    List<int> keysToRemove = [];

    for (int i = 1; i < labeledTags.length; i++) {
      for (int j = 0; j < i; j++) {
        if (labeledTags[i].id == labeledTags[j].id) {
          keysToRemove.add(i);
          break;
        }
      }
    }
    for (int key in keysToRemove.reversed) {
      labeledTags.removeAt(key);
    }
  }

  void removeLabeledTags(List<ServerTag> tagsToRemove) {
    List<LabeledServerTag> actualTagsToBeRemoved = [];
    for (ServerTag tag in tagsToRemove) {
      for (LabeledServerTag tagInTags in labeledTags) {
        if (tagInTags.id == tag.id) {
          actualTagsToBeRemoved.add(tagInTags);
        }
      }
    }
    for (LabeledServerTag tagToRemove in actualTagsToBeRemoved) {
      labeledTags.remove(tagToRemove);
    }
  }
}
