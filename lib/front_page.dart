import 'dart:async';

// import 'package:carp_background_location/carp_background_location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shifter/controller/main_screen_controllers/front_page_controller.dart';
import 'package:shifter/controller/main_screen_controllers/order_controller.dart';
import 'package:shifter/google_maps_requests.dart';
import 'package:shifter/incoming_messages.dart';
import 'package:shifter/loading.dart';
import 'package:shifter/menu.dart';
import 'package:shifter/order_details.dart';
import 'package:shifter/user.dart';
import 'package:shifter/wrapper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:shifter/globals.dart' as globals;
import 'package:intl/intl.dart' as INTL;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum LocationStatus { UNKNOWN, RUNNING, STOPPED }

String id = "";
// Future<void> updateLocfire(double lat, double lng) async {
//   // FlutterCompass.events.listen(_onData);
//
//   final databaseReference = FirebaseDatabase.instance.ref();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //Return String
//   if (prefs.getString('ColorStatus') != null) {
//     await databaseReference.child('$id').set({
//       'angle': '0',
//       'lat': lat,
//       'lng': lng,
//       'status': prefs.getString('ColorStatus')
//     });
//   }
// }

// updateLoc(String loc) async {
//   String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <UpdateDriverLocation xmlns="http://Mgra.WS/">
//       <ID>$id</ID>
//       <Current_Location>$loc</Current_Location>
//     </UpdateDriverLocation>
//   </soap:Body>
// </soap:Envelope>''';
//   http.Response response = await http
//       .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//           headers: {
//             "SOAPAction": "http://Mgra.WS/UpdateDriverLocation",
//             "Content-Type": "text/xml;charset=UTF-8",
//           },
//           body: utf8.encode(soap),
//           encoding: Encoding.getByName("UTF-8"))
//       .then((onValue) {
//     return onValue;
//   });
//   String json = parse(response.body)
//       .getElementsByTagName('UpdateDriverLocationResult')[0]
//       .text;
//   final decoded = jsonDecode(json);
//   print('Updated with $decoded');
// }

class FrontPage extends StatefulWidget {
  final int tab;
  final User user;

  // final Key key;
  FrontPage({
    required this.user,
    required this.tab,
  }) : super();

  @override
  FrontPageState createState() => FrontPageState();
}

class FrontPageState extends State<FrontPage>
    with SingleTickerProviderStateMixin {
  int _tab = 0;
  bool load = false;
  bool loadStat = false;
  bool loadOrders = false;
  String notifyFlag = "";
  String onlineFlag = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String dayOrders = '';
  String dayEarn = '';
  String weekOrders = '';
  String weekEarn = '';
  String from = '';
  String to = '';
  late TabController controller;
  List<Widget> orders = <Widget>[];
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  final orderController = Get.put(OrderController());
  final frontPageController = Get.put(FrontPageController());
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId:
        PolylineId(widget.user.id.toString() + DateTime.now().toString()),
        width: 5,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.blue));
  }

  // ! ADD A MARKER ON THE MAO
  void _addMarkerDrop(LatLng location) {
    _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
  }

  void _addMarkerPick(LatLng location) {
    _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = <double>[];
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++)
      lList[i] += lList[i - 2];

    return lList;
  }

  Future<void> sendLocRequest(LatLng initial, LatLng destination) async {
    String route =
    await _googleMapsServices.getRouteCoordinates(initial, destination);
    createRoute(route);
  }

//   Future<void> loadAll() async {
//     orders = [];
//     String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <GetAllOrders xmlns="http://Mgra.WS/">
//       <DriverID>${widget.user.id}</DriverID>
//       <language>${globals.loc.toUpperCase()}</language>
//     </GetAllOrders>
//   </soap:Body>
// </soap:Envelope>''';
//     http.Response response = await http
//         .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/GetAllOrders",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     print(response.body);
//     if (response.statusCode == 200) {
//       String json = parse(response.body)
//           .getElementsByTagName('GetAllOrdersResult')[0]
//           .text;
//       final decoded = jsonDecode(json);
//       for (int i = 0; i < decoded.length; i++) {
//         orders.add(AllV2(
//             user: widget.user,
//             status: decoded[i]['Status'],
//             no: decoded[i]['NO'],
//             id: decoded[i]['ID'],
//             amount: decoded[i]['Amount']));
//       }
//     }
//   }

