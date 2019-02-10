library sortmeasure;

import 'dart:math';

int maximum = 100000000;

void main() {
  List<int> lengths = [
    100000,
    120000,
    150000,
    200000,
    300000,
    400000,
    500000,
    700000,
    1000000,
    1200000,
    1500000,
    2000000,
    3000000,
    4000000,
    5000000,
    7000000,
    10000000,
    12000000,
    15000000,
    20000000,
    30000000,
    40000000,
    50000000,
    70000000
  ];

  for (int length in lengths) {
    measure(length, 10);
  }
}

void measure(int n, int repetitions) {
  int sumTime = 0;
  int sumTime2 = 0;
  int count = 0;
  while (count < repetitions) {
    int time = singleMeasure(n);
    sumTime += time;
    sumTime2 += time * time;
    count++;
  }
  double average = sumTime / count;
  double variance = sumTime2 / count - average * average;
  double sigma = sqrt(count * variance / (count - 1));
  print("$n $average $sigma");
}

int singleMeasure(int n) {
  Random random = new Random(new DateTime.now().millisecondsSinceEpoch);
  List<double> testList = [];
  while (testList.length < n) {
    testList.add(random.nextDouble());
  }
  int startTime = new DateTime.now().millisecondsSinceEpoch;
  testList.sort((a, b) => a.compareTo(b));
  int endTime = new DateTime.now().millisecondsSinceEpoch;

  return endTime - startTime;
}
