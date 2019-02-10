part of constants;

abstract class Permissions {
  static const String CREATE_EVENT = "create-event";
  static const String SHOW_EVENT = "show-event";
  static const String EDIT_EVENT = "edit-event";
  static const String DELETE_EVENT = "delete-event";
  static const String COMMENT_EVENT = "comment-event";

  static const String CREATE_PLACE = "create-place";
  static const String EDIT_PLACE = "edit-place";
  static const String REQUEST_MERGE_PLACE = "request-merge-place";
  static const String MERGE_PLACE = "merge-place";
  static const String DELETE_PLACE = "delete-place";

  static const String CREATE_ORGANIZER = "create-organizer";
  static const String EDIT_ORGANIZER = "edit-organizer";
  static const String DELETE_ORGANIZER = "delete-organizer";

  static const String EDIT_PERMISSIONS_IN_ROLE = "edit-permission";

  static const String CREATE_USER = "create-user";
  static const String SHOW_USER = "show-user";
  static const String EDIT_USER = "edit-user";
  static const String EDIT_USER_PERMISSIONS = "edit-userPermission";
}
