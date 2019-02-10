part of filter_module.entity;


abstract class OrganizerFilter extends FilterBase<Organizer> {
  final String filterType = TABLE_ORGANIZERS;

  OrganizerFilter(String filterName, List<String> validateTemplate, List data)
      : super(filterName, validateTemplate, data);
}
//##############################################################################
class SubNameOrganizerFilter extends OrganizerFilter {
  String _subName;

  SubNameOrganizerFilter(List data) : super("organizer_subname", const ["string"], data);

  void fromList(List<dynamic> jsonArray) {
    _subName = jsonArray.first;
  }

  String get sqlConstraint => "$filterType.\"name\" LIKE ${safeConvert("%$_subName%")}";

  bool match(Organizer organizer) => organizer.name.contains(_subName);
}

//##############################################################################
