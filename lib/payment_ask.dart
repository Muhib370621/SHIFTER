import 'package:flutter/material.dart';
import 'package:shifter/user.dart';
import 'package:shifter/wrapper.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class PaymentAsk extends StatefulWidget {
  final String orderId;
  final User user;
  final String type;
  final String sms;

  PaymentAsk(
      {required this.orderId,
      required this.user,
      required this.type,
      required this.sms});
  @override
  _PaymentAskState createState() => _PaymentAskState();
}

class _PaymentAskState extends State<PaymentAsk> {
  String loc="";
  @override
  void initState() {
    loc = globals.loc??'';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
        return true;
      },
      child: Directionality(
        textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: AppBar(
                backgroundColor: Color(0xff3c2c63),
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              loc == 'en' ? 'Payment' : 'دفع',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              endIndent:
                                  MediaQuery.of(context).size.width / 1.30,
                              color: Colors.white,
                              thickness: 2.0,
                            ),
                            SizedBox(
                              height: 7,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.sms),
                SizedBox(
                  height: 15,
                ),
               ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.blue,
                                        
                                      ),
                  onPressed: () async {
                    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <TakeCash xmlns="http://Mgra.WS/">
        <OrderID>${widget.orderId}</OrderID>
        <DriverID>${widget.user.id}</DriverID>
        <OrderType>${widget.type}</OrderType>
        <Status>1</Status>
    </TakeCash>
  </soap:Body>
</soap:Envelope>''';
                    http.Response response = await http
                        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                            headers: {
                              "SOAPAction": "http://Mgra.WS/TakeCash",
                              "Content-Type": "text/xml;charset=UTF-8",
                            },
                            body: utf8.encode(soap),
                            encoding: Encoding.getByName("UTF-8"))
                        .then((onValue) {
                      return onValue;
                    });
                    String json = parse(response.body)
                        .getElementsByTagName('TakeCashResult')[0]
                        .text;
                    if (json != "1") {
                    /*   _scaffoldKey.currentState
                          .showSnackBar(SnackBar(content: Text(json))); */
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Wrapper()));
                    }
                  },
                  child: Text(
                    loc == 'en' ? 'Yes' : 'نعم',
                    style: TextStyle(color: Colors.white),
                  ),
                  
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor:  Colors.blue,
                                      ),
                  onPressed: () async {
                    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <TakeCash xmlns="http://Mgra.WS/">
        <OrderID>${widget.orderId}</OrderID>
        <DriverID>${widget.user.id}</DriverID>
        <OrderType>${widget.type}</OrderType>
        <Status>0</Status>
    </TakeCash>
  </soap:Body>
</soap:Envelope>''';
                    http.Response response = await http
                        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                            headers: {
                              "SOAPAction": "http://Mgra.WS/TakeCash",
                              "Content-Type": "text/xml;charset=UTF-8",
                            },
                            body: utf8.encode(soap),
                            encoding: Encoding.getByName("UTF-8"))
                        .then((onValue) {
                      return onValue;
                    });
                    String json = parse(response.body)
                        .getElementsByTagName('TakeCashResult')[0]
                        .text;
                    if (json != "1") {
                    /*   _scaffoldKey.currentState
                          .showSnackBar(SnackBar(content: Text(json))); */
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Wrapper()));
                    }
                  },
                  child: Text(
                    loc == 'en' ? 'No' : 'لا',
                    style: TextStyle(color: Colors.white),
                  ),
                
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
