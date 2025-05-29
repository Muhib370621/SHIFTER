
import 'package:flutter/material.dart';
import 'package:shifter/earning_icons_icons.dart';
import 'package:shifter/menu.dart';
import 'package:shifter/operations.dart';
import 'package:shifter/user.dart';
import 'package:shifter/weekly.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'globals.dart' as globals;

class EarningsMain extends StatefulWidget {
  final User user;
  EarningsMain({required this.user});
  @override
  _EarningsMainState createState() => _EarningsMainState();
}

class _EarningsMainState extends State<EarningsMain> with RouteAware {
  String loc="";
  String total = '';
  String lastTan = '';
  String interval = '';
  loadData() async {
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetWalletSummery xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
    </GetWalletSummery>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/GetWalletSummery",
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
          .getElementsByTagName('GetWalletSummeryResult')[0]
          .text;
      final decoded = jsonDecode(json);
      total = decoded['Total'];
      interval = decoded['Interval'];
      lastTan = decoded['LastTransaction'];
      setState(() {});
      this._overlayEntry.remove();
      this._overlayEntry = this._createOverlayEntry(context);
      Overlay.of(context).insert(this._overlayEntry);
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
        builder: (context) => Positioned(
              top: 230,
              width: MediaQuery.of(context).size.width,
              child: Directionality(
                textDirection:
                    loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Weekly(
                                      user: widget.user,
                                    ),
                                  ));
                            },
                            dense: true,
                            leading: Icon(
                              EarningIcons.earn_1,
                              size: 30,
                              color: Colors.blue[700],
                            ),
                            title: Text(
                              loc == 'en' ? 'Income Details' : 'تفاصيل الدخل',
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              '$interval',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Operations(
                                      user: widget.user,
                                    ),
                                  ));
                            },
                            dense: true,
                            title: Text(
                              loc == 'en'
                                  ? 'Latest Operations/Transfers'
                                  : 'أحدث العمليات/التحويلات',
                              style: TextStyle(fontSize: 14),
                            ),
                            leading: Icon(
                              EarningIcons.earn_2,
                              size: 30,
                              color: Colors.blue[700],
                            ),
                            subtitle: Text(
                              '$lastTan SAR Balance',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // routeObserver is the global variable we created before
    globals.routeObserver.subscribe(
  this,
  ModalRoute.of(context) as PageRoute<dynamic>,
);

  }

  @override
  void dispose() {
    globals.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
    print('Push');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._overlayEntry = this._createOverlayEntry(context);
      Overlay.of(context).insert(this._overlayEntry);
    });
  }

  @override
  void didPushNext() {
    // Route was pushed onto navigator and is now topmost route.
    print('Push Next');
    this._overlayEntry.remove();
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    print('Pop Next');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._overlayEntry = this._createOverlayEntry(context);
      Overlay.of(context).insert(this._overlayEntry);
    });
  }

  @override
  void didPop() {
    // Covering route was popped off the navigator.
    print('Pop');
    this._overlayEntry.remove();
  }

  @override
  void initState() {
    loc = globals.loc;
    super.initState();
    loadData();
  }

 late OverlayEntry _overlayEntry;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Menu(user: widget.user),
              ));
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 20,
                          right: 20),
                      color: Color(0xff2b2b2b),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      loc == 'en' ? 'Income' : 'الدخل',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Divider(
                                      endIndent:
                                          MediaQuery.of(context).size.width / 2,
                                      color: Colors.white,
                                      thickness: 2.0,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                              /*     GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      loc == 'en' ? 'Help?' : 'مساعدة؟',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                               */    SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Icon(Icons.arrow_forward,
                                            color: Colors.white),
                                      ))
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 55),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  loc == 'en' ? 'This Week' : 'هذا الأسبوع',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'SAR $total',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
