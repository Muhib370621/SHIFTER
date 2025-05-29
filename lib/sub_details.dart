import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shifter/user.dart';
import 'package:location/location.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as GEO;
import 'help_one.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class SubDetails extends StatefulWidget {
  final User user;
  final String id ;
  SubDetails({required this.user, required this.id});
  @override
  _SubDetailsState createState() => _SubDetailsState();
}

class _SubDetailsState extends State<SubDetails> {
  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  bool sent = false;
  late Location location;
  String addressText="";
  static LatLng _initialPosition= LatLng(0.0, 0.0);
  bool locationServiceActive = true;

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

   // globals.directions = MapboxNavigation();
  }

  void _getUserLocation() async {
    GEO.Position position = await GEO.Geolocator
        .getCurrentPosition(desiredAccuracy: GEO.LocationAccuracy.high);

        
    _initialPosition = LatLng(position.latitude, position.longitude);
    

    /*  heba comment
    List<GEO.Placemark> placemark = await GEO.Geolocator()
        .placemarkFromCoordinates(
            _initialPosition.latitude, _initialPosition.longitude);


    addressText = placemark[0].name; */
    setState(() {});
  }

  void _loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 5)).then((v) {
      
    });
  }

  // List<StatusWidget> status = <StatusWidget>[];
  String name = '';
  String orderno = '';
  String details = '';
  String flag = '';
  String profit = '';
  String cf = '0';
  String payment = "";
  String price = "";
  String phone = "";

  String loc="";
  loadData() async {
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetSubOrderByID xmlns="http://Mgra.WS/">
      <ID>${widget.id}</ID>
      <DriverID>${widget.user.id}</DriverID>
      <language>${loc.toUpperCase()}</language>

    </GetSubOrderByID>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/GetSubOrderByID",
              "Content-Type": "text/xml;charset=UTF-8",
            },
            body: utf8.encode(soap),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    String json = parse(response.body)
        .getElementsByTagName('GetSubOrderByIDResult')[0]
        .text;
    final decoded = jsonDecode(json);
    name = decoded['Name'];
    orderno = decoded['OrderNo'];
    details = decoded['Details'];
    flag = decoded['ViewFlag'];
    profit = decoded['Profit'];
    cf = decoded['Completeflag'];
    payment = decoded['paymenttype'];
    price = decoded['price'];
    phone = decoded['phone'];

    setState(() {});
  }

  @override
  void initState() {
    loc = globals.loc??'';
    super.initState();
    initPlatformState();
    loadData();

    _getUserLocation();
    _loadingInitialPosition();
    location = new Location();
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null
        ? Scaffold(
            body: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitRotatingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: locationServiceActive == false,
                  child: Text(
                    loc == 'en'
                        ? "Please enable location services!"
                        : "الرجاء تفعيل الموقع!",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                )
              ],
            )),
          )
        : Directionality(
            textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
            child: Scaffold(
              key: _scaffoldKey,
              body: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                    bottom: 20,
                    top: MediaQuery.of(context).padding.top + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$name',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('#' + '${widget.id}',
                          style: TextStyle(fontSize: 24, color: Colors.grey)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      loc == 'en' ? 'Details' : 'ملاحظات',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$details',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          loc == 'en' ? 'Invoice No.' : 'رقم الفاتورة',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          '$orderno',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          loc == 'en' ? 'Recipient Mobile' : 'هاتف المستلم',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                            onTap: () => launch("tel://" + '$phone'),
                            child: new Text(
                              '$phone',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          loc == 'en' ? 'Payment method' : 'طريقة الدفع',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text('$payment'),
                        )
                      ],
                    ),
                    price == '0'
                        ? Container()
                        : SizedBox(
                            height: 5,
                          ),
                    price == '0'
                        ? Container()
                        : Row(
                            children: [
                              Text(
                                loc == 'en'
                                    ? 'Collection amount'
                                    : 'مبلغ التحصيل',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(loc == 'en'
                                    ? '$price' + 'R.S'
                                    : '$price' + ' ر.س '),
                              )
                            ],
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          loc == 'en' ? 'Profit' : 'الربح',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(loc == 'en'
                              ? '$profit' + 'R.S'
                              : '$profit' + ' ر.س '),
                        )
                      ],
                    ),
                    flag == '0'
                        ? Container()
                        : SizedBox(
                            height: 20,
                          ),
                    flag == '0'
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              String soap =
                                  '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <StartOrder xmlns="http://Mgra.WS/">
      <ID>${widget.id}</ID>
      <DriverID>${widget.user.id}</DriverID>

    </StartOrder>
  </soap:Body>