//   Future<void> loadPending() async {
//     orders = [];
//     String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <GetPendingOrderV2 xmlns="http://Mgra.WS/">
//       <DriverID>${widget.user.id}</DriverID>
//       <language>${globals.loc.toUpperCase()}</language>
//     </GetPendingOrderV2>
//   </soap:Body>
// </soap:Envelope>''';
//     http.Response response = await http
//         .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/GetPendingOrderV2",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     print(response.body);
//     if (response.statusCode == 200) {
//       String json = parse(response.body)
//           .getElementsByTagName('GetPendingOrderV2Result')[0]
//           .text;
//       final decoded = jsonDecode(json);
//       for (int i = 0; i < decoded.length; i++) {
//         orders.add(ProgressV2(
//             user: widget.user,
//             status: decoded[i]['Status'],
//             customer: decoded[i]['Customer'],
//             distance: decoded[i]['Distance'],
//             photo: decoded[i]['Photo'],
//             pickAddress: decoded[i]['PickAddress'],
//             pickText: decoded[i]['PickAddresstxt'],
//             profit: decoded[i]['Profit'],
//             id: decoded[i]['ID'],
//             type: decoded[i]['Type'],
//             branch: decoded[i]['branch']));
//       }
//     }
//   }

//   Future<void> loadNew() async {
//     orders = [];
//     String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <GetNewOrderV2 xmlns="http://Mgra.WS/">
//       <DriverID>${widget.user.id}</DriverID>
//       <language>${globals.loc.toUpperCase()}</language>
//     </GetNewOrderV2>
//   </soap:Body>
// </soap:Envelope>''';
//     http.Response response = await http
//         .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/GetNewOrderV2",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     print(response.body);
//     if (response.statusCode == 200) {
//       String json = parse(response.body)
//           .getElementsByTagName('GetNewOrderV2Result')[0]
//           .text;
//       final decoded = jsonDecode(json);
//       for (int i = 0; i < decoded.length; i++) {
//         _markers.clear();
//         _polyLines.clear();
//         await sendLocRequest(
//             LatLng(double.parse(decoded[i]['PickAddress'].split(',')[0]),
//                 double.parse(decoded[i]['PickAddress'].split(',')[1])),
//             LatLng(double.parse(decoded[i]['DropAddress'].split(',')[0]),
//                 double.parse(decoded[i]['DropAddress'].split(',')[1])));
//         _addMarkerPick(LatLng(
//             double.parse(decoded[i]['PickAddress'].split(',')[0]),
//             double.parse(decoded[i]['PickAddress'].split(',')[1])));
//         _addMarkerDrop(LatLng(
//             double.parse(decoded[i]['DropAddress'].split(',')[0]),
//             double.parse(decoded[i]['DropAddress'].split(',')[1])));
//         orders.add(NewV2(
//           timerEnd: (id) {
//             setState(() {
//               orders.removeAt(i);
//             });
//           },
//           user: widget.user,
//           customer: decoded[i]['Customer'],
//           date: decoded[i]['Date'],
//           distance: decoded[i]['Distance'],
//           drop: decoded[i]['DropAddress'],
//           markers: _markers,
//           notes: decoded[i]['Notes'],
//           photo: decoded[i]['Photo'],
//           pick: decoded[i]['PickAddress'],
//           pickText: decoded[i]['PickAddresstxt'],
//           polyLines: _polyLines,
//           profit: decoded[i]['Profit'],
//           timer: decoded[i]['Timer'],
//           id: decoded[i]['ID'],
//           type: decoded[i]['Type'],
//           branch: decoded[i]['Branch'],
//         ));
//       }
//     }
//   }

//   Future<void> loadWeek() async {
//     String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <WeekCounterByDriver xmlns="http://Mgra.WS/">
//       <DriverID>${widget.user.id}</DriverID>
//     </WeekCounterByDriver>
//   </soap:Body>
// </soap:Envelope>''';
//     http.Response response = await http
//         .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/WeekCounterByDriver",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     print(response.body);
//     if (response.statusCode == 200) {
//       String json = parse(response.body)
//           .getElementsByTagName('WeekCounterByDriverResult')[0]
//           .text;
//       final decoded = jsonDecode(json);
//       weekOrders = decoded['Order'];
//       weekEarn = decoded['Profit'];
//       from = decoded['FromDate'];
//       to = decoded['ToDate'];
//     }
//   }

