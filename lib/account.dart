import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shifter/account_icons.dart' as AI;
import 'package:shifter/documents.dart';
import 'package:shifter/edit_account.dart';
import 'package:shifter/home.dart';
import 'package:shifter/payments.dart';
import 'package:shifter/user.dart';
import 'package:shifter/vehicles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class Account extends StatefulWidget {
  final User user;
  Account({required this.user});
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? loc;
  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("FirstName");
    prefs.remove("LastName");
    prefs.remove("Email");
    prefs.remove("Password");
    prefs.remove("ID");
    prefs.remove("Photo");
    prefs.remove("City");
    prefs.remove("PhoneNo");
  }

  @override
  void initState() {
    loc = globals.loc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
              backgroundColor: Color(0xff2b2b2b),
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
                            loc == 'en' ? 'Account' : 'الحساب',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            endIndent: MediaQuery.of(context).size.width / 1.55,
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
                            child:
                                Icon(Icons.arrow_forward, color: Colors.white)))
                  ],
                ),
              ),
            )),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Vehicles(
                          user: widget.user,
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.blue[100],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(loc == 'en' ? 'Vehicles' : 'المركبات',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                loc == 'en'
                                    ? 'There are no selected vehicles'
                                    : 'لا يوجد مركبات مختارة',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 15))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Divider(
                thickness: 1.0,
              ),
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => Documents(
                  //             user: widget.user,
                  //           ),
                  //         ));
                  //   },
                  //   leading: Icon(
                  //     AI.Account.account_1,
                  //     color: Colors.black,
                  //   ),
                  //   title: Text(
                  //     loc == 'en' ? 'Documents' : 'المستندات والوثائق',
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 17),
                  //   ),
                  // ),
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => Payments(user: widget.user),
                  //         ));
                  //   },
                  //   leading: Icon(
                  //     AI.Account.account_2,
                  //     color: Colors.black,
                  //   ),
                  //   title: Text(
                  //     loc == 'en' ? 'Payments' : 'المدفوعات',
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 17),
                  //   ),
                  // ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAccount(
                              user: widget.user,
                            ),
                          ));
                    },
                    leading: Icon(
                      AI.Account.account_3,
                      color: Colors.black,
                    ),
                    title: Text(
                      loc == 'en' ? 'Edit Account' : 'تعديل البيانات',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => MapOne(
                  //             user: widget.user,
                  //           ),
                  //         ));
                  //   },
                  //   leading: Icon(
                  //     AI.Account.account_6,
                  //     color: Colors.black,
                  //   ),
                  //   title: Text(
                  //     loc == 'en' ? 'Application Settings' : 'إعدادات التطبيق',
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 17),
                  //   ),
                  // )
                ],
              ),
              Divider(
                thickness: 1.0,
              ),
              ListTile(
                onTap: () async {
                  await removeValues();
                  String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <logout xmlns="http://Mgra.WS/">
      <UserID>${widget.user.id}</UserID>
      <type>1</type>
    </logout>
  </soap:Body>
</soap:Envelope>''';
                  http.Response response = await http
                      .post(
                      Uri.parse('http://tryconnect.net/api/MgraWebService.asmx' ),
                          headers: {
                            "SOAPAction": "http://Mgra.WS/logout",
                            "Content-Type": "text/xml;charset=UTF-8",
                          },
                          body: utf8.encode(soap),
                          encoding: Encoding.getByName("UTF-8"))
                      .then((onValue) {
                    return onValue;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WillPopScope(
                              onWillPop: () async => false, child: Home())));
                },
                dense: true,
                title: Text(
                  loc == 'en' ? 'Sign Out' : 'تسجيل خروج',
                  style: TextStyle(
                      color: Colors.purple[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
