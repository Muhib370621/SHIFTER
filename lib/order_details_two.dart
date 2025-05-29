import 'package:flutter/material.dart';
import 'package:shifter/sub_details.dart';
import 'package:shifter/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsTwo extends StatefulWidget {
  final String orderid;

  final User user;
  OrderDetailsTwo({required this.user, this.orderid=""});
  @override
  _OrderDetailsTwoState createState() => _OrderDetailsTwoState();
}

class _OrderDetailsTwoState extends State<OrderDetailsTwo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String loc="";
  String id="",
      pickName="",
      pickLoc="",
      pickVal="",
      pickPhoto="",
      ordersCount="",
      deliveryAmount="",
      status="",
      available="",
      branch="",
      branchphone="",
      level="";
  List<SubOrderWidget> subOrder = <SubOrderWidget>[];
  String addressText="";
  bool locationServiceActive = true;

  loadData() async {
    subOrder = [];
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetOrdersByGroup xmlns="http://Mgra.WS/">
      <ID>${widget.orderid}</ID>
      <language>${loc.toUpperCase()}</language>
      <DriverID>${widget.user.id}</DriverID>
    </GetOrdersByGroup>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/GetOrdersByGroup",
              "Content-Type": "text/xml;charset=UTF-8",
            },
            body: utf8.encode(soap),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    String json = parse(response.body)
        .getElementsByTagName('GetOrdersByGroupResult')[0]
        .text;
    final decoded = jsonDecode(json);
    print(decoded);
    id = decoded['ID'].toString();
    status = decoded['Status'];
    pickName = decoded['PickName'];
    pickLoc = decoded['PickAddressText'];
    pickVal = decoded['PickAddressValue'];
    pickPhoto = decoded['PickPhoto'];
    ordersCount = decoded['OrdersCount'];
    deliveryAmount = decoded['DeliveryAmount'];
    available = decoded['Available'];
    branch = decoded['branch'];
    branchphone = decoded['branchphone'];
    level = decoded['level'];

    for (int i = 0; i < decoded['SubOrder'].length; i++) {
      subOrder.add(SubOrderWidget(
        user: widget.user,
        billNo: decoded['SubOrder'][i]['BillingNo'],
        id: decoded['SubOrder'][i]['ID'].toString(),
        name: decoded['SubOrder'][i]['DropName'],
        text: decoded['SubOrder'][i]['DropAddressText'],
        value: decoded['SubOrder'][i]['DropAddressValue'],
        pay: decoded['SubOrder'][i]['PaymentMethod'],
        notes: decoded['SubOrder'][i]['Notes'],
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    loc = globals.loc??'';
    super.initState();
    loadData();
  }

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
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          //heba comment
         /*  Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Orders(user: widget.user, interval: '0'))); */
          return true;
        },
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: AppBar(
                  backgroundColor: Color(0xff3c2c63),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                loc == 'en' ? 'Order Details' : 'تفاصيل الطلب',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                endIndent:
                                    MediaQuery.of(context).size.width / 1.55,
                                color: Colors.white,
                                thickness: 2.0,
                              ),
                              SizedBox(
                                height: 7,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(),
                                child: Icon(Icons.arrow_forward,
                                    color: Colors.white)))
                      ],
                    ),
                  ),
                )),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset('assets/Call.png', height: 50, width: 50),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          '$pickName',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => openMap(
                            double.parse(pickVal.split(',')[0]),
                            double.parse(pickVal.split(',')[1])),
                        child: Icon(
                          MdiIcons.mapMarkerRadius,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$branch',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                                onTap: () => launch("tel://" + '$branchphone'),
                                child: new Text(
                                  '$branchphone',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () => openMap(
                                  double.parse(pickVal.split(',')[0]),
                                  double.parse(pickVal.split(',')[1])),
                              child: Text(
                                '$pickLoc',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  level == '0' ? Container() : Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  level == '1'
                      ? Row(children: <Widget>[
                          GestureDetector(
                            child: Text(
                                loc == 'en'
                                    ? 'Have you reached the store?'
                                    : 'هل وصلت الى المتجر؟',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30)),
                                          
                                      ),
                            onPressed: () async {
                              String soap =
                                  '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ReachStoreOrder xmlns="http://Mgra.WS/">
        <ID>${widget.orderid}</ID>
    </ReachStoreOrder>
  </soap:Body>
</soap:Envelope>''';
                              http.Response response = await http
                                  .post(
                                      Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                      headers: {
                                        "SOAPAction":
                                            "http://Mgra.WS/ReachStoreOrder",
                                        "Content-Type":
                                            "text/xml;charset=UTF-8",
                                      },
                                      body: utf8.encode(soap),
                                      encoding: Encoding.getByName("UTF-8"))
                                  .then((onValue) {
                                return onValue;
                              });

                             /*  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      loc == 'en' ? 'Thank You' : "شكرا لك."))); */

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('ColorStatus', "3");
                              await Future.delayed(Duration(seconds: 2))
                                  .then((v) {
                                setState(() {
                                  level = "2";
                                });
                              });
                            },
                            
                            child:
                                Text(loc == 'en' ? 'Yes' : "نعم".toUpperCase()),
                           
                          ),
                        ])
                      : Container(),
                  level == '2'
                      ? Row(children: <Widget>[
                          GestureDetector(
                            child: Text(
                                loc == 'en'
                                    ? 'Did you leave the store?'
                                    : 'هل غادرت المتجر؟',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30)),
                                         
                                      ),
                            onPressed: () async {
                              String soap =
                                  '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <LeaveStoreOrder xmlns="http://Mgra.WS/">
        <ID>${widget.orderid}</ID>
    </LeaveStoreOrder>
  </soap:Body>
</soap:Envelope>''';
                              http.Response response = await http
                                  .post(
                                      Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                      headers: {
                                        "SOAPAction":
                                            "http://Mgra.WS/LeaveStoreOrder",
                                        "Content-Type":
                                            "text/xml;charset=UTF-8",
                                      },
                                      body: utf8.encode(soap),
                                      encoding: Encoding.getByName("UTF-8"))
                                  .then((onValue) {
                                return onValue;
                              });
                             /*  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      loc == 'en' ? 'Thank You' : "شكرا لك.")));
 */
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('ColorStatus', "4");
                              await Future.delayed(Duration(seconds: 2))
                                  .then((v) {
                                setState(() {
                                  level = "0";
                                });
                              });
                            },
                           
                            child:
                                Text(loc == 'en' ? 'Yes' : "نعم".toUpperCase()),
                           
                          ),
                        ])
                      : Container(),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: Text(loc == 'en'
                        ? '$ordersCount Orders'
                        : '$ordersCount طلبات'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: subOrder.length,
                      itemBuilder: (context, index) {
                        return subOrder[index];
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  status == '0'
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
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
                                  http.Response response = await http
                                      .post(
                                          Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                          headers: {
                                            "SOAPAction":
                                                "http://Mgra.WS/AcceptOrder",
                                            "Content-Type":
                                                "text/xml;charset=UTF-8",
                                          },
                                          body: utf8.encode(soap),
                                          encoding: Encoding.getByName("UTF-8"))
                                      .then((onValue) {
                                    return onValue;
                                  });
                                  Navigator.pop(context);
                                 /* heba comment
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Orders(
                                              user: widget.user,
                                              interval: '0'))); */
                                },
                                child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                        child: Text(
                                      loc == 'en' ? 'Accept' : 'موافق',
                                      style: TextStyle(color: Colors.white),
                                    ))),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                        child: Text(
                                      loc == 'en' ? 'Close' : 'اغلاق',
                                      style: TextStyle(color: Colors.white),
                                    ))),
                              ),
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            )),
      ),
    );
  }
}

class SubOrderWidget extends StatelessWidget {
  final User user;
  final String id, name, text, value, pay, billNo, notes;
  SubOrderWidget(
      {this.billNo="",
      required this.user,
      this.id="",
      this.name="",
      this.notes="",
      this.pay="",
      this.text="",
      this.value=""});
  @override
  Widget build(BuildContext context) {
    Future<void> openMap(double latitude, double longitude) async {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not open the map.';
      }
    }

    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 7.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => openMap(double.parse(value.split(',')[0]),
                            double.parse(value.split(',')[1])),
                        child: Icon(
                          MdiIcons.mapMarkerRadius,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          '$text',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(children: <Widget>[
            Text(
              '#' + '$id',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubDetails(
                        user: user,
                        id: id,
                      ),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(child: Icon(Icons.more_vert)),
              ),
            ),
          ])
        ],
      ),
      Divider(),
    ]);
  }
}