//   Future<void> loadToday() async {
//     String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <TodayCounterByDriver xmlns="http://Mgra.WS/">
//       <DriverID>${widget.user.id}</DriverID>
//     </TodayCounterByDriver>
//   </soap:Body>
// </soap:Envelope>''';
//     http.Response response = await http
//         .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/TodayCounterByDriver",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     print(response.body);
//     if (response.statusCode == 200) {
//       String json = parse(response.body)
//           .getElementsByTagName('TodayCounterByDriverResult')[0]
//           .text;
//       final decoded = jsonDecode(json);
//       dayOrders = decoded['order'];
//       dayEarn = decoded['profit'];
//     }
//   }

//   Future<void> loadStatus() async {
//     String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <GetCurrentStatus xmlns="http://Mgra.WS/">
//       <DriverID>${widget.user.id}</DriverID>
//     </GetCurrentStatus>
//   </soap:Body>
// </soap:Envelope>''';
//     http.Response response = await http
//         .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/GetCurrentStatus",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     print(response.body);
//     if (response.statusCode == 200) {
//       String json = parse(response.body)
//           .getElementsByTagName('GetCurrentStatusResult')[0]
//           .text;
//       final decoded = jsonDecode(json);
//       onlineFlag = decoded['Status'];
//       notifyFlag = decoded['NotificationFlag'];
//     }
//   }

  // void loadData() async {
  //   setState(() {
  //     load = true;
  //   });
  //   await loadStatus();
  //   if (widget.tab == 1)
  //     await loadPending();
  //   else if (widget.tab == 2) {
  //     await loadAll();
  //   } else
  //     await loadNew();
  //
  //     await loadWeek();
  //     await loadToday();
  //
  //   setState(() {
  //     load = false;
  //   });
  // }

  // LocationManager locationManager = LocationManager();
  // late Stream<LocationDto> dtoStream;
  // late StreamSubscription<LocationDto> dtoSubscription;
  // LocationStatus _status = LocationStatus.UNKNOWN;
  // late LocationDto lastLocation;
  // late DateTime lastTimeLocation;
  // bool locationServiceActive = true;
  // void onData(LocationDto dto) {
  //   setState(() {
  //     if (_status == LocationStatus.UNKNOWN) {
  //       _status = LocationStatus.RUNNING;
  //     }
  //     lastLocation = dto;
  //     updateLocfire(lastLocation.latitude, lastLocation.longitude);
  //
  //     updateLoc('${lastLocation.latitude},${lastLocation.longitude}');
  //     lastTimeLocation = DateTime.now();
  //   });
  // }

  void start() async {
    // Subscribe if it hasn't been done already
    // dtoSubscription.cancel();
    // dtoSubscription = dtoStream.listen(onData);
    // await locationManager.start();
    // setState(() {
    //   _status = LocationStatus.RUNNING;
    // });
  }

  @override
  void initState() {
    id = widget.user.id ?? "";
    super.initState();
    orderController.getDriverNewOrders();
    // locationManager.interval = 1;
    // locationManager.distanceFilter = 0;
    // locationManager.notificationTitle = 'Shifter Captain';
    // locationManager.notificationMsg = 'Shifter is tracking your location';
    // dtoStream = locationManager.locationStream;
    //
    // dtoSubscription = dtoStream.listen(onData);
    // loadData();
    controller =
    new TabController(length: 3, vsync: this, initialIndex: widget.tab);
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      globals.loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
          drawer: Menu(user: widget.user),
          key: _scaffoldKey,
          body: load
              ? Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Loading()],
            ),
          )
              : Obx(() {
            return SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xff2b2b2b),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FloatingActionButton(
                              heroTag: null,
                              mini: true,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                            loadStat
                                ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Colors.white),
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                CupertinoSwitch(
                                    value: onlineFlag == 'True'
                                        ? true
                                        : false,
                                    onChanged: (value) async {
//                                                 if (value == true) {
//                                                   onlineFlag = 'True';
//                                                 } else {
//                                                   onlineFlag = 'False';
//                                                 }
//                                                 setState(() {
//                                                   loadStat = true;
//                                                 });
//                                                 String soap =
//                                                     '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//       <UpdateDriverOnline xmlns="http://Mgra.WS/">
//         <ID>${widget.user.id}</ID>
//         <Status>$onlineFlag</Status>
//       </UpdateDriverOnline>
//   </soap:Body>
// </soap:Envelope>''';
//                                                 http.Response response =
//                                                     await http
//                                                         .post(
//                                                             Uri.parse(
//                                                                 'http://tryconnect.net/api/MgraWebService.asmx'),
//                                                             headers: {
//                                                               "SOAPAction":
//                                                                   "http://Mgra.WS/UpdateDriverOnline",
//                                                               "Content-Type":
//                                                                   "text/xml;charset=UTF-8",
//                                                             },
//                                                             body: utf8
//                                                                 .encode(soap),
//                                                             encoding: Encoding
//                                                                 .getByName(
//                                                                     "UTF-8"))
//                                                         .then((onValue) {
//                                                   return onValue;
//                                                 });
//
//                                                 if (response.statusCode ==
//                                                     200) {
//                                                   String json = parse(
//                                                           response.body)
//                                                       .getElementsByTagName(
//                                                           'UpdateDriverOnlineResult')[0]
//                                                       .text;
//                                                   final decoded =
//                                                       jsonDecode(json);
//
//                                                   if (onlineFlag == 'False') {
//                                                     SharedPreferences prefs =
//                                                         await SharedPreferences
//                                                             .getInstance();
//                                                     prefs.setString(
//                                                         'ColorStatus', "1");
//                                                   } else {
//                                                     if (onlineFlag == 'True') {
//                                                       SharedPreferences prefs =
//                                                           await SharedPreferences
//                                                               .getInstance();
//                                                       prefs.setString(
//                                                           'ColorStatus', "2");
//                                                     }
//                                                   }
//                                                   if (decoded == "-1") {
//                                                     if (onlineFlag == 'False') {
//                                                       SharedPreferences prefs =
//                                                           await SharedPreferences
//                                                               .getInstance();
//                                                       prefs.setString(
//                                                           'ColorStatus', "2");
//                                                     }
//                                                   }
//
//                                                   setState(() {
//                                                     if (decoded == "-1") {
//                                                       onlineFlag = 'True';
//
//                                                       /*  _scaffoldKey.currentState
//                                                           .showSnackBar(
//                                                               SnackBar(
//                                                                   content: Text(
//                                                         globals.loc == 'en'
//                                                             ? "Can't go offline now."
//                                                             : 'لا يمكنك اطفاء الخدمة الان',
//                                                       ))); */
//                                                     }
//
//                                                     loadStat = false;
//                                                   });
//                                                 }
                                    }),
                                SizedBox(height: 5),
                                Text(
                                    onlineFlag == 'True'
                                        ? globals.loc == 'en'
                                        ? 'Online'
                                        : 'متصل'
                                        : globals.loc == 'en'
                                        ? 'Offline'
                                        : 'غير متصل',
                                    style: TextStyle(
                                        color: onlineFlag == 'True'
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 13))
                              ],
                            ),
                            Stack(
                              children: [
                                FloatingActionButton(
                                  heroTag: null,
                                  mini: true,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.notifications_active,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IncomingMessages(
                                                    user: widget.user)));
                                  },
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: notifyFlag == '1'
                                      ? Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                        BorderRadius.circular(
                                            50)),
                                  )
                                      : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      _tab == 2
                          ? Container(
                        decoration:
                        BoxDecoration(color: Colors.grey[200]),
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: globals.loc == 'en'
                                            ? BorderSide(
                                            width: 0.0,
                                            color: Colors
                                                .transparent)
                                            : BorderSide(
                                            width: 2.0,
                                            color: Colors.grey),
                                        right: globals.loc == 'en'
                                            ? BorderSide(
                                            width: 2.0,
                                            color: Colors.grey)
                                            : BorderSide(
                                            width: 0.0,
                                            color: Colors
                                                .transparent))),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('$weekOrders',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(
                                      globals.loc == 'en'
                                          ? 'Orders per week'
                                          : 'الطلبات في الأسبوع',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: globals.loc == 'en'
                                            ? BorderSide(
                                            width: 0.0,
                                            color: Colors
                                                .transparent)
                                            : BorderSide(
                                            width: 2.0,
                                            color: Colors.grey),
                                        right: globals.loc == 'en'
                                            ? BorderSide(
                                            width: 2.0,
                                            color: Colors.grey)
                                            : BorderSide(
                                            width: 0.0,
                                            color: Colors
                                                .transparent))),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('$weekEarn',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(
                                        globals.loc == 'en'
                                            ? 'Weekly Profit'
                                            : 'الدخل الأسبوعي',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(from,
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    SizedBox(height: 10),
                                    Text(to,
                                        style:
                                        TextStyle(fontSize: 16))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(
                        decoration:
                        BoxDecoration(color: Colors.grey[200]),
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: globals.loc == 'en'
                                            ? BorderSide(
                                            width: 0.0,
                                            color: Colors
                                                .transparent)
                                            : BorderSide(
                                            width: 2.0,
                                            color: Colors.grey),
                                        right: globals.loc == 'en'
                                            ? BorderSide(
                                            width: 2.0,
                                            color: Colors.grey)
                                            : BorderSide(
                                            width: 0.0,
                                            color: Colors
                                                .transparent))),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('$dayOrders',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(
                                      globals.loc == 'en'
                                          ? 'Today\'s Orders'
                                          : 'طلبات اليوم',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: globals.loc == 'en'
                                            ? BorderSide(
                                            width: 0.0,
                                            color: Colors
                                                .transparent)
                                            : BorderSide(
                                            width: 2.0,
                                            color: Colors.grey),
                                        right: globals.loc == 'en'
                                            ? BorderSide(
                                            width: 2.0,
                                            color: Colors.grey)
                                            : BorderSide(
                                            width: 0.0,
                                            color: Colors
                                                .transparent))),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('$dayEarn',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(
                                        globals.loc == 'en'
                                            ? 'Today\'s Earnings'
                                            : 'دخل اليوم',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        INTL.DateFormat('EEEE')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(
                                        INTL.DateFormat('dd/MM/yyyy')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        unselectedLabelColor: Colors.grey,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.black,
                        indicatorColor: Color(0xffae5a95),
                        indicatorWeight: 3.0,
                        labelStyle:
                        TextStyle(fontSize: 13, fontFamily: 'Almarai'),
                        unselectedLabelStyle:
                        TextStyle(fontSize: 13, fontFamily: 'Almarai'),
                        controller: controller,
                        onTap: (i) async {
                          setState(() {
                            _tab = i;
                            loadOrders = true;
                          });
                          if (_tab == 0) {
                            // await loadNew();
                            orderController.getDriverNewOrders();
                          } else if (_tab == 1) {
                            orderController.getDriverInProgressOrders();

                            // await loadPending();
                          } else {
                            orderController.getDriverAllOrders();

                            // await loadAll();
                          }
                          setState(() {
                            loadOrders = false;
                          });
                        },
                        tabs: <Widget>[
                          Tab(
                            text: globals.loc == 'en' ? 'New' : 'طلب جديد',
                          ),
                          Tab(
                            text: globals.loc == 'en'
                                ? 'In Progress'
                                : 'طلب قيد الاجراء',
                          ),
                          Tab(
                            text: globals.loc == 'en'
                                ? 'All Orders'
                                : 'جميع الطلبات',
                          ),
                        ],
                      ),
                      _tab == 0
                          ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount:
                        orderController.listOfNewOrders.length,
                        itemBuilder: (context, index) =>
                            NewV2(
                              customer: orderController
                                  .listOfNewOrders[index].customer ??
                                  "",
                              timerEnd: (id) {},
                              date: orderController
                                  .listOfNewOrders[index].date
                                  .toString(),
                              distance: "0 km",
                              drop: "drop",
                              markers: _markers,
                              notes: "notes",
                              photo: orderController
                                  .listOfNewOrders[index].photo ??
                                  "",
                              pick: orderController.listOfNewOrders[index]
                                  .pickAddress ??
                                  "",
                              pickText: " ",
                              polyLines: _polyLines,
                              profit: "0",
                              timer: "0",
                              id: "id",
                              user: frontPageController.userModel.value,
                              type: "type",
                              branch: "branch",
                              onAcceptOrder: () {
                                // accepting the order
                                orderController.acceptOrder(
                                    orderController
                                        .listOfNewOrders[index].id
                                        .toString());
                              },
                            ),
                      )
                          : _tab == 2 ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount:
                          orderController.listOfAllOrders.length,
                          itemBuilder: (context, index) =>
                              AllV2(amount: "0",
                                  user: frontPageController.userModel.value,
                                  id: orderController
                                      .listOfAllOrders[index].id.toString(),
                                  no: orderController
                                      .listOfAllOrders[index].referancecode
                                      .toString(),
                                  status: "status")
                        // NewV2(
                        //   customer: orderController
                        //       .listOfAllOrders[index].customer ??
                        //       "",
                        //   timerEnd: (id) {},
                        //   date: orderController
                        //       .listOfAllOrders[index].date
                        //       .toString(),
                        //   distance: "0 km",
                        //   drop: "drop",
                        //   markers: _markers,
                        //   notes: "notes",
                        //   photo: orderController
                        //       .listOfAllOrders[index].photo ??
                        //       "",
                        //   pick: orderController.listOfAllOrders[index]
                        //       .pickAddress ??
                        //       "",
                        //   pickText: " ",
                        //   polyLines: _polyLines,
                        //   profit: "0",
                        //   timer: "0",
                        //   id: "id",
                        //   user: frontPageController.userModel.value,
                        //   type: "type",
                        //   branch: "branch",
                        //   onAcceptOrder: () {
                        //     // accepting the order
                        //     orderController.acceptOrder(
                        //         orderController
                        //             .listOfAllOrders[index].id
                        //             .toString());
                        //   },
                        // ),
                      ) : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount:
                        0,
                        itemBuilder: (context, index) =>
                            NewV2(
                              customer: orderController
                                  .listOfNewOrders[index].customer ??
                                  "",
                              timerEnd: (id) {},
                              date: orderController
                                  .listOfNewOrders[index].date
                                  .toString(),
                              distance: "0 km",
                              drop: "drop",
                              markers: _markers,
                              notes: "notes",
                              photo: orderController
                                  .listOfNewOrders[index].photo ??
                                  "",
                              pick: orderController.listOfNewOrders[index]
                                  .pickAddress ??
                                  "",
                              pickText: " ",
                              polyLines: _polyLines,
                              profit: "0",
                              timer: "0",
                              id: "id",
                              user: frontPageController.userModel.value,
                              type: "type",
                              branch: "branch",
                              onAcceptOrder: () {
                                // accepting the order
                                orderController.acceptOrder(
                                    orderController
                                        .listOfNewOrders[index].id
                                        .toString());
                              },
                            ),
                      )
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}

