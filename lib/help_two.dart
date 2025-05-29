import 'package:flutter/material.dart';
import 'package:shifter/user.dart';
import 'help_icons.dart';
import 'account_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'globals.dart' as globals;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

class HelpTwo extends StatefulWidget {
  final User user;
  final String parentID;
  final String orderid;

  HelpTwo({this.parentID ="", required this.user, required this.orderid});
  @override
  _HelpTwoState createState() => _HelpTwoState();
}

class _HelpTwoState extends State<HelpTwo> {
  String loc="";
  List<HelpWidget> helpWid = <HelpWidget>[];
  loadHelp() async {
    helpWid = [];
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetHelpList xmlns="http://Mgra.WS/">
      <ParentID>${widget.parentID}</ParentID>
      <Language>${loc.toUpperCase()}</Language>
    </GetHelpList>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/GetHelpList",
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
          .getElementsByTagName('GetHelpListResult')[0]
          .text;
      final decoded = jsonDecode(json);
      for (int i = 0; i < decoded.length; i++) {
        helpWid.add(HelpWidget(
          user: widget.user,
          id: decoded[i]['ID'],
          title: decoded[i]['Title'],
          action: decoded[i]['Action'],
          sub: decoded[i]['HasSub'],
          orderid: widget.orderid
        ));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    loc = globals.loc??'';
    super.initState();
    loadHelp();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        key:_scaffoldKey,
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
                            loc == 'en' ? 'Help' : 'المساعدة',
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
            child: ListView.builder(
          itemCount: helpWid.length,
          itemBuilder: (context, index) {
            return helpWid[index];
          },
        )),
      ),
    );
  }
}

class HelpWidget extends StatefulWidget {
  final User user;
  final String id, title, action, sub, orderid;
  HelpWidget({this.action="", this.id="", this.sub="", this.title="", required this.user,required this.orderid});
  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  String loc="";
  TextEditingController oid = new TextEditingController();
  TextEditingController notes = new TextEditingController();

  @override
  void initState() {
    oid.text = widget.orderid;
    loc = globals.loc??'';
    super.initState();
  }

  final _overlayKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.sub == '0' && widget.action == 'True') {
          showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: Dialog(
                  child: Directionality(
                    textDirection:
                        loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Form(
                        key: _overlayKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close, color: Colors.red),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                loc == 'en'
                                    ? 'Enter Order No'
                                    : 'أدخل رقم الطلب',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              enabled: false,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return loc == 'en' ? 'Required' : 'مطلوب';
                                } else {
                                  return null;
                                }
                              },
                              controller: oid,
                              decoration: InputDecoration(
                                  hintText:
                                      loc == 'en' ? 'Order No' : 'رقم الطلب'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              loc == 'en' ? 'Enter Notes' : 'أدخل ملاحظات',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.newline,
                              maxLines: null,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return loc == 'en' ? 'Required' : 'مطلوب';
                                } else {
                                  return null;
                                }
                              },
                              controller: notes,
                              decoration: InputDecoration(
                                  hintText: loc == 'en' ? 'Notes' : 'ملاحظات'),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30)),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                      ),
                              child: Text(loc == 'en'
                                  ? 'Submit'
                                  : "إرسال".toUpperCase()),
                              onPressed: () async {
                               if (_overlayKey.currentState!.validate())  {
                                  String soap =
                                      '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SubmitHelp xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
      <OrderID>${oid.text}</OrderID>
      <HelpItemID>${widget.id}</HelpItemID>
      <Notes>${notes.text}</Notes>
    </SubmitHelp>
  </soap:Body>
</soap:Envelope>''';
                                  http.Response response = await http
                                      .post(
                                          Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                                          headers: {
                                            "SOAPAction":
                                                "http://Mgra.WS/SubmitHelp",
                                            "Content-Type":
                                                "text/xml;charset=UTF-8",
                                          },
                                          body: utf8.encode(soap),
                                          encoding: Encoding.getByName("UTF-8"))
                                      .then((onValue) {
                                    return onValue;
                                  });
                                  Navigator.pop(context);
                                      String json = parse(response.body)
                              .getElementsByTagName('SubmitHelpResult')[0]
                              .text;

                          if (json != "1") {
                           /*  _scaffoldKey.currentState
                                .showSnackBar(SnackBar(content: Text(json))); */
                          }
                                }
                              },
                             
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (widget.sub == '1') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HelpTwo(
                        parentID: widget.id,
                        user: widget.user,
                        orderid: widget.orderid,
                      )));
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: <Widget>[
            Icon(widget.sub == '0' ? Account.account_1 : Help.help_6),
            SizedBox(width: 15),
            Expanded(child: Text('${widget.title}')),
            widget.sub == '0'
                ? Container()
                : Icon(Icons.arrow_forward_ios, size: 15)
          ],
        ),
      ),
    );
  }
}
