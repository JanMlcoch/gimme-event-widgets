part of flags;

abstract class CostFlags {
  static const int BASIC = 1;
  static const int STUDENT = 2;
  static const int INFANT = 3;
  static const int SENIOR = 4;
  static const int HANDICAPPED = 5;
  static const int GROUP = 6;
  static const int UPGRADED = 7;
  static const int PRE_ORDER = 8;
  static const int LAST_MINUTE = 9;
  static const int LIMITED_OFFER = 10;
  static const int OTHER = 11;

  ///other is last (please do not change this)
  static const List<int> EVENT_FLAGS_VALUES = const [
    BASIC,
    STUDENT,
    INFANT,
    SENIOR,
    HANDICAPPED,
    GROUP,
    UPGRADED,
    PRE_ORDER,
    LAST_MINUTE,
    LIMITED_OFFER,
    OTHER
  ];
  static const List<String> EVENT_FLAGS_NAMES_EN = const [
    "BASIC",
    "STUDENT",
    "INFANT",
    "SENIOR",
    "HANDICAPPED",
    "GROUP",
    "UPGRADED",
    "PRE_ORDER",
    "LAST_MINUTE",
    "LIMITED_OFFER",
    "OTHER"
  ];

  ///default flag priorities for representative Price
  static const List<int> flagPriorityList = const [
    CostFlags.BASIC,
    CostFlags.PRE_ORDER,
    CostFlags.LIMITED_OFFER,
    CostFlags.OTHER,
    CostFlags.UPGRADED,
    CostFlags.LAST_MINUTE,
    CostFlags.GROUP
  ];

  static const List<String> currencyPriorityList = const ["EUR", "CZK", "USD", "CAD"];
}
