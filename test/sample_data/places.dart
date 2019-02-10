part of akcnik.tests.sample;

List<Map> placesJson = [
  {"id": 1, "latitude": 50.0798103, "longitude": 14.4294828, "name": "Praha, u Koně"},
  {"id": 2, "latitude": 48.9765492, "longitude": 14.4746297, "name": "České Budějovice"},
  {"id": 3, "latitude": 49.8855875, "longitude": 16.8763978, "name": "Thilisar sídlo"},
  {"id": 4, "latitude": 45.8855875, "longitude": 26.8763978, "name": "Sídlo Nihilistů"}
  ,
  {
    "id":122,
    "latitude":50.027329,
    "longitude":15.2027277,
    "name":"Kolín - město",
    "description":null,
    "deprecated":null,
    "city":"Kolín",
    "ownerId":1
  },
  {
    "id":123,
    "latitude":50.2103605,
    "longitude":15.825211,
    "name":"Hradec Králové - město",
    "description":null,
    "deprecated":null,
    "city":"Hradec Králové",
    "ownerId":1
  },
  {
    "id":109,
    "latitude":49.8941920599256,
    "longitude":16.842934191227,
    "name":"Zábřeh Račice",
    "description":"Louka pod vysílačem",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":115,
    "latitude":50.436609,
    "longitude":15.3591238,
    "name":"Aš",
    "description":null,
    "deprecated":null,
    "city":"Aš",
    "ownerId":1
  },
  {
    "id":168,
    "latitude":49.9190671490749,
    "longitude":16.9437503814697,
    "name":"Sudkov",
    "description":null,
    "deprecated":null,
    "city":"Šumperk District",
    "ownerId":1
  },
  {
    "id":100,
    "latitude":50.0755381,
    "longitude":14.4378005,
    "name":"Praha - město",
    "description":null,
    "deprecated":null,
    "city":"Praha",
    "ownerId":1
  },
  {
    "id":126,
    "latitude":49.884861,
    "longitude":16.873884,
    "name":"Bastila",
    "description":"Hospoda",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":127,
    "latitude":49.882887,
    "longitude":16.876194,
    "name":"Cadilac Zábřeh",
    "description":"Zakouřený non-stop pub",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":128,
    "latitude":49.886644,
    "longitude":16.864293,
    "name":"Bořiny Zábřeh",
    "description":"Hospůdka",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":129,
    "latitude":49.757245,
    "longitude":17.3860322,
    "name":"Horní Loděnice tábořiště",
    "description":"Tábořiště u potoka kde se konají larpy.",
    "deprecated":null,
    "city":"Olomouc Region",
    "ownerId":1
  },
  {
    "id":130,
    "latitude":50.1997935266331,
    "longitude":15.8493769168854,
    "name":"Holland club Hradec Králové",
    "description":"Lepší kuřácký ale nezakouřený klub v HK. Točí se tu Plzeň a Kozel.",
    "deprecated":null,
    "city":"Nový Hradec Králové",
    "ownerId":1
  },
  {
    "id":131,
    "latitude":50.2031361,
    "longitude":15.8474117,
    "name":"Talův byt Hradec Králové",
    "description":"Tady děláme akčník",
    "deprecated":null,
    "city":"Hradec Králové",
    "ownerId":1
  },
  {
    "id":132,
    "latitude":50.1707083,
    "longitude":15.8574594,
    "name":"Biřička Hradec králové",
    "description":null,
    "deprecated":null,
    "city":"Nový Hradec Králové",
    "ownerId":1
  },
  {
    "id":133,
    "latitude":50.206415,
    "longitude":15.8453572,
    "name":"Stadion Hradec Králové",
    "description":null,
    "deprecated":null,
    "city":"Malšovice",
    "ownerId":1
  },
  {
    "id":134,
    "latitude":50.1967785279284,
    "longitude":15.8471775054932,
    "name":"Futurum Hradec Králové",
    "description":null,
    "deprecated":null,
    "city":"Hradec Králové District",
    "ownerId":1
  },
  {
    "id":135,
    "latitude":50.2037972055171,
    "longitude":15.8301401138306,
    "name":"Univerzita Hradec Králové",
    "description":"Budova A Univerzita Hradec Králové",
    "deprecated":null,
    "city":"Hradec Králové",
    "ownerId":1
  },
  {
    "id":136,
    "latitude":50.2111512877168,
    "longitude":15.8311325311661,
    "name":"Adalbertinum Hradec Králové",
    "description":null,
    "deprecated":null,
    "city":"Hradec Králové",
    "ownerId":1
  },
  {
    "id":138,
    "latitude":49.7160445173031,
    "longitude":15.6719970703125,
    "name":"Chotěboř",
    "description":null,
    "deprecated":null,
    "city":"Chotěboř",
    "ownerId":1
  },
  {
    "id":139,
    "latitude":50.2088236475568,
    "longitude":15.8311808109283,
    "name":"Katedrála sv.Ducha",
    "description":"Katedrála v Hradci Králové",
    "deprecated":null,
    "city":"Hradec Králové",
    "ownerId":1
  },
  {
    "id":140,
    "latitude":49.814062485264,
    "longitude":18.2716369628906,
    "name":"Ostrava",
    "description":null,
    "deprecated":null,
    "city":"Vítkovice",
    "ownerId":1
  },
  {
    "id":141,
    "latitude":49.8061669,
    "longitude":15.7314469,
    "name":"Hotel Vršovská Brána",
    "description":null,
    "deprecated":null,
    "city":"Nasavrky",
    "ownerId":1
  },
  {
    "id":142,
    "latitude":49.5678108633425,
    "longitude":17.4123001098633,
    "name":"Doloplazy",
    "description":"vesnice u Olomouce",
    "deprecated":null,
    "city":"Olomouc District",
    "ownerId":1
  },
  {
    "id":169,
    "latitude":49.3960745745792,
    "longitude":13.291654586792,
    "name":"Klatovy",
    "description":null,
    "deprecated":null,
    "city":"Klatovy",
    "ownerId":1
  },
  {
    "id":170,
    "latitude":49.7011970470677,
    "longitude":17.0757150650024,
    "name":"Litovel",
    "description":null,
    "deprecated":null,
    "city":"Litovel",
    "ownerId":1
  },
  {
    "id":143,
    "latitude":50.2153050536301,
    "longitude":15.828959941864,
    "name":"Aldis Hradec Králové",
    "description":null,
    "deprecated":null,
    "city":"Věkoše",
    "ownerId":1
  },
  {
    "id":144,
    "latitude":50.2126858202042,
    "longitude":15.8328384160995,
    "name":"Gayerova kasárna Hradec Králové",
    "description":null,
    "deprecated":null,
    "city":"Hradec Králové",
    "ownerId":1
  },
  {
    "id":124,
    "latitude":49.961221,
    "longitude":16.7657631,
    "name":"Štíty",
    "description":null,
    "deprecated":null,
    "city":"Bruntál",
    "ownerId":1
  },
  {
    "id":125,
    "latitude":49.9881767,
    "longitude":17.4636941,
    "name":"Bruntál",
    "description":null,
    "deprecated":null,
    "city":"Šumperk",
    "ownerId":1
  },
  {
    "id":145,
    "latitude":50.2089678409786,
    "longitude":15.8308213949203,
    "name":"Bílá věž Hradec Králové",
    "description":"Dominanta města Hradec Králové",
    "deprecated":null,
    "city":"Hradec Králové",
    "ownerId":1
  },
  {
    "id":171,
    "latitude":49.3961723309935,
    "longitude":15.586895942688,
    "name":"Jihlava",
    "description":null,
    "deprecated":null,
    "city":"Jihlava",
    "ownerId":1
  },
  {
    "id":85,
    "latitude":49.8812458945059,
    "longitude":16.8721598130651,
    "name":"Klub ve zdi Zábřeh",
    "description":"Drobný kulturní zakouřený a rušný klub.",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":87,
    "latitude":49.8864096795322,
    "longitude":16.8687451186997,
    "name":"Katolický dům Zábřeh",
    "description":null,
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":86,
    "latitude":49.8813722,
    "longitude":16.8792786,
    "name":"Kulturní dům Zábřeh",
    "description":"Kulturní dům v Zábřeze. Velký a malý taneční sál.",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":172,
    "latitude":49.8053179485792,
    "longitude":17.1324598789215,
    "name":"Horní Sukolom",
    "description":null,
    "deprecated":null,
    "city":"Olomouc Region",
    "ownerId":1
  },
  {
    "id":173,
    "latitude":49.6852899567354,
    "longitude":13.9995861053467,
    "name":"Příbram",
    "description":null,
    "deprecated":null,
    "city":"Příbram",
    "ownerId":1
  },
  {
    "id":95,
    "latitude":49.1950602,
    "longitude":16.6068371,
    "name":"Brno - město",
    "description":null,
    "deprecated":null,
    "city":"Brno",
    "ownerId":1
  },
  {
    "id":99,
    "latitude":49.8856713,
    "longitude":16.8764397,
    "name":"Thilisar",
    "description":"stary prostory",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":174,
    "latitude":50.7285507289013,
    "longitude":15.6015300750732,
    "name":"Špindlerův mlýn",
    "description":null,
    "deprecated":null,
    "city":"Špindlerův Mlýn",
    "ownerId":1
  },
  {
    "id":101,
    "latitude":50.083116,
    "longitude":14.434892,
    "name":"Hlavní nádraží Praha",
    "description":"Hlavák",
    "deprecated":null,
    "city":"Praha",
    "ownerId":1
  },
  {
    "id":108,
    "latitude":50.0864771,
    "longitude":14.4114366,
    "name":"Karlův most",
    "description":null,
    "deprecated":null,
    "city":"Praha",
    "ownerId":1
  },
  {
    "id":110,
    "latitude":49.593778,
    "longitude":17.2508786999999,
    "name":"Olomouc",
    "description":null,
    "deprecated":null,
    "city":"Olomouc",
    "ownerId":1
  },
  {
    "id":111,
    "latitude":49.4724489,
    "longitude":17.1067513,
    "name":"Prostějov - město",
    "description":null,
    "deprecated":null,
    "city":"Prostějov",
    "ownerId":1
  },
  {
    "id":112,
    "latitude":48.9756578,
    "longitude":14.4802549999999,
    "name":"České Budějovice - město",
    "description":null,
    "deprecated":null,
    "city":"České Budějovice",
    "ownerId":1
  },
  {
    "id":175,
    "latitude":49.783868799232,
    "longitude":14.6827983856201,
    "name":"Benešov",
    "description":null,
    "deprecated":null,
    "city":"Benešov u Prahy",
    "ownerId":1
  },
  {
    "id":114,
    "latitude":49.7384314,
    "longitude":13.3736371,
    "name":"Plzeň - město",
    "description":null,
    "deprecated":null,
    "city":"Plzeň",
    "ownerId":1
  },
  {
    "id":176,
    "latitude":48.7530764839971,
    "longitude":16.8835401535034,
    "name":"Břeclav",
    "description":null,
    "deprecated":null,
    "city":"Břeclav",
    "ownerId":1
  },
  {
    "id":116,
    "latitude":50.0795334,
    "longitude":12.3698636,
    "name":"Cheb - město",
    "description":null,
    "deprecated":null,
    "city":"Cheb",
    "ownerId":1
  },
  {
    "id":117,
    "latitude":49.9120412,
    "longitude":16.6124965,
    "name":"Lanškroun - město",
    "description":null,
    "deprecated":null,
    "city":"Lanškroun",
    "ownerId":1
  },
  {
    "id":118,
    "latitude":50.76628,
    "longitude":15.0543387,
    "name":"Liberec - město",
    "description":null,
    "deprecated":null,
    "city":"Liberec",
    "ownerId":1
  },
  {
    "id":119,
    "latitude":50.0016037,
    "longitude":16.2230307,
    "name":"Choceň - město",
    "description":null,
    "deprecated":null,
    "city":"Choceň",
    "ownerId":1
  },
  {
    "id":120,
    "latitude":49.7551629,
    "longitude":16.4691861,
    "name":"Svitavy - město",
    "description":null,
    "deprecated":null,
    "city":"Svitavy",
    "ownerId":1
  },
  {
    "id":146,
    "latitude":50.2111238235984,
    "longitude":15.8322831988335,
    "name":"Městská hudební síň Hradec Králové",
    "description":null,
    "deprecated":null,
    "city":"Hradec Králové",
    "ownerId":1
  },
  {
    "id":121,
    "latitude":49.9497244,
    "longitude":15.7950578,
    "name":"Chrudim - město",
    "description":null,
    "deprecated":null,
    "city":"Chrudim",
    "ownerId":1
  },
  {
    "id":147,
    "latitude":49.9652868965523,
    "longitude":16.9727396965027,
    "name":"šumperk",
    "description":null,
    "deprecated":null,
    "city":"Šumperk District",
    "ownerId":1
  },
  {
    "id":148,
    "latitude":49.9652868965523,
    "longitude":16.9727396965027,
    "name":"Šumperk",
    "description":null,
    "deprecated":null,
    "city":"Šumperk District",
    "ownerId":1
  },
  {
    "id":149,
    "latitude":49.8846808593254,
    "longitude":16.9354248046875,
    "name":"Příbor",
    "description":null,
    "deprecated":null,
    "city":"Olomouc Region",
    "ownerId":1
  },
  {
    "id":150,
    "latitude":49.8846808593254,
    "longitude":16.9354248046875,
    "name":"Příbor",
    "description":null,
    "deprecated":null,
    "city":"Olomouc Region",
    "ownerId":1
  },
  {
    "id":151,
    "latitude":49.8820089530896,
    "longitude":16.8721944093704,
    "name":"U Kapří fontánky Zábřeh",
    "description":"Za radnicí",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":152,
    "latitude":49.3114283,
    "longitude":16.8044578,
    "name":"Rakovecké údolí",
    "description":null,
    "deprecated":null,
    "city":"South Moravian Region",
    "ownerId":1
  },
  {
    "id":153,
    "latitude":49.5648048451333,
    "longitude":16.1792135238647,
    "name":"Hotel Skalský dvůr",
    "description":null,
    "deprecated":null,
    "city":"Bystřice nad Pernštejnem",
    "ownerId":1
  },
  {
    "id":154,
    "latitude":49.9216092133163,
    "longitude":17.0270919799805,
    "name":"Svojšice",
    "description":"asdasd",
    "deprecated":null,
    "city":"Olomouc Region",
    "ownerId":1
  },
  {
    "id":155,
    "latitude":49.970511,
    "longitude":15.603503,
    "name":"festivalový areál Svojšice",
    "description":"festivalový areál Svojšice",
    "deprecated":null,
    "city":"Pardubice Region",
    "ownerId":1
  },
  {
    "id":156,
    "latitude":50.1623844611494,
    "longitude":16.9473552703857,
    "name":"Staré Město pod Sněžníkem",
    "description":null,
    "deprecated":null,
    "city":"Staré Město pod Sněžníkem",
    "ownerId":1
  },
  {
    "id":157,
    "latitude":50.1069418765298,
    "longitude":14.4294476509094,
    "name":"Praha EXPO",
    "description":"Výstaviště EXPO Praha",
    "deprecated":null,
    "city":"Praha 7",
    "ownerId":1
  },
  {
    "id":158,
    "latitude":50.2370497784788,
    "longitude":14.9052715301514,
    "name":"Airfield Milovice",
    "description":"letiště milovice",
    "deprecated":null,
    "city":"Central Bohemian Region",
    "ownerId":1
  },
  {
    "id":159,
    "latitude":49.7047219975182,
    "longitude":16.8896555900574,
    "name":"Bouzov",
    "description":null,
    "deprecated":null,
    "city":"Olomouc District",
    "ownerId":1
  },
  {
    "id":160,
    "latitude":49.8708530977836,
    "longitude":17.8788757324219,
    "name":"Hradec nad Moravicí",
    "description":null,
    "deprecated":null,
    "city":"Hradec nad Moravicí",
    "ownerId":1
  },
  {
    "id":161,
    "latitude":50.1775577291268,
    "longitude":13.377571105957,
    "name":"Vroutek",
    "description":null,
    "deprecated":null,
    "city":"Vroutek",
    "ownerId":1
  },
  {
    "id":162,
    "latitude":50.5388537270304,
    "longitude":14.7210788726807,
    "name":"Bezděz",
    "description":"hrad",
    "deprecated":null,
    "city":"Česká Lípa District",
    "ownerId":1
  },
  {
    "id":163,
    "latitude":50.0684615799796,
    "longitude":16.9282579421997,
    "name":"Hanušovice",
    "description":"pivovar Holba",
    "deprecated":null,
    "city":"Hanušovice",
    "ownerId":1
  },
  {
    "id":164,
    "latitude":49.4167247861733,
    "longitude":14.6603107452393,
    "name":"Tábor",
    "description":null,
    "deprecated":null,
    "city":"Tábor",
    "ownerId":1
  },
  {
    "id":165,
    "latitude":49.9359092801222,
    "longitude":17.0186430215836,
    "name":"Nový Malín",
    "description":null,
    "deprecated":null,
    "city":"788 03",
    "ownerId":1
  },
  {
    "id":166,
    "latitude":49.8559423353685,
    "longitude":16.9022941589355,
    "name":"Rájec",
    "description":"Areál u Antoníčka.",
    "deprecated":null,
    "city":"Šumperk District",
    "ownerId":1
  },
  {
    "id":167,
    "latitude":49.3086444576391,
    "longitude":14.1407775878906,
    "name":"Písek",
    "description":null,
    "deprecated":null,
    "city":"Pražské Předměstí",
    "ownerId":1
  },
  {
    "id":177,
    "latitude":48.8522914060438,
    "longitude":16.0517120413715,
    "name":"Znojmo",
    "description":null,
    "deprecated":null,
    "city":"Znojmo",
    "ownerId":1
  },
  {
    "id":178,
    "latitude":49.2242962492338,
    "longitude":17.6627540588379,
    "name":"Zlín",
    "description":null,
    "deprecated":null,
    "city":"Zlín 1",
    "ownerId":1
  },
  {
    "id":179,
    "latitude":50.5366307577706,
    "longitude":14.1288900375366,
    "name":"Litoměřice",
    "description":null,
    "deprecated":null,
    "city":"Předměstí",
    "ownerId":1
  },
  {
    "id":180,
    "latitude":49.7287514565643,
    "longitude":17.2969436645508,
    "name":"Šternberk",
    "description":null,
    "deprecated":null,
    "city":"Šternberk",
    "ownerId":1
  },
  {
    "id":181,
    "latitude":50.5825826251506,
    "longitude":14.6475219726562,
    "name":"Doksy",
    "description":null,
    "deprecated":null,
    "city":"Doksy",
    "ownerId":1
  },
  {
    "id":182,
    "latitude":49.2189986748669,
    "longitude":17.8519248962402,
    "name":"Vizovice",
    "description":null,
    "deprecated":null,
    "city":"Vizovice",
    "ownerId":1
  },
  {
    "id":183,
    "latitude":48.9766679202811,
    "longitude":14.4758284091949,
    "name":"České Budějovice",
    "description":null,
    "deprecated":null,
    "city":"České Budějovice 1",
    "ownerId":1
  },
  {
    "id":184,
    "latitude":50.2384222188173,
    "longitude":12.8711700439453,
    "name":"Karlovy Vary",
    "description":null,
    "deprecated":null,
    "city":"Bohatice",
    "ownerId":1
  },
  {
    "id":185,
    "latitude":49.5486025606919,
    "longitude":17.7338218688965,
    "name":"Hranice na Moravě",
    "description":null,
    "deprecated":null,
    "city":"Hranice",
    "ownerId":1
  },
  {
    "id":186,
    "latitude":49.8758868613555,
    "longitude":16.8775427341461,
    "name":"zábřeh",
    "description":null,
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":187,
    "latitude":49.1787858788509,
    "longitude":15.4519271850586,
    "name":"Telč",
    "description":null,
    "deprecated":null,
    "city":"Telč",
    "ownerId":1
  },
  {
    "id":188,
    "latitude":49.1496013304359,
    "longitude":15.0025177001953,
    "name":"Jindřichův Hradec",
    "description":null,
    "deprecated":null,
    "city":"Jindřichův Hradec",
    "ownerId":1
  },
  {
    "id":189,
    "latitude":49.1843963201528,
    "longitude":16.6092681884766,
    "name":"brno",
    "description":null,
    "deprecated":null,
    "city":"Trnitá",
    "ownerId":1
  },
  {
    "id":190,
    "latitude":49.190679259307,
    "longitude":16.6230010986328,
    "name":"Brno",
    "description":null,
    "deprecated":null,
    "city":"Trnitá",
    "ownerId":1
  },
  {
    "id":191,
    "latitude":50.7651279729021,
    "longitude":15.0478363037109,
    "name":"Liberec",
    "description":null,
    "deprecated":null,
    "city":"Liberec District",
    "ownerId":1
  },
  {
    "id":20,
    "latitude":49.8654107878936,
    "longitude":16.8932551145554,
    "name":"Ráječek",
    "description":"",
    "deprecated":null,
    "city":"Šumperk",
    "ownerId":1
  },
  {
    "id":21,
    "latitude":49.8635850218119,
    "longitude":16.8870270252228,
    "name":"Ráječek kalbiště",
    "description":"",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":22,
    "latitude":49.8815284781961,
    "longitude":16.8716767430305,
    "name":"Zámecké nádvoří Zábřeh",
    "description":"",
    "deprecated":null,
    "city":"Zábřeh",
    "ownerId":1
  },
  {
    "id":192,
    "latitude":50.1996493055189,
    "longitude":15.9001350402832,
    "name":"ree",
    "description":"",
    "deprecated":null,
    "city":"500 09",
    "ownerId":96
  },
  {
    "id":193,
    "latitude":49.5225897207765,
    "longitude":16.2611389160156,
    "name":"Bystřice nad Perštejnem",
    "description":"",
    "deprecated":null,
    "city":"Kraj Vysočina",
    "ownerId":96
  }
];
