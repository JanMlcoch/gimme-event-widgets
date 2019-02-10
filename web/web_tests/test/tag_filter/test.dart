part of tag_filter.test;


int testsStarted = 0;
final int numberOfTests = 8;

void tests() {
  test1();
  print("Test " +
      testsStarted.toString() +
      "/" +
      numberOfTests.toString() +
      " has passed.");
  test2();
  print("Test " +
      testsStarted.toString() +
      "/" +
      numberOfTests.toString() +
      " has passed.");
  test3();
  print("Test " +
      testsStarted.toString() +
      "/" +
      numberOfTests.toString() +
      " has passed.");
  test4();
  print("Test " +
      testsStarted.toString() +
      "/" +
      numberOfTests.toString() +
      " has passed.");
  test5();
  print("Test " +
      testsStarted.toString() +
      "/" +
      numberOfTests.toString() +
      " has passed.");
  test6();
  print("Test " +
      testsStarted.toString() +
      "/" +
      numberOfTests.toString() +
      " has passed.");
  test7();
  print("Test " +
      testsStarted.toString() +
      "/" +
      numberOfTests.toString() +
      " has passed.");
  test8();
  print("Test " +
      testsStarted.toString() +
      "/" +
      numberOfTests.toString() +
      " has passed.");
}

void test1() {
  testsStarted++;
  List<String> names = [];
  String substring = "";
  getOptions(serializeNames(names),substring,"").then((Object response){
    print(response);
  });
}
void test2() {
  testsStarted++;
  List<String> names = [];
  String substring = "v";
  getOptions(serializeNames(names),substring,"").then((Object response){
    print(response);
  });
}
void test3() {
  testsStarted++;
  List<String> names = [];
  String substring = "ní";
  getOptions(serializeNames(names),substring,"").then((Object response){     print(response);   });
}
void test4() {
  testsStarted++;
  List<String> names = [];
  String substring = "vbiudzfsž";
  getOptions(serializeNames(names),substring,"").then((Object response){     print(response);   });
}
void test5() {
  testsStarted++;
  List<String> names = ["Pivo", "Hospoda", "Alkohol"];
  String substring = "";
  getOptions(serializeNames(names),substring,"").then((Object response){     print(response);   });
}
void test6() {
  testsStarted++;
  List<String> names = ["Pivo", "Hospoda", "Alkohol"];
  String substring = "v";
  getOptions(serializeNames(names),substring,"").then((Object response){     print(response);   });
}
void test7() {
  testsStarted++;
  List<String> names = ["Pivo", "Hospoda", "Alkohol"];
  String substring = "ní";
  getOptions(serializeNames(names),substring,"").then((Object response){     print(response);   });
}
void test8() {
  testsStarted++;
  List<String> names = ["Pivo", "Hospoda", "Alkohol"];
  String substring = "sdfergžuýz";
  getOptions(serializeNames(names),substring,"").then((Object response){     print(response);   });
}