typedef void CallBack(String id);

class NewV2 extends StatefulWidget {
  final User user;
  final String distance;
  final String timer;
  final String profit;
  final Set<Marker> markers;
  final Set<Polyline> polyLines;
  final String pick;
  final String drop;
  final String photo;
  final String customer;
  final String date;
  final String pickText;
  final String notes;
  final String id;
  final String type;
  final CallBack timerEnd;
  final void Function()? onAcceptOrder;
  final String branch;

  NewV2({required this.customer,
    required this.timerEnd,
    required this.date,
    required this.onAcceptOrder,
    required this.distance,
    required this.drop,
    required this.markers,
    required this.notes,
    required this.photo,
    required this.pick,
    required this.pickText,
    required this.polyLines,
    required this.profit,
    required this.timer,
    required this.id,
    required this.user,
    required this.type,
    required this.branch});

  @override
  _NewV2State createState() => _NewV2State();
}

class _NewV2State extends State<NewV2> {
  late GoogleMapController _mapController;
  bool load = false;
  Timer _timer = Timer(
    Duration(seconds: 60),
        () {},
  );
  int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          widget.timerEnd(widget.id);
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }
  //
  // @override
  // void initState() {
  //   _start = int.parse(widget.timer);
  //   super.initState();
  //   startTimer();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.distance,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '${_start}s',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '${widget.profit} SAR',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 150,
            child: GoogleMap(
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(widget.pick.split(',')[0]),
                        double.parse(widget.pick.split(',')[1])),
                    zoom: 13.5),
                onMapCreated: onCreated,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                zoomControlsEnabled: false,
                onCameraMove: onCameraMove,
                markers: widget.markers,
                polylines: widget.polyLines,
                gestureRecognizers: Set()
                  ..add(Factory<PanGestureRecognizer>(
                          () => PanGestureRecognizer()))),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.all(5),
                child: Image.network(
                  widget.photo,
                  fit: BoxFit.fitWidth,
                  height: double.infinity,
                  width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff3c2c63)),
                          value: loadingProgress.expectedTotalBytes != null
                              ? (loadingProgress.cumulativeBytesLoaded ?? 0) /
                              (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 12.5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.customer,
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.branch,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    Text(
                      widget.pickText,
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.date,
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: 7.5,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        globals.loc == 'en' ? 'Store Note:' : 'ملاحظات المتجر:',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 7.5,
                      ),
                      Text(
                        widget.notes,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.5,
          ),
          load
              ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor:
              new AlwaysStoppedAnimation<Color>(Color(0xff3c2c63)),
            ),
          )
              : Row(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: widget.onAcceptOrder,
//                       onTap: () async {
//                         setState(() {
//                           load = true;
//                         });
//                         String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <AcceptOrderV2 xmlns="http://Mgra.WS/">
//       <ID>${widget.id}</ID>
//       <DriverID>${widget.user.id}</DriverID>
//     </AcceptOrderV2>
//   </soap:Body>
// </soap:Envelope>''';
//                         http.Response response = await http
//                             .post(
//                                 Uri.parse(
//                                     'http://tryconnect.net/api/MgraWebService.asmx'),
//                                 headers: {
//                                   "SOAPAction": "http://Mgra.WS/AcceptOrderV2",
//                                   "Content-Type": "text/xml;charset=UTF-8",
//                                 },
//                                 body: utf8.encode(soap),
//                                 encoding: Encoding.getByName("UTF-8"))
//                             .then((onValue) {
//                           return onValue;
//                         });
//                         print(response.body);
//                         if (response.statusCode == 200) {
//                           String json = parse(response.body)
//                               .getElementsByTagName('AcceptOrderV2Result')[0]
//                               .text;
//                           final decoded = jsonDecode(json);
//
//                           SharedPreferences prefs =
//                               await SharedPreferences.getInstance();
//                           prefs.setString('ColorStatus', "3");
//
//                           setState(() {
//                             load = false;
//                           });
//                           showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (context) => WillPopScope(
//                                     onWillPop: () async {
//                                       final key = GlobalKey<FrontPageState>();
//
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => FrontPage(
//                                                     key: key,
//                                                     tab: 1,
//                                                     user: user,
//                                                   )));
//                                       return true;
//                                     },
//                                     child: Dialog(
//                                       child: Container(
//                                         padding: EdgeInsets.all(12.5),
//                                         color: Colors.white,
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             GestureDetector(
//                                               onTap: () {
//                                                 setState(() {});
//                                                 final key =
//                                                     GlobalKey<FrontPageState>();
//
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             FrontPage(
//                                                               key: key,
//                                                               tab: 1,
//                                                               user: user,
//                                                             )));
//                                               },
//                                               child: Container(
//                                                 decoration: BoxDecoration(),
//                                                 child: Icon(
//                                                   Icons.close,
//                                                   color: Colors.black,
//                                                   size: 26,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               decoded,
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ));
//                         }
//                       },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xff0e8f13),
                      ),
                      child: Text(
                        globals.loc == 'en' ? 'Accept' : 'موافق',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        load = true;
                      });
                      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CancelOrderV2 xmlns="http://Mgra.WS/">
      <OrderID>${widget.id}</OrderID>
      <DriverID>${widget.user.id}</DriverID>
      <Type>${widget.type}</Type>
    </CancelOrderV2>
  </soap:Body>
