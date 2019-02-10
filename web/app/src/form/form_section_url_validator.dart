part of form;

class FormSectionUrlValidator extends FormSectionValidator {
  RegExp regexp;

  FormSectionUrlValidator({String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp) {
    regexp = getUrlRegExp();
  }

  FormSectionUrlValidator.facebook({String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp) {
    regexp = getFbExp();
  }

  @override
  bool checkValidity() {
    if(inputValue == ""){
      return true;
    }
    return regexp.hasMatch(inputValue);
  }

  RegExp getUrlRegExp(){
    String a = r"^" +
        // protocol identifier
        "(?:(?:https?|ftp)://)?" +
        // user:pass authentication
        "(?:\\S+(?::\\S*)?@)?" +
        "(?:" +
        // IP address exclusion
        // private & local networks
        "(?!(?:10|127)(?:\\.\\d{1,3}){3})" +
        "(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})" +
        "(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})" +
        // IP address dotted notation octets
        // excludes loopback network 0.0.0.0
        // excludes reserved space >= 224.0.0.0
        // excludes network & broacast addresses
        // (first & last IP address of each class)
        "(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])" +
        "(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}" +
        "(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))" +
        "|" +
        // host name
        "(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)" +
        // domain name
        "(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*" +
        // TLD identifier
        "(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))" +
        // TLD may end with dot
        "\\.?" +
        ")" +
        // port number
        "(?::\\d{2,5})?" +
        // resource path
        "(?:[/?#]\\S*)?" +
        "\$";

    return new RegExp(a);
  }

  RegExp getFbExp(){
    String a = r"^" +
        "(https?://)?(www\.)?((facebook)" +
        "|" +
        "(fb))"
            "\.com" +
        // TLD identifier
        "(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))?" +
        // TLD may end with dot
        "\\.?";
    return new RegExp(a);
  }
}



class FormSectionUrlValidatorOld extends FormSectionValidator {
  bool isFbUrl;

  String protocol, user, pass, auth, host, hostname, portStr, path, query, hash;
  int port;
  List<String> split;

  FormSectionUrlValidatorOld(this.isFbUrl, {String validityMessage})
      :super(validityMessage: validityMessage);

  @override
  bool checkValidity() {
    if(inputValue == ""){
      return true;
    }
    return (isFbUrl ? _isFbUrl() : _isUrl());
  }

  bool _isUrl() {
    String str = inputValue;
    if (str.length > 2083 || str.indexOf('mailto:') == 0) {
      return false;
    }

    Map options = {
      'protocols': [ 'http', 'https', 'ftp'],
      'require_tld': true,
      'require_protocol': false,
      'allow_underscores': false
    };

    // check protocol
    split = str.split('://');
    if (split.length > 1) {
      protocol = _shift(split);
      if (options['protocols'].indexOf(protocol) == -1) {
        return false;
      }
    } else if (options['require_protocols'] == true) {
      return false;
    }
    str = split.join('://');

    // check hash
    split = str.split('#');
    str = _shift(split);
    hash = split.join('#');
    if (hash != null && hash != "" && new RegExp(r'\s').hasMatch(hash)) {
      return false;
    }

    // check query params
    split = str.split('?');
    str = _shift(split);
    query = split.join('?');
    if (query != null && query != "" && new RegExp(r'\s').hasMatch(query)) {
      return false;
    }

    // check path
    split = str.split('/');
    str = _shift(split);
    path = split.join('/');
    if (path != null && path != "" && new RegExp(r'\s').hasMatch(path)) {
      return false;
    }

    // check auth type urls
    split = str.split('@');
    if (split.length > 1) {
      auth = _shift(split);
      if (auth.indexOf(':') >= 0) {
        List<String> authList = auth.split(':');
        user = _shift(authList);
        if (!new RegExp(r'^\S+$').hasMatch(user)) {
          return false;
        }
        pass = authList.join(':');
        if (!new RegExp(r'^\S*$').hasMatch(user)) {
          return false;
        }
      }
    }

    // check hostname
    hostname = split.join('@');
    split = hostname.split(':');
    host = _shift(split);
    if (split.length > 0) {
      portStr = split.join(':');
      try {
        port = int.parse(portStr, radix: 10);
      } catch (e) {
        return false;
      }
      if (!new RegExp(r'^[0-9]+$').hasMatch(portStr) || port <= 0 ||
          port > 65535) {
        return false;
      }
    }

    if (!isFQDN(host, options) && host != 'localhost') {
      return false;
    }

    if (options['host_whitelist'] == true &&
        options['host_whitelist'].indexOf(host) == -1) {
      return false;
    }

    if (options['host_blacklist'] == true &&
        options['host_blacklist'].indexOf(host) != -1) {
      return false;
    }
    return true;
  }

  String _shift(List<String> l) {
    if (l.length >= 1) {
      String first = l.first;
      l.removeAt(0);
      return first;
    }
    return null;
  }

  Map _merge(Map obj, defaults) {
    if (obj == null) {
      obj = new Map();
    }
    defaults.forEach((key, val) => obj.putIfAbsent(key, () => val));
    return obj;
  }

  bool isFQDN(str, [options]) {
    Map defaultFqdnOptions = {
      'require_tld': true,
      'allow_underscores': false
    };

    options = _merge(options, defaultFqdnOptions);
    List parts = str.split('.');
    if (options['require_tld']) {
      var tld = parts.removeLast();
      if (parts.length == 0 || !new RegExp(r'^[a-z]{2,}$').hasMatch(tld)) {
        return false;
      }
    }

    for (var part, i = 0; i < parts.length; i++) {
      part = parts[i];
      if (options['allow_underscores']) {
        if (part.indexOf('__') >= 0) {
          return false;
        }
      }
      if (!new RegExp(r'^[a-z\\u00a1-\\uffff0-9-]+$').hasMatch(part)) {
        return false;
      }
      if (part[0] == '-' || part[part.length - 1] == '-' ||
          part.indexOf('---') >= 0) {
        return false;
      }
    }
    return true;
  }

  bool _isFbUrl() {
    if (inputValue == "") {
      return true;
    }
    if (_isUrl() && (
        inputValue.startsWith("https://www.facebook") ||
            inputValue.startsWith("www.facebook") ||
            inputValue.startsWith("fb.com") ||
            inputValue.startsWith("facebook") ||
            inputValue.startsWith("http://www.facebook") ||
            inputValue.startsWith("http://facebook") ||
            inputValue.startsWith("https://facebook"))) {
      return true;
    }
    return false;
  }
}