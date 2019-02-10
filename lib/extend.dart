library extend;

void extend(Map to, Map from) {
  Function mapExtends;
  Function listExtends;
  mapExtends = (Map to, Map from) {
    if (from == null || !(from is Map)) {
      return;
    }
    from.forEach((String key, dynamic value) {
      if (to.containsKey(key)) {
        dynamic item = to[key];
        if (item == null) {
          to[key] = value;
        } else if (item is Map) {
          if (value is Map) {
            mapExtends(to[key], from[key]);
          } else if (value is List) {
            to[key] = new List.from(value);
          } else {
            to[key] = value;
          }
        } else if (item is List) {
          if (value is List) {
            listExtends(to[key], from[key]);
          } else if (value is Map) {
            Map newTarget = {};
            extend(newTarget, value);
            to[key] = newTarget;
          } else {
            to[key] = value;
          }
        } else {
          to[key] = value;
        }
      } else {
        to.putIfAbsent(key, () => value);
      }
    });
  };
  listExtends = (List to, List from) {
    if (from == null || !(from is List)) {
      return;
    }
    for (int i = 0; i < from.length; i++) {
      dynamic value = from[i];
      if (i < to.length) {
        dynamic item = to[i];
        if (item == null) {
          to[i] = value;
        } else if (item is Map) {
          if (value is Map) {
            mapExtends(to[i], from[i]);
          } else if (value is List) {
            to[i] = new List.from(value);
          } else {
            to[i] = value;
          }
        } else if (item is List) {
          if (value is List) {
            listExtends(to[i], from[i]);
          } else if (value is Map) {
            Map newTarget = {};
            extend(newTarget, value);
            to[i] = newTarget;
          } else {
            to[i] = value;
          }
        } else {
          to[i] = value;
        }
      }
    }
  };
  mapExtends(to, from);
}
