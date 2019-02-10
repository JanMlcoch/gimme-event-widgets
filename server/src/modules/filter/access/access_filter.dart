part of filter_module.access;

abstract class _AccessFilterBase<T extends Jsonable> extends FilterBase<T> {
  int userId;
  User user;
  final String filterType;

  _AccessFilterBase(String filterName, String filterType, dynamic data)
      :filterType = filterType,
        super(filterName, null, null) {
    if (data is User) {
      user = data;
      userId = user.id;
    } else if (data is int) {
      userId = data;
    } else {
      invalid = true;
      invalidMessage = "data $data should be User or int";
    }
  }

  void fromList(List<dynamic> jsonArray) {}
}
