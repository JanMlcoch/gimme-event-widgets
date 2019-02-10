part of tag_controller;
//TODO: generalize for more than two words tag names

Tags executeAutocompleteRequest(Map data) {
  ///executes request related to tag autocompletetion
  String substring = data["substring"];
  Tags tags = new Tags();
  for (Tag tag in TagFilterFeatures.filterAndSortBySubstring(substring)) {
    tags.add(tag);
  }
  return tags;
}