</soap:Envelope>''';
                      http.Response response = await http
                          .post(
                          Uri.parse(
                              'http://tryconnect.net/api/MgraWebService.asmx'),
                          headers: {
                            "SOAPAction": "http://Mgra.WS/CancelOrderV2",
                            "Content-Type": "text/xml;charset=UTF-8",
                          },
                          body: utf8.encode(soap),
                          encoding: Encoding.getByName("UTF-8"))
                          .then((onValue) {
                        return onValue;
                      });
                      print(response.body);
                      if (response.statusCode == 200) {
                        String json = parse(response.body)
                            .getElementsByTagName('CancelOrderV2Result')[0]
                            .text;
                        final decoded = jsonDecode(json);
                        setState(() {
                          load = false;
                        });
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                WillPopScope(
                                  onWillPop: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Wrapper()));
                                    return true;
                                  },
                                  child: Dialog(
                                    child: Container(
                                      padding: EdgeInsets.all(12.5),
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Wrapper()));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            decoded,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      }
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xffb81818),
                      ),
                      child: Text(
                        globals.loc == 'en' ? 'Reject' : 'رفض',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  void onCameraMove(CameraPosition position) {}

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }
}

class ProgressV2 extends StatefulWidget {
  final String id;
  final String distance;
  final String profit;
  final String photo;
  final String pickText;
  final String customer;
  final String status;
  final String type;
  final User user;
  final String pickAddress;
  final String branch;

  ProgressV2({required this.customer,
    required this.user,
    required this.type,
    required this.distance,
    required this.id,
    required this.photo,
    required this.pickText,
    required this.profit,
    required this.pickAddress,
    required this.status,
    required this.branch});

  @override
  _ProgressV2State createState() => _ProgressV2State();
}

class _ProgressV2State extends State<ProgressV2> {
  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.distance,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '#${widget.id}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '${widget.profit} SAR',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Divider(
            color: Colors.black,
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        globals.loc == 'en'
                            ? 'Pickup Location'
                            : 'موقع الاستلام',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.all(5),
                      child: Image.network(
                        widget.photo,
                        fit: BoxFit.fitWidth,
                        height: double.infinity,
                        width: double.infinity,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xff3c2c63)),
                                value: loadingProgress.expectedTotalBytes !=
                                    null
                                    ? (loadingProgress.cumulativeBytesLoaded ??
                                    0) /
                                    (loadingProgress.expectedTotalBytes ??
                                        1)
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 12.5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.customer,
                            style: TextStyle(fontSize: 13),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.branch,
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 7.5,
                          ),
                          GestureDetector(
                            onTap: () =>
                                openMap(
                                    double.parse(
                                        widget.pickAddress.split(',')[0]),
                                    double.parse(
                                        widget.pickAddress.split(',')[1])),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Text(
                                widget.pickText,
                                style:
                                TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () =>
                          openMap(
                              double.parse(widget.pickAddress.split(',')[0]),
                              double.parse(widget.pickAddress.split(',')[1])),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(),
                        child: Image.asset('assets/location.png',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fitWidth),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.5,
          ),
          Row(
            children: [
              Expanded(
                child: Text(globals.loc == 'en'
                    ? 'Status: ${widget.status}'
                    : 'الحالة: ${widget.status}'),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderDetails(
                                  user: widget.user, orderid: widget.id)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff12a18f),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    globals.loc == 'en' ? 'Order Details' : 'تفاصيل الطلب',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class AllV2 extends StatefulWidget {
  final String no;
  final String id;
  final String amount;
  final String status;
  final User user;

  AllV2({required this.amount,
    required this.user,
    required this.id,
    required this.no,
    required this.status});

  @override
  _AllV2State createState() => _AllV2State();
}

class _AllV2State extends State<AllV2> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.5),
      child: ExpansionTile(
        title: isExpanded
            ? Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(globals.loc == 'en' ? 'No' : 'الرقم',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 5),
                  Text(widget.no,
                      style: TextStyle(color: Colors.black, fontSize: 13))
                ],
              ),
            ),
            SizedBox(width: 7.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(globals.loc == 'en' ? 'OrderID' : 'رقم الطلب',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 5),
                  Text(widget.id,
                      style: TextStyle(color: Colors.black, fontSize: 13))
                ],
              ),
            ),
            SizedBox(width: 7.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(globals.loc == 'en' ? 'Amount' : 'المبلغ',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 5),
                  Text(widget.amount,
                      style: TextStyle(color: Colors.black, fontSize: 13))
                ],
              ),
            ),
            SizedBox(width: 7.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(globals.loc == 'en' ? 'Status' : 'الحالة',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 5),
                  Text(widget.status,
                      style: TextStyle(color: Colors.black, fontSize: 13))
                ],
              ),
            )
          ],
        )
            : Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.no,
                      style: TextStyle(fontSize: 13, color: Colors.black))
                ],
              ),
            ),
            SizedBox(width: 7.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.id,
                      style: TextStyle(fontSize: 13, color: Colors.black))
                ],
              ),
            ),
            SizedBox(width: 7.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.amount,
                      style: TextStyle(fontSize: 13, color: Colors.black))
                ],
              ),
            ),
            SizedBox(width: 7.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.status,
                      style: TextStyle(fontSize: 13, color: Colors.black))
                ],
              ),
            )
          ],
        ),
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 10),
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        trailing: Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: Colors.black),
        children: [
          GestureDetector(
            onTap: () {
              final orderController = Get.put(OrderController());
              orderController.driverGetOrderByID(widget.id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrderDetails(user: widget.user, orderid: widget.id)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xff12a18f),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    globals.loc == 'en' ? 'Order Details' : 'تفاصيل الطلب',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
