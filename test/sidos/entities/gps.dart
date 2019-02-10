part of akcnik.tests.sidos.task_completer;

void gpsTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  GPS prague = new GPS.withValues(50.0797, 14.4826);
  GPS pardubitz = new GPS.withValues(50.0282, 14.7663);
  GPS budweis = new GPS.withValues(48.9727, 14.4943);
  GPS jungbunzlau = new GPS.withValues(50.4279, 14.9168);
  GPS nyAlesund = new GPS.withValues(78.9235, 11.9170);
  GPS upernavik = new GPS.withValues(72.7858, -56.1366);
  GPS longyearbyen = new GPS.withValues(78.2246, 11.6347);
  GPS mogadishu = new GPS.withValues(2.0414, 45.3201);
  GPS nairobi = new GPS.withValues(-1.2908, 36.8320);
  GPS adele = new GPS.withValues(2.7644, 46.3226);
  GPS ulaanbaatar = new GPS.withValues(47.9188, 106.9174);
  double R = 6378.1; //in KM
  const double TOLERANCE_RATIO = 0.05;
  const double TOLERANCE_COMMUTATION_RATIO = 0.00001;
  double praguePardubitzKM = 21.05;
  double pragueBudweisKM = 123.1;
  double pragueJungbunzlauKM = 49.52;
  double pragueNyAlesundKM = 3209.0;
  double pragueUpernavikKm = 4146.0;
  double pragueMogadishuKM = 6082.0;
  double pragueUlaanbaatarKM = 6291.0;
  double nairobiMogadishuKM = 1014.0;
  double adeleMogadishuKM = 137.4;
  double nyAlesundLongyearbyenKM = 77.96;

  double praguePardubitz = praguePardubitzKM / R;
  double pragueBudweis = pragueBudweisKM / R;
  double pragueJungbunzlau = pragueJungbunzlauKM / R;
  double pragueNyAlesund = pragueNyAlesundKM / R;
  double pragueUpernavik = pragueUpernavikKm / R;
  double pragueMogadishu = pragueMogadishuKM / R;
  double pragueUlaanbaatar = pragueUlaanbaatarKM / R;
  double nairobiMogadishu = nairobiMogadishuKM / R;
  double adeleMogadishu = adeleMogadishuKM / R;
  double nyAlesundLongyearbyen = nyAlesundLongyearbyenKM / R;

  test("Test of to/from map consistency", () {
    GPS gps = new GPS.withValues(15.54512, 51.51234);
    GPS newGPS = new GPS.fromJsonMap(gps.toFullMap());
    expect(gps.latitude == newGPS.latitude && gps.longitude == newGPS.longitude, equals(true));
  });

  test("Test of local distance - parallels", () {
    double distance = GPS.distance(prague, pardubitz);
    double correctDistance = praguePardubitz;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of local distance - meridians", () {
    double distance = GPS.distance(prague, budweis);
    double correctDistance = pragueBudweis;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of local distance - diagonal", () {
    double distance = GPS.distance(prague, jungbunzlau);
    double correctDistance = pragueJungbunzlau;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of local distance - equatorial", () {
    double distance = GPS.distance(mogadishu, adele);
    double correctDistance = adeleMogadishu;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of medium distance - equatorial", () {
    double distance = GPS.distance(mogadishu, nairobi);
    double correctDistance = nairobiMogadishu;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of local distance - polar", () {
    double distance = GPS.distance(nyAlesund, longyearbyen);
    double correctDistance = nyAlesundLongyearbyen;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of great distance - meridial", () {
    double distance = GPS.distance(nyAlesund, prague);
    double correctDistance = pragueNyAlesund;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of great distance - parallel", () {
    double distance = GPS.distance(ulaanbaatar, prague);
    double correctDistance = pragueUlaanbaatar;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    print(distance*R);
    print(correctDistance*R);
    print(ratioDifference);
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of great distance - diagonal polar", () {
    double distance = GPS.distance(upernavik, prague);
    double correctDistance = pragueUpernavik;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    print(distance*R);
    print(correctDistance*R);
    print(ratioDifference);
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of great distance - diagonal", () {
    double distance = GPS.distance(mogadishu, prague);
    double correctDistance = pragueMogadishu;
    double ratioDifference = (distance - correctDistance) / correctDistance;
    print(distance*R);
    print(correctDistance*R);
    print(ratioDifference);
    bool isInTolerance = ratioDifference < TOLERANCE_RATIO && ratioDifference > (-TOLERANCE_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of smallest distance", () {
    double distance = GPS.smallestDistance(prague, [pardubitz, jungbunzlau, budweis, nairobi]);
    double correctDistance = GPS.distance(prague, pardubitz);
    expect(distance == correctDistance, equals(true));
  });

  test("Test of local distance commutation - parallels", () {
    double distance = GPS.distance(prague, pardubitz);
    double correctDistance = GPS.distance(pardubitz, prague);
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance =
        ratioDifference < TOLERANCE_COMMUTATION_RATIO && ratioDifference > (-TOLERANCE_COMMUTATION_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of local distance commutation - meridians", () {
    double distance = GPS.distance(prague, budweis);
    double correctDistance = GPS.distance(budweis, prague);
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance =
        ratioDifference < TOLERANCE_COMMUTATION_RATIO && ratioDifference > (-TOLERANCE_COMMUTATION_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of local distance commutation - diagonal", () {
    double distance = GPS.distance(prague, jungbunzlau);
    double correctDistance = GPS.distance(jungbunzlau, prague);
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance =
        ratioDifference < TOLERANCE_COMMUTATION_RATIO && ratioDifference > (-TOLERANCE_COMMUTATION_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of local distance commutation - equatorial", () {
    double distance = GPS.distance(mogadishu, adele);
    double correctDistance = GPS.distance(adele, mogadishu);
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance =
        ratioDifference < TOLERANCE_COMMUTATION_RATIO && ratioDifference > (-TOLERANCE_COMMUTATION_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of medium distance commutation - equatorial", () {
    double distance = GPS.distance(mogadishu, nairobi);
    double correctDistance = GPS.distance(nairobi, mogadishu);
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance =
        ratioDifference < TOLERANCE_COMMUTATION_RATIO && ratioDifference > (-TOLERANCE_COMMUTATION_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of local distance commutation - polar", () {
    double distance = GPS.distance(nyAlesund, longyearbyen);
    double correctDistance = GPS.distance(longyearbyen, nyAlesund);
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance =
        ratioDifference < TOLERANCE_COMMUTATION_RATIO && ratioDifference > (-TOLERANCE_COMMUTATION_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of great distance commutation - meridial", () {
    double distance = GPS.distance(nyAlesund, prague);
    double correctDistance = GPS.distance(prague, nyAlesund);
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance =
        ratioDifference < TOLERANCE_COMMUTATION_RATIO && ratioDifference > (-TOLERANCE_COMMUTATION_RATIO);
    expect(isInTolerance, equals(true));
  });

  test("Test of great distance commutation - diagonal", () {
    double distance = GPS.distance(mogadishu, prague);
    double correctDistance = GPS.distance(prague, mogadishu);
    double ratioDifference = (distance - correctDistance) / correctDistance;
    bool isInTolerance =
        ratioDifference < TOLERANCE_COMMUTATION_RATIO && ratioDifference > (-TOLERANCE_COMMUTATION_RATIO);
    expect(isInTolerance, equals(true));
  });
}
