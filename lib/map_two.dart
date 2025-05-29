import 'dart:async';
import 'package:shifter/order_details_two.dart';
import 'package:shifter/wrapper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shifter/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'globals.dart' as globals;
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MapTwo extends StatefulWidget {
  final String orderid;
  final String type;
  final String custName;
  final String dropoff;
  final String timeSlot;
  final User user;
  final String ev;
  final String p;
  final String distance;
  MapTwo(
      {this.orderid ="",
      required this.user,
      @required this.distance ="",
      this.type="",
      this.custName="",
      this.dropoff="",
      this.timeSlot="",
      @required this.ev="",
      @required this.p=""});
  @override
  _MapTwoState createState() => _MapTwoState();
}

class _MapTwoState extends State<MapTwo> {
  String loc="";
  bool showButton = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static LatLng _initialPosition= LatLng(0.0, 0.0);
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  late BuildContext parentContext;
  late GoogleMapController _mapController;
  late Timer _timer;
  int _start = 30;

    loadStatus() async {
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CheckTime xmlns="http://Mgra.WS/">
      <OrderID>${widget.orderid}</OrderID>
      <DriverID>${widget.user.id}</DriverID>

    </CheckTime>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/CheckTime",
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
          .getElementsByTagName('CheckTimeResult')[0]
          .text;
      final decoded = jsonDecode(json);
      setState(() {
      _start = decoded;
        
      });
    }
  }


  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              showButton = false;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    loc = globals.loc??'';
    loadStatus();
    super.initState();
    _getUserLocation();
    _loadingInitialPosition();
  }

  void onCameraMove(CameraPosition position) {}
  void _getUserLocation() async {
    print("GET USER METHOD RUNNING =========");
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      startTimer();
    });
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }

//  LOADING INITIAL POSITION
  void _loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 5)).then((v) {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Wrapper(),
              ));
          return true;
        },
        child: SafeArea(
          child: _initialPosition == null
              ? Container(
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
                        "الرجاء تفعيل الموقع!",
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    )
                  ],
                ))
              : Stack(
                  children: <Widget>[
                    GoogleMap(
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target: _initialPosition, zoom: 17.0),
                        onMapCreated: onCreated,
                        myLocationEnabled: true,
                        mapType: MapType.normal,
                        compassEnabled: true,
                        zoomControlsEnabled: false,
                        onCameraMove: onCameraMove,
                        markers: _markers,
                        polylines: _polyLines),
                    widget.type == '1'
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () async {
                                String soap =
                                    '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CancelOrder xmlns="http://Mgra.WS/">
        <OrderID>${widget.orderid}</OrderID>
        <DriverID>${widget.user.id}</DriverID>
        <Type>${widget.type}</Type>
    </CancelOrder>
  </soap:Body>
</soap:Envelope>''';
                                http.Response response = await http
                                    .post(
                                        Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                        headers: {
                                          "SOAPAction":
                                              "http://Mgra.WS/CancelOrder",
                                          "Content-Type":
                                              "text/xml;charset=UTF-8",
                                        },
                                        body: utf8.encode(soap),
                                        encoding: Encoding.getByName("UTF-8"))
                                    .then((onValue) {
                                  return onValue;
                                });
                               /* heba comment
                                 Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Orders(user: widget.user, interval: '0',))); */
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20, top: 20),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xff3c2c63),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      loc == 'en' ? 'Close order' : 'رفض الطلب',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 15),
                                    Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 20, bottom: 20, right: 20),
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                        decoration: BoxDecoration(
                            color: widget.type == '1'
                                ? Color(0xff3c2c63)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: widget.type == '1'
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Text(
                                            loc == 'en' ? 'Profit' : 'الربح',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            widget.p,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Text(
                                            loc == 'en'
                                                ? 'Distance'
                                                : 'المسافة',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            widget.distance,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('توصيل',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      _start == 0
                                          ? Container(
                                              child: Expanded(
                                                child: Text(
                                                  loc == 'en'
                                                      ? 'Sorry! Time out'
                                                      : 'انتهى الوقت المعذرة',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                showButton
                                                    ? GestureDetector(
                                                        onTap: 
                                                        () async {
                                                          String soap =
                                                              '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <AcceptOrder xmlns="http://Mgra.WS/">
        <ID>${widget.orderid}</ID>
        <DriverID>${widget.user.id}</DriverID>
    </AcceptOrder>
  </soap:Body>
</soap:Envelope>''';
                                                          http.Response
                                                              response =
                                                              await http
                                                                  .post(
                                                                      Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                                                      headers: {
                                                                        "SOAPAction":
                                                                            "http://Mgra.WS/AcceptOrder",
                                                                        "Content-Type":
                                                                            "text/xml;charset=UTF-8",
                                                                      },
                                                                      body: utf8
                                                                          .encode(
                                                                              soap),
                                                                      encoding:
                                                                          Encoding.getByName(
                                                                              "UTF-8"))
                                                                  .then(
                                                                      (onValue) {
                                                            return onValue;
                                                          });
                                                          String json = parse(
                                                                  response.body)
                                                              .getElementsByTagName(
                                                                  'AcceptOrderResult')[0]
                                                              .text;
                                                          final decoded =
                                                              jsonDecode(json);
                                                          if (decoded == '1') {
                                                              SharedPreferences prefs = await SharedPreferences.getInstance();
    
                                                             prefs.setString('ColorStatus', '3');
                                                            Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            OrderDetailsTwo(
                                                                              user: widget.user,
                                                                              orderid: widget.orderid,
                                                                            )));
                                                          } else {
                                                            setState(() {
                                                              showButton =
                                                                  false;
                                                            });
                                                         /*    _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text(decoded))); */
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                          .blue,
                                                                  width: 2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: CircleAvatar(
                                                            radius: 30,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            child: Text(
                                                              '$_start',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text('دقائق',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15))
                                              ],
                                            ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text('توصيل',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ],
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Directionality(
                                  textDirection: loc == 'en'
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.blue,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${widget.custName}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Color(0xff25d8c2),
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                              child:
                                                  Text('${widget.timeSlot}')),
                                          GestureDetector(
                                            onTap: () {
                                             /* heba comment
                                               Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsOne(
                                                      user: widget.user,
                                                      orderid: widget.orderid,
                                                       ordertype: '2',

                                                    ),
                                                  )); */
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff25d8c2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Text(
                                                loc == 'en'
                                                    ? 'Order Details'
                                                    : 'تفاصيل الطلب',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11),
                                              )),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            loc == 'en'
                                                ? 'Delivery Address'
                                                : 'عنوان التسليم',
                                            style: TextStyle(
                                                color: Color(0xff25d8c2)),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${widget.dropoff}',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            loc == 'en'
                                                ? 'Expected Value'
                                                : 'القيمة المتوقعة',
                                            style: TextStyle(
                                                color: Color(0xff25d8c2)),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${widget.ev}',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    /*   Row(
                                        children: [
                                          Text(
                                            loc == 'en' ? 'Profit' : 'الربح',
                                            style: TextStyle(
                                                color: Color(0xff25d8c2)),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${widget.p}',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ), */
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
