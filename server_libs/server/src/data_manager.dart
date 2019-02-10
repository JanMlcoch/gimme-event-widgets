part of server_common;

const String DATA_CONTEXT_KEY = "akcnik.data";

shelf.Middleware getDataChecker(Map<String, dynamic> template) {
  if (template != null) {
    _enhanceTemplate(template);
    String result = _validateTemplate(template);
    if (result != null) throw new ArgumentError(result);
  }
  return (shelf.Handler innerHandler) {
    return (shelf.Request request) async {
      Map<String, dynamic> data = {};
      if (request.method == "GET" && request.url.hasQuery) {
        data = request.url.queryParameters;
      }
      if (request.method == "POST") {
        String stringData = await request.readAsString();
        try {
          var json = JSON.decode(stringData);
          if (json is Map<String, dynamic>) {
            data = json;
          } else {
            String body = JSON.encode(new Envelope.error("Malformed JSON body", DATA_IMPROPER_STRUCTURE).toMap());
            return new shelf.Response(400, body: body);
          }
        } on FormatException {
          String body = JSON.encode(new Envelope.error("Malformed JSON body", DATA_IMPROPER_STRUCTURE).toMap());
          return new shelf.Response(400, body: body);
        }
      }
      if (template != null) {
        try {
          _checkItem(data, template, "rootData");
        } on ArgumentError catch (e) {
          return new shelf.Response(400,
              body: JSON.encode(new Envelope.error(e.message, DATA_IMPROPER_STRUCTURE).toMap()),
              headers: defaultHeaders);
        }
      }
      request = request.change(context: {DATA_CONTEXT_KEY: data});
      return innerHandler(request);
    };
  };
}

void _checkItem(dynamic value, dynamic template, String key) {
  if (template is String) {
    if (template.startsWith("?")) {
      if (value == null) return;
      template = template.substring(1);
    }
    if (value != null) {
      //return resOut("$key should be $template instead of null", false);
      switch (template) {
        case "num":
        case "number":
          if (value is num) return;
          break;
        case "integer":
        case "int":
          if (value is int) return;
          break;
        case "double":
          if (value is double) return;
          break;
        case "bool":
        case "boolean":
          if (value is bool) return;
          break;
        case "String":
        case "string":
          if (value is String) return;
          break;
        case "list":
        case "List":
          if (value is List) return;
          break;
        case "map":
        case "Map":
          if (value is Map) return;
          break;
        case "dynamic":
          return;
        default:
          throw new ArgumentError("\"$key\" have unknown class \"$template\"");
        //return resOut("$key have unknown class", false);
      }
    }
    throw new ArgumentError("\"$key\" should be $template instead of ${value.runtimeType}");
  }
  if (template is Map) {
    if (value is! Map) {
      throw new ArgumentError("\"$key\" should be Map instead of ${value.runtimeType}");
    }
    for (String childKey in template.keys) {
      if (childKey.startsWith("?")) {
        String realKey = childKey.substring(1);
        if (value.containsKey(realKey)) {
          _checkItem(value[realKey], template[childKey], realKey);
        }
      } else if (childKey.startsWith("!")) {
        String realKey = childKey.substring(1);
        if (value.containsKey(realKey)) {
          throw new ArgumentError("\"$realKey\" is forbidden as key of \"$key\"");
        }
      } else {
        if (!value.containsKey(childKey)) throw new ArgumentError("Missing \"$childKey\" parameter of \"$key\"");
        _checkItem(value[childKey], template[childKey], childKey);
      }
    }
    return;
  }
  if (template is List) {
    if (value is! List) {
      throw new ArgumentError("$key should be List instead of ${value.runtimeType}");
    }
    if (template.length == 0) return;
    for (int i = 0; i < value.length; i++) {
      _checkItem(value[i], template[0], "Item $i");
    }
    return;
  }
  if (template == null) {
    throw new ArgumentError("template at key $key should not be Null");
  }
  throw new ArgumentError("Unknown class in template at key $key");
  //return resOut("Unknown class in template at key $key", false);
}

String _validateTemplate(dynamic template) {
  if (template == null) {
    return "template should not be Null";
  } else if (template is String) {
    if (template.startsWith("?")) {
      template = template.substring(1);
    }
    switch (template) {
      case "number":
      case "num":
      case "integer":
      case "int":
      case "double":
      case "bool":
      case "boolean":
      case "String":
      case "string":
      case "list":
      case "List":
      case "map":
      case "filters":
      case "Map":
      case "dynamic":
        return null;
      default:
        return "$template is unknown class";
      //return resOut("$key have unknown class", false);
    }
  } else if (template is Map) {
    for (String childKey in template.keys) {
      if (childKey.startsWith("!")) {} else {
        String result = _validateTemplate(template[childKey]);
        if (result != null) return result;
      }
    }
  } else if (template is List) {
    if (template.length == 0) return null;
    String result = _validateTemplate(template.first);
    if (result != null) return result;
  }
  return null;
}

Map _enhanceTemplate(Map<String, dynamic> template) {
  if (template["filters"] == "filters") {
    template["filters"] = [
      {"name": "string", "data": []}
    ];
  } else if (template["?filters"] == "filters") {
    template["?filters"] = [
      {"name": "string", "data": []}
    ];
  }
  return template;
}
