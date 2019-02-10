part of sidos.computor;

///the [Imprintificator] class handles creating [Imprints] for events
///from original information, such as inputted tags, quantified tags etc.

class Imprintificator {
  static Imprintificator _instance;

  ///Gives tags significance by the order, in which they were inputted
  static const List<double> TAGS_WEIGHTS_BY_ORDER = const [10.0, 9.0, 8.0, 7.0, 5.0, 3.0, 2.0, 1.5];

  ///this should contain data from tagMaster
  Map<int, Imprint> links;

  ImprintPoint pseudoDeltaFunctionRelation = new ImprintPoint()..value = 1.0..probability = 1.0..valueVariance = 0.1..zeroVariance = 0.1;

  ///Returns read-only singleton instance of [Imprintificator]
  static Imprintificator get instance {
    if (_instance == null) {
      _instance = new Imprintificator();
      _instance.init();
    }
    return _instance;
  }

  ///initializes an instance of [Imprintificator]. Loads necessary data for its purposes.
  void init() {
    ImprintPoint link11 = new ImprintPoint()
      ..probability = 0.8
      ..zeroVariance = 0.1
      ..valueVariance = 0.1
      ..value = 1.0;
    ImprintPoint link12 = new ImprintPoint()
      ..probability = 0.3
      ..zeroVariance = 0.1
      ..valueVariance = 0.3
      ..value = 0.5;
    ImprintPoint link21 = new ImprintPoint()
      ..probability = 0.5
      ..zeroVariance = 0.1
      ..valueVariance = 0.2
      ..value = 0.4;
    ImprintPoint link22 = new ImprintPoint()
      ..probability = 0.9
      ..zeroVariance = 0.3
      ..valueVariance = 0.1
      ..value = 0.9;

    Imprint links1 = new Imprint()..points = {1: link11, 2: link12};//..place = new GPS.withValues(13.0,48.0);
    Imprint links2 = new Imprint()..points = {1: link21, 2: link22};//..place = new GPS.withValues(16.0,52.0);

    links = {1: links1, 2: links2};
  }

  ///this function handles only tags (in the meaning of [ImprintPoint]s.
  Imprint createImprint(List<int> tags, GPS place,{double baseCost: null, int visitLength: null}) {
    List<Imprint> correspondingLinks = [];
    for (int i = 0; i < tags.length; i++) {
//      print("tag being currently processed is ${tags[i]}");
//      print("Link being currently processed is ${links[tags[i]]}");
//      Imprint tagLinks =  new Imprint()..points = Cachor.instance.tagRelations[i];
//      correspondingLinks.add(tagLinks);
      //todo: replace zero with singleton delta function
      if (links[tags[i]] != null) {
        correspondingLinks.add(links[tags[i]]..points[tags[i]] = pseudoDeltaFunctionRelation);
      }
    }
//    print("Corresponding links are: $correspondingLinks");
    Imprint toReturn = Imprint.sum(correspondingLinks, weights: TAGS_WEIGHTS_BY_ORDER);
    toReturn.place = place;
    toReturn.baseCost = baseCost;
    toReturn.visitLength = visitLength;
    return toReturn;
  }
}