</soap:Envelope>''';
                              http.Response response = await http
                                  .post(
                                      Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                      headers: {
                                        "SOAPAction":
                                            "http://Mgra.WS/StartOrder",
                                        "Content-Type":
                                            "text/xml;charset=UTF-8",
                                      },
                                      body: utf8.encode(soap),
                                      encoding: Encoding.getByName("UTF-8"))
                                  .then((onValue) {
                                return onValue;
                              });
                              String json = parse(response.body)
                                  .getElementsByTagName('StartOrderResult')[0]
                                  .text;
                              final decoded = jsonDecode(json);
                              if (decoded['DropoffAddval']
                                  .toString()
                                  .contains(',')) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString('ColorStatus', '4');

                                double _distanceInMeters =
                                    await GEO.Geolocator.distanceBetween(
                                  _initialPosition.latitude,
                                  _initialPosition.longitude,
                                  double.parse(
                                      decoded['DropoffAddval'].split(',')[0]),
                                  double.parse(
                                      decoded['DropoffAddval'].split(',')[1]),
                                );
                                print('Distance is: $_distanceInMeters');
                                if (_distanceInMeters > 50) {
                                /* heba comment
                                  location
                                      .onLocationChanged()
                                      .listen((LocationData cLoc) async {
                                    double distanceInMeters =
                                        await GEO.Geolocator.distanceBetween(
                                      cLoc.latitude,
                                      cLoc.longitude,
                                      double.parse(decoded['DropoffAddval']
                                          .split(',')[0]),
                                      double.parse(decoded['DropoffAddval']
                                          .split(',')[1]),
                                        );
                                 
                                    if (distanceInMeters <= 50) {
                                      if (sent == false) {
                                        sent = true;
                                        // _showNotificationWithDefaultSound(
                                        //     loc == 'en'
                                        //         ? 'You have reached your destination'
                                        //         : 'لقد وصلت إلى وجهتك',
                                        //     loc == 'en'
                                        //         ? 'Tap to close the order'
                                        //         : 'اضغط لإغلاق الطلب');
                                        Future.delayed(Duration(seconds: 7),
                                            () async {
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(globals.loc ==
                                                          'en'
                                                      ? 'Do you want to close the order'
                                                      : 'هل تريد انهاء الطلب'),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text(
                                                          globals.loc == 'en'
                                                              ? 'Yes'
                                                              : 'نعم'),
                                                      onPressed: () async {
                                                        String soap =
                                                            '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CompleteOrder xmlns="http://Mgra.WS/">
      <OrderID>${widget.id}</OrderID>
      <DriverID>${widget.user.id}</DriverID>
    </CompleteOrder>
  </soap:Body>
</soap:Envelope>''';
                                                        http.Response response =
                                                            await http
                                                                .post(
                                                                    Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                                                    headers: {
                                                                      "SOAPAction":
                                                                          "http://Mgra.WS/CompleteOrder",
                                                                      "Content-Type":
                                                                          "text/xml;charset=UTF-8",
                                                                    },
                                                                    body: utf8
                                                                        .encode(
                                                                            soap),
                                                                    encoding: Encoding
                                                                        .getByName(
                                                                            "UTF-8"))
                                                                .then(
                                                                    (onValue) {
                                                          return onValue;
                                                        });

                                                        String json = parse(
                                                                response.body)
                                                            .getElementsByTagName(
                                                                'CompleteOrderResult')[0]
                                                            .text;

                                                        if (json != "1" &&
                                                            json != "2" &&
                                                            json != "3" &&
                                                            json != "4") {
                                                         /*  _scaffoldKey
                                                              .currentState
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      json))); */
                                                        } else {
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();

                                                          prefs.setString(
                                                              'ColorStatus', json);

                                                              
                                                        }
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                          /*  await globals.directions
                                              .finishNavigation(); */
                                        });
                                      }
                                    }
                                  }); */
                                } else {
                                  if (sent == false) {
                                    sent = true;
                                    // _showNotificationWithDefaultSound(
                                    //     loc == 'en'
                                    //         ? 'You have reached your destination'
                                    //         : 'لقد وصلت إلى وجهتك',
                                    //     loc == 'en'
                                    //         ? 'Tap to close the order'
                                    //         : 'اضغط لإغلاق الطلب');
                                    Future.delayed(Duration(seconds: 7),
                                        () async {
                                      Future.delayed(Duration(seconds: 3), () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(globals.loc == 'en'
                                                  ? 'Do you want to close the order'
                                                  : 'هل تريد انهاء الطلب'),
                                              actions: [
                                                ElevatedButton(
                                      
                                                  child: Text(
                                                      globals.loc == 'en'
                                                          ? 'Yes'
                                                          : 'نعم'),
                                                  onPressed: () async {
                                                    String soap =
                                                        '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CompleteOrder xmlns="http://Mgra.WS/">
      <OrderID>${widget.id}</OrderID>
      <DriverID>${widget.user.id}</DriverID>

    </CompleteOrder>
  </soap:Body>
</soap:Envelope>''';
                                                    http.Response response =
                                                        await http
                                                            .post(
                                                                Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                                                headers: {
                                                                  "SOAPAction":
                                                                      "http://Mgra.WS/CompleteOrder",
                                                                  "Content-Type":
                                                                      "text/xml;charset=UTF-8",
                                                                },
                                                                body:
                                                                    utf8.encode(
                                                                        soap),
                                                                encoding: Encoding
                                                                    .getByName(
                                                                        "UTF-8"))
                                                            .then((onValue) {
                                                      return onValue;
                                                    });

                                                    String json = parse(
                                                            response.body)
                                                        .getElementsByTagName(
                                                            'CompleteOrderResult')[0]
                                                        .text;

                                                    if (decoded["sms"] != "1") {
                                                    /*   _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      json))); */
                                                    } else {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();


                                                      prefs.setString('ColorStatus',
                                                          decoded["statusval"]);
                                                    }
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      });
                                     /*  await globals.directions
                                          .finishNavigation(); */
                                    });
                                  }
                                }
                                openMap(_initialPosition.latitude,
                                    _initialPosition.longitude);
                                /*  await globals.directions.startNavigation(
                                    origin: WayPoint(
                                        name: "$addressText",
                                        latitude: _initialPosition.latitude,
                                        longitude: _initialPosition.longitude),
                                    destination: WayPoint(
                                        name: "${decoded['DropoffAddtxt']}",
                                        latitude: double.parse(
                                            decoded['DropoffAddval']
                                                .split(',')[0]),
                                        longitude: double.parse(
                                            decoded['DropoffAddval']
                                                .split(',')[1])),
                                    mode:
                                        MapBoxNavigationMode.drivingWithTraffic,
                                    simulateRoute: false,
                                    units: VoiceUnits.metric); */
                              } else {
                               /*  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(decoded['DropoffAddval']))); */
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 70),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration:
                                    BoxDecoration(color: Colors.blue[300]),
                                child: Center(
                                    child: Text(
                                  loc == 'en' ? 'Start Order' : 'بدأ التوصيل',
                                  style: TextStyle(color: Colors.white),
                                ))),
                          ),
                    flag == '0'
                        ? Container()
                        : SizedBox(
                            height: 20,
                          ),
                    Divider(),
                    flag == '0'
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WillPopScope(
                                      onWillPop: () async => false,
                                      child: HelpOne(
                                          user: widget.user,
                                          orderid: widget.id),
                                    ),
                                  ));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(children: [
                                Expanded(
                                  child: Text(loc == 'en'
                                      ? 'Help Center?'
                                      : 'طلب مساعدة؟'),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.help,
                                  color: Colors.black,
                                )
                              ]),
                            ),
                          ),
                    Divider(),
                    cf == '0'
                        ? Container()
                        : SizedBox(
                            height: 10,
                          ),
                    cf == '0'
                        ? Container()
                        : Row(
                            children: [
                              Expanded(
                                  child: Text(loc == 'en'
                                      ? 'Order has been delivered?'
                                      : 'هل تم تسليم الطلب؟')),
                              SizedBox(
                                width: 15,
                              ),
                              ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                         backgroundColor: Colors.blue
                                      ),
                                onPressed: () async {
                                  String soap =
                                      '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CompleteOrder xmlns="http://Mgra.WS/">
      <OrderID>${widget.id}</OrderID>
      <DriverID>${widget.user.id}</DriverID>

    </CompleteOrder>
  </soap:Body>
</soap:Envelope>''';
                                  http.Response response = await http
                                      .post(
                                          Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                          headers: {
                                            "SOAPAction":
                                                "http://Mgra.WS/CompleteOrder",
                                            "Content-Type":
                                                "text/xml;charset=UTF-8",
                                          },
                                          body: utf8.encode(soap),
                                          encoding: Encoding.getByName("UTF-8"))
                                      .then((onValue) {
                                    return onValue;
                                  });
                                  String json = parse(response.body)
                                      .getElementsByTagName(
                                          'CompleteOrderResult')[0]
                                      .text;

                                  final decoded = jsonDecode(json);
                                
                                  if (decoded["sms"] != "1") {
                                  /*   _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            content: Text(decoded["sms"])));
 */
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    prefs.setString(
                                        'ColorStatus', decoded["status"]);
                                  }
                                },
                                child: Text(
                                  loc == 'en' ? 'Yes' : 'نعم',
                                  style: TextStyle(color: Colors.white),
                                ),
                              
                              )
                            ],
                          )
                  ],
                ),
              ),
            ),
          );
  }
}
