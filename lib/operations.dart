import 'package:flutter/material.dart';
import 'package:shifter/earnings_main.dart';
import 'package:shifter/operation_details.dart';
import 'package:shifter/user.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';

class Operations extends StatefulWidget {
  final User user;
  Operations({required this.user});
  @override
  _OperationsState createState() => _OperationsState();
}

class _OperationsState extends State<Operations> {
  String total = '';
  String next = '';
  String? loc;
  List<OperationWidget> operations = <OperationWidget>[];
  loadData() async {
    operations = [];
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetWalletHistory xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
      <Language>${loc!.toUpperCase()}</Language>
    </GetWalletHistory>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post( Uri.parse('http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/GetWalletHistory",
              "Content-Type": "text/xml;charset=UTF-8",
            },
            body: utf8.encode(soap),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    String json = parse(response.body)
        .getElementsByTagName('GetWalletHistoryResult')[0]
        .text;
    final decoded = jsonDecode(json);
    for (int i = 0; i < decoded.length; i++) {
      operations.add(OperationWidget(
        id: decoded[i]['ID'],
        title: decoded[i]['Title'],
        date: decoded[i]['Date'],
        sub: decoded[i]['SubValue'],
        last: decoded[i]['LastValue'],
      ));
    }
    if (decoded.length > 0) {
      total = decoded[0]['Total'];
      next = decoded[0]['NextDate'];
    }
    setState(() {});
  }

  @override
  void initState() {
    loc = globals.loc;
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EarningsMain(user: widget.user),
              ));
          return true;
        },
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
                              loc == 'en'
                                  ? 'Transfer Operations'
                                  : 'عمليات التحويل',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              endIndent:
                                  MediaQuery.of(context).size.width / 1.85,
                              color: Colors.white,
                              thickness: 2.0,
                            ),
                            SizedBox(
                              height: 7,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                   /*        GestureDetector(
                            onTap: () {
                             /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HelpOne(
                                      user: widget.user,
                                    ),
                                  )); */
                            },
                            child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Icon(
                                  Icons.help,
                                  color: Colors.white,
                                )),
                          ),
                    */       SizedBox(
                            width: 15,
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
                      )
                    ],
                  ),
                ),
              )),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Text(
                        loc == 'en' ? 'Current Balance' : 'الرصيد الحالي',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'SAR $total',
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        loc == 'en'
                            ? 'Balance Scheduling: $next'
                            : 'جدولة الرصيد: $next',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    loc == 'en' ? 'Operations Completed' : 'عمليات تمت',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: Container(
                    child: ListView.separated(
                      itemCount: operations.length,
                      itemBuilder: (context, index) {
                        return operations[index];
                      },
                      separatorBuilder: (context, index) => Divider(),
                    ),
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

class OperationWidget extends StatelessWidget {
  final String title, date, sub, last, id;
  OperationWidget({required this.date, required this.id, required this.last, required this.sub, required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OperationDetails(
                id: id,
              ),
            ));
      },
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$title',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$date',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'SAR $last',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'SAR $sub',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
