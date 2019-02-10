part of server_common;

abstract class RequestContext {
  static const String LOGGED_USER = "loggedUser";
  static const String ERROR = "error";
  final bool strictMode = true;
  // for future implementation of session timeout
  static const String LAST_ACTIVITY = "lastActivity";
  final bool needConnection = true;
  String method = "POST";
  shelf.Request request;
  StreamController _out;
  model.User user;
  Map<String, dynamic> data;
  AccessManager access;
  EnvelopeHolder envelope = new EnvelopeHolder();
  storage.Connection connection = storage.DataStorage.fakedConnection;

  Future process() async {
//    envelope = new Envelope();
    try {
      if (needConnection && storage.storage != null) {
        connection = await storage.storage.getConnection();
      }
      await onBeforeValidation();
      if (envelope.empty) await validate();
      if (envelope.empty) await execute();
    } on Error catch (e) {
      envelope.error(e.toString() + "\n" + e.stackTrace.toString(), INTERNAL_SERVER_ERROR);
      if (strictMode) rethrow;
    } catch (e) {
      envelope.error(e.toString(), INTERNAL_SERVER_ERROR);
      if (strictMode) rethrow;
    } finally {
      await afterExecute();
      _sendEnvelope();
      if (connection != null) {
        connection.close();
      }
    }
  }

  Future onBeforeValidation() => null;

  Future validate() => null;

  Future execute();

  Future afterExecute() => null;

  void _sendEnvelope() {
    if (envelope.empty) {
      envelope.envelope = new Envelope.timeout();
    }
    if (!envelope.envelope.isSuccess) {
      new log.Logger("akcnik.server.context").warning("""envelope error log:
      path: ${request.handlerPath}
      category: ${envelope.envelope.category}
      message: ${envelope.envelope.message}
      data: ${JSON.encode(data)}""");
    }
    if (!_out.isClosed) {
      _out.add(const Utf8Codec().encode(JSON.encode(envelope.envelope.toMap())));
      _out.close();
    }
  }

  common_filter.RootFilter constructFilter() {
    EnvelopeHolder message = new EnvelopeHolder();
    common_filter.RootFilter filter = new common_filter.RootFilter.construct(data["filters"], message);
    if (!message.empty) {
      envelope.error(message.envelope.message, BAD_FILTER_IN_FILTER_EVENTS);
      return null;
    }
    return filter;
  }

  Future transfer(ContextProvider provider) {
    RequestContext delegated = provider();
    delegated.data = data;
    delegated.user = user;
    delegated.method = method;
    delegated._out = _out;
    delegated.access = access;
    delegated.request = request;
    return delegated.process();
  }
}
