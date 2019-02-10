part of akcnik.common;

abstract class CommonImprint {
  Map<int, double> weights = {};

  CommonImprint();

  double operator [](int tagId) {
    return weights[tagId];
  }

  void operator []=(int tagId, double weight) {
    weights[tagId] = weight;
  }

  Iterable<int> get keys => weights.keys;
  void fromIdMap(Map<int, num> idMap) {
    weights..clear();
    idMap.forEach((int key, num weight) {
      weights[key] = weight.toDouble();
    });
//    weights..clear()..addAll(idMap);
  }

  void fromMap(Map<String, dynamic> json) {
    json.forEach((String tagId, dynamic weight) {
      weights[int.parse(tagId)] = weight.toDouble();
    });
  }

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> out = {};
    weights.forEach((int tagId, double weight) {
      out[tagId.toString()] = weight;
    });
    return out;
  }
}
