part of sorter_module;

typedef int Comparator(dynamic entity1, dynamic entity2);

abstract class SorterBase {
  bool _ascending = true;
  Comparator _comparator;

  List sort(List list) {
    list.sort(_comparator);
    if (!_ascending) {
      return list.reversed.toList();
    }
    return list;
  }
}
