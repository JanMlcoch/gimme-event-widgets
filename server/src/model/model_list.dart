part of model;

abstract class ModelList<T extends Jsonable> {
  List<T> _list = [];
  Map<int, T> _map = {};

  String get type;

  void add(T entity) {
    T previousEntity = _map[entity.id];
    if (previousEntity != null) {
      int pos = _list.indexOf(previousEntity);
      if(pos == -1) pos = _list.length;
      _list[pos] = entity;
      _map[entity.id] = entity;
    } else {
      _list.add(entity);
      _map[entity.id] = entity;
    }
  }

  ModelList<T> addAll(Iterable<T> list) {
    if (list == null) return this;
    _list = list.toList();
    _map = {};
    _list.forEach((T entity) {
      _map[entity.id] = entity;
    });
    return this;
  }

  int get length => _list.length;

  T get first => _list.length == 0 ? null : _list.first;

  bool get isEmpty => _list.isEmpty;

  List<T> get list => _list;

  ///Please use this only for entities with [int] attribute id, or a puppy will die.
  List<int> toIdList(){
    List<int> idList = [];
    for (T entity in _list) {
      idList.add(entity.id);
    }
    return idList.toList();
  }

  List<Map<String, dynamic>> toFullList() {
    List<Map<String, dynamic>> out = [];
    for (T entity in _list) {
      out.add(entity.toFullMap());
    }
    return out;
  }

  void fromList(List<Map<String, dynamic>> json) {
    json.forEach((Map<String, dynamic> entityJson) {
      add(entityFactory()..fromMap(entityJson));
    });
  }

  T getById(int id) {
    return _map[id];
  }

  T entityFactory();

  ModelList<T> copyType();

  int nextId() {
    int nextId = 1;
    _list.forEach((event) {
      if (event.id >= nextId) nextId = event.id + 1;
    });
    return nextId;
  }

  void clear() {
    _list = new List<T>();
    _map = new Map<int, T>();
  }
  dynamic remove(int id){
    if(_map[id]!=null){
      dynamic foundEntity = _map[id];
      _list.remove(_map.remove(id));
      return foundEntity;
    }
    return null;
  }
}

//abstract class ModelEntity {
//  int id;
//
//  Map<String, dynamic> toJson([int purpose=PURPOSE_EVENT_LIST]);
//
//  void fromJson(Map<String, dynamic> json);
//}
