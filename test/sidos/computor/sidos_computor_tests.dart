library akcnik.test.sidos.computor;

import 'package:test/test.dart';
import '../../../sidos/sidos_entities/library.dart';
import 'dart:async';
import '../../../sidos/computor/library.dart';

part 'cachor_tests.dart';
part 'evolutor_tests.dart';
part 'fittor_tests.dart';
part 'imprintificator_tests.dart';
part 'patternificator_tests.dart';

int timeoutInSeconds = 1;

void main() {
  group("Cachor tests", () {
    cachorTests();
  });
  group("Fittor tests", () {
    fittorTests();
  });
  group("Imprintificator tests", () {
    imprintificatorTests();
  });
  group("Patternificator tests", () {
    patternificatorTests();
  });
  group("Evolutor tests", () {
    evolutorTests();
  });
}

void copyMain(){
  main();
}





