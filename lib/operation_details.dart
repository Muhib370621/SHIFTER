import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';

class OperationDetails extends StatefulWidget {
  final String id;
  OperationDetails({required this.id});
  @override
  _OperationDetailsState createState() => _OperationDetailsState();
}

class _OperationDetailsState extends State<OperationDetails> {
  String? loc;
  String title = '', date = '', status = '', amount = '', take = '';
  @override
  void initState() {
    loc = globals.loc;
    super.initState();
    loadData();
  }

  loadData() async {
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetTransByID xmlns="http://Mgra.WS/">
      <ID>${widget.id}</ID>
      <Language>${loc!.toUpperCase()}</Language>
    </GetTransByID>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(  Uri.parse('http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/GetTransByID",
              "Content-Type": "text/xml;charset=UTF-8",
            },
            body: utf8.encode(soap),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    String json =
        parse(response.body).getElementsByTagName('GetTransByIDResult')[0].text;
    final decoded = jsonDecode(json);
    print(decoded);
    title = decoded['Title'];
    date = decoded['Date'];
    status = decoded['Status'];
    amount = decoded['Amount'];
    take = decoded['Take'];
    setState(() {});
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
                            loc == 'en'
                                ? 'Transfer Operation Details'
                                : 'تفاصيل عمليات التحويل',
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
          padding: EdgeInsets.all(15),
          child: ListView(
            children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                  dense: true,
                  title: Text(
                    loc == 'en' ? 'Profit' : 'الربح',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'SAR $amount',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
              ListTile(
                  dense: true,
                  title: Text(
                    loc == 'en' ? 'Type' : 'النوع',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$title',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
              ListTile(
                  dense: true,
                  title: Text(
                    loc == 'en' ? 'Status' : 'الحالة',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$status',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
              ListTile(
                  dense: true,
                  title: Text(
                    loc == 'en' ? 'Operation Date' : 'تاريخ العملية',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$date',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
              ListTile(
                  dense: true,
                  title: Text(
                    loc == 'en' ? 'Take' : 'تحصيل',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$take',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
            ]).toList(),
          ),
        ),
      ),
    );
  }
}
