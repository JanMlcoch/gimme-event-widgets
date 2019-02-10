part of tag_controller;

//gets tags from model
class TagFilterFeatures {
  static List<Tag> filterAndSortBySubstring(String substring) {
    ///provides filtering by substring (with conotation to autocomplete tag)
    Tags tags = storage_lib.storage.memory.model.tags;

    List<Tag> contains = [];
    List<Tag> out = [];

    substring = substring.toLowerCase();

    for (Tag tag in tags.list) {
      if (tag.lowerCaseName.startsWith(substring)) {
        out.add(tag);
      } else if (tag.lowerCaseName.contains(substring)) {
        contains.add(tag);
      }
    }
    out..addAll(contains);
    if (out.length > 10) {
      out = out.sublist(0, 10);
    }
    return out;
  }
}
