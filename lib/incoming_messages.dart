import 'package:flutter/material.dart';
import 'package:shifter/front_page.dart';
import 'package:shifter/payment_ask.dart';
import 'package:shifter/user.dart';
//import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'globals.dart' as globals;


class IncomingMessages extends StatefulWidget {
  final User user;
  IncomingMessages({required this.user});
  @override
  _IncomingMessagesState createState() => _IncomingMessagesState();
}

class _IncomingMessagesState extends State<IncomingMessages> {
  String loc="";
  List<IncomingMessageWidget> messages = <IncomingMessageWidget>[];
  loadMessages() async {
    messages = [];
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetDriverNotifcations xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
    </GetDriverNotifcations>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
            headers: {
              "SOAPAction": "http://Mgra.WS/GetDriverNotifcations",
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
          .getElementsByTagName('GetDriverNotifcationsResult')[0]
          .text;
      final decoded = jsonDecode(json);
      for (int i = 0; i < decoded.length; i++) {
        bool read = decoded[i]['ReadFlag'] == 'True';
        messages.add(IncomingMessageWidget(
          user: widget.user,
          read: read,
          title: decoded[i]['Title'],
          body: decoded[i]['Body'],
          time: decoded[i]['Time'],
          type: decoded[i]['Type'],
          orderID: decoded[i]['OrderID'].toString(),
          id: decoded[i]['ID'].toString(),
          ordertype: decoded[i]['OrderType'],
          amount: decoded[i]['amount'],
          status: decoded[i]['status'],
          client: decoded[i]['clientname'],
          callback: () {
            loadMessages();
            setState(() {});
          },
        ));
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    loc = globals.loc??'';
    super.initState();
    loadMessages();
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            loc == 'en' ? 'Incoming Messages' : 'البريد الوارد',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            endIndent: MediaQuery.of(context).size.width / 2.2,
                            color: Colors.white,
                            thickness: 2.0,
                          ),
                          SizedBox(
                            height: 7,
                          )
                        ],
                      ),
                    ),
                    /*     GestureDetector(
                      onTap: () {
                       /*  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpOne(
                                user: widget.user,
                              ),
                            )); */
                      },
                      child: Text(
                        loc == 'en' ? 'Help?' : 'مساعدة؟',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                 */
                  ],
                ),
              ),
            )),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return messages[index];
            },
          ),
        ),
      ),
    );
  }
}

typedef VoidCallBack = void Function();

class IncomingMessageWidget extends StatefulWidget {
  final User user;
  final bool read;
  final String title, body, type, orderID, time, id;
  final String ordertype;
  final String amount, status, client;
  final VoidCallBack callback;

  IncomingMessageWidget(
      {this.read=false,
      this.amount="",
      this.status="",
      this.client="",
      required this.user,
      this.ordertype="",
      this.body="",
      this.orderID="",
      this.time="",
      this.title="",
      this.type="",
      required  this.callback,
      this.id=""});

  @override
  _IncomingMessageWidgetState createState() => _IncomingMessageWidgetState();
}

class _IncomingMessageWidgetState extends State<IncomingMessageWidget> {
  String orderid="";

  String type2="";

  String custName="";

  String dropoff="";

  String timeSlot="";

  String ev="";

  String p="";

  String distance="";

  bool action = false;

  @override
  Widget build(BuildContext context) {
    void toMapCheck() async {}

    return GestureDetector(
      onTap: () async {
        /* String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <NotifcationRead xmlns="http://Mgra.WS/">
      <ID>${widget.id}</ID>
    </NotifcationRead>
  </soap:Body>
</soap:Envelope>''';
        http.Response response = await http
            .post('http://52.15.211.104/galaxyws/MgraWebService.asmx',
                headers: {
                  "SOAPAction": "http://Mgra.WS/NotifcationRead",
                  "Content-Type": "text/xml;charset=UTF-8",
                },
                body: utf8.encode(soap),
                encoding: Encoding.getByName("UTF-8"))
            .then((onValue) {
          return onValue;
        }); */
        String soap2 = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <checkdefpageNot xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
      <language>${globals.loc}</language>
      <OrderID>${widget.orderID}</OrderID>
      <ID>${widget.id}</ID>

    </checkdefpageNot>
  </soap:Body>
</soap:Envelope>''';
        http.Response response2 = await http
            .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
                headers: {
                  "SOAPAction": "http://Mgra.WS/checkdefpageNot",
                  "Content-Type": "text/xml;charset=UTF-8",
                },
                body: utf8.encode(soap2),
                encoding: Encoding.getByName("UTF-8"))
            .then((onValue) {
          return onValue;
        });
        String json = parse(response2.body)
            .getElementsByTagName('checkdefpageNotResult')[0]
            .text;
        final decoded = jsonDecode(json);
        print(decoded);
//
        setState(() {
          if(decoded['ID'] !=null){
          orderid = decoded['ID'];
          type2 = decoded['type'];
          p = decoded['profit'];
          ev = decoded['expectedvalue'];
          distance = decoded['distance'];
          custName = decoded['clientname'];
          dropoff = decoded['dropoff'];
          timeSlot = decoded['timeslot'];
          action = true;
          }
        });

        if (widget.type == 'SMS' ||
            widget.type == 'Offer' ||
            widget.type == 'active') {
          widget.callback();

          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  '${widget.body}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        } else if (widget.type == 'Force') {
          final key = GlobalKey<FrontPageState>();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WillPopScope(
                      onWillPop: () async => false,
                      child: FrontPage(
                        user: widget.user,
                        tab: 0,
                        key: key,
                      ))));
        } /* else if (widget.type == 'OrderUpdate' || widget.type == 'ViewOrder') {
          if (widget.ordertype == '1') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderDetails(
                        user: widget.user, orderid: widget.orderID)));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderDetails(
                        user: widget.user, orderid: widget.orderID)));
          }
        } */ else if (widget.type == 'Order') {
         
            final key = GlobalKey<FrontPageState>();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WillPopScope(
                      onWillPop: () async => false,
                      child: FrontPage(
                        user: widget.user,
                        tab: 0,
                        key: key,
                      ))));
        } /* else if (widget.type == 'Chatting' || widget.type == 'Invoice') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(
                    user: widget.user,
                    orderno: widget.orderID,
                    status: widget.status,
                    type: widget.ordertype,
                    amount: widget.amount,
                    custName: widget.client),
              ));
        }  */ else if (widget.type == 'CancelOrder' || widget.type == 'OrderUpdate' || widget.type == 'ViewOrder') {
         
            final key = GlobalKey<FrontPageState>();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WillPopScope(
                      onWillPop: () async => false,
                      child: FrontPage(
                        user: widget.user,
                        tab: 2,
                        key: key,
                      ))));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentAsk(
                    orderId: widget.orderID,
                    user: widget.user,
                    type: widget.ordertype,
                    sms: widget.title),
              ));
        }
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
            decoration: BoxDecoration(
                color: widget.read == true ? Colors.white : Colors.grey[200]),
            height: 60,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /* ClipPolygon(
                  sides: 6,
                  rotate: 90.0,
                  child: Container(color: Colors.grey[800]),
                ), */
                SizedBox(
                  width: 10,
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    child: Text('${widget.time}')),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      '${widget.title}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
