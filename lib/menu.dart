import 'dart:async';
import 'dart:convert';
import 'package:shifter/front_page.dart';
import 'package:shifter/loading.dart';
import 'package:shifter/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shifter/account.dart';
import 'package:shifter/earnings_main.dart';
import 'package:shifter/incoming_messages.dart';
import 'package:shifter/user.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class Menu extends StatefulWidget {
  final User user;
  Menu({required this.user});
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String loc="";
  String active = '0';
  bool load = false;
  double rating = 0.0;
  String read="";
  void driverRate() async {
    String soap2 = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getdriverrate xmlns="http://Mgra.WS/">
      <ID>${widget.user.id}</ID>
    </getdriverrate>
  </soap:Body>
</soap:Envelope>''';
    http.Response response2 = await http
        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/getdriverrate",
              "Content-Type": "text/xml;charset=UTF-8",
            },
            body: utf8.encode(soap2),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    String json = parse(response2.body)
        .getElementsByTagName('getdriverrateResult')[0]
        .text;
    final decoded = jsonDecode(json);
    print(decoded);
    rating = double.parse(decoded['rate']);
    read = decoded['notcount'];

    setState(() {});
  }

  void checkActive() async {
    setState(() {
      load = true;
    });
    String soap2 = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CheckActive xmlns="http://Mgra.WS/">
      <UserID>${widget.user.id}</UserID>
      <Type>1</Type>
    </CheckActive>
  </soap:Body>
</soap:Envelope>''';
    http.Response response2 = await http
        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/CheckActive",
              "Content-Type": "text/xml;charset=UTF-8",
            },
            body: utf8.encode(soap2),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    String json =
        parse(response2.body).getElementsByTagName('CheckActiveResult')[0].text;
    final decoded = jsonDecode(json);
    active = decoded;
    print(active);
    if (active == '0') {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('Status', '0');
    }
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    loc = globals.loc??'';
    driverRate();
    checkActive();
    super.initState();
  }

  Future<void> addStringToSF(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Language', val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: load == true
          ? Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Loading()],
              ),
            )
          : Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 30,
                  left: 20,
                  right: 20),
              decoration: BoxDecoration(color: Colors.grey[100]),
              width: MediaQuery.of(context).size.width - 90,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        child: widget.user.photo!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.memory(
                                  base64Decode(widget.user.photo??""),
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              )
                            : Container(),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.user.firstName}' +
                                  ' ' +
                                  '${widget.user.lastName}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: SmoothStarRating(
                                rating: rating,
                               
                                size: 15,
                                borderColor: Colors.white,
                                color: Colors.yellow[700],
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                starCount: 5,
                                allowHalfRating: true,
                                spacing: 1.0,
                                onRatingChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IncomingMessages(
                                user: widget.user,
                              ),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Row(children: <Widget>[
                          Text(
                            loc == 'en' ? 'Incoming Messages' : 'البريد الوارد',
                            style: TextStyle(fontSize: 19),
                          ),
                          read == '0'
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      color: Color(0xfffae2e2),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: Text('$read'),
                                  ),
                                ),
                        ]),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (active == '1') {
                          final key = GlobalKey<FrontPageState>();
                          Navigator.push(
                              notifyContext,
                              MaterialPageRoute(
                                  builder: (context) => WillPopScope(
                                      onWillPop: () async => false,
                                      child: FrontPage(
                                        user: widget.user,
                                        tab: 0,
                                        key: key,
                                      ))));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  loc == 'en'
                                      ? 'Account is not active'
                                      : 'الحساب غير نشط',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Row(children: <Widget>[
                          Text(
                            loc == 'en' ? 'Orders' : 'الطلبات',
                            style: TextStyle(fontSize: 19),
                          ),
                        ]),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EarningsMain(
                                user: widget.user,
                              ),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Row(children: <Widget>[
                          Text(
                            loc == 'en' ? 'Income' : 'الدخل المالي',
                            style: TextStyle(fontSize: 19),
                          ),
                        ]),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Account(
                                user: widget.user,
                              ),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Row(children: <Widget>[
                          Text(
                            loc == 'en' ? 'Account Details' : 'بيانات الحساب',
                            style: TextStyle(fontSize: 17),
                          ),
                        ]),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      child: Container(
                    decoration: BoxDecoration(),
                    child: Row(children: <Widget>[
                      Text(
                        loc == 'en' ? 'Version 1.0.6' : 'نسخة 1.0.6',
                        style: TextStyle(fontSize: 17),
                      ),
                    ]),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  /*     GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpOne(
                                      user: widget.user,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Text(
                          loc == 'en' ? 'Help Center' : 'مركز المساعدة',
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
               */
                  Expanded(
                    child: Container(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await addStringToSF(loc == 'en' ? 'ar' : 'en');
                      globals.loc = loc == 'en' ? 'ar' : 'en';
                      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <UpdateLanguage xmlns="http://Mgra.WS/">
      <UserID>${widget.user.id}</UserID>
      <type>1</type>
      <language>${loc == 'en' ? '0' : '1'}</language>
    </UpdateLanguage>
  </soap:Body>
</soap:Envelope>''';
                      http.Response response = await http
                          .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                              headers: {
                                "SOAPAction": "http://Mgra.WS/UpdateLanguage",
                                "Content-Type": "text/xml;charset=UTF-8",
                              },
                              body: utf8.encode(soap),
                              encoding: Encoding.getByName("UTF-8"))
                          .then((onValue) {
                        return onValue;
                      });
                      print('${response.body}');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Wrapper()));
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xff2b2b2b),
                      ),
                      child: Center(
                          child: Text(
                        loc == 'en'
                            ? 'Switch to Arabic'
                            : 'التبديل إلى اللغة الإنجليزية',
                        style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
    );
  }
}
