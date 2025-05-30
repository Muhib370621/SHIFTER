import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shifter/controller/main_screen_controllers/order_controller.dart';
import 'package:shifter/help_one.dart';
import 'package:shifter/user.dart';
import 'package:shifter/wrapper.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OrderDetails extends StatefulWidget {
  final String orderid;

  final User user;
  OrderDetails({required this.user, required this.orderid});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String close="";
  String customer="";
  String branch="";
  String phone="";
  String pickText="";
  String pickValue="";
  String reach="";
  String reachFlag="";
  String leave="";
  String leaveFlag="";
  String orderNo="";
  String dropName="";
  String dropPhone="";
  String dropText="";
  String dropValue="";
  String collAmount="";
  String deliverFlag="";
  String deliver="";
  String returnATMFlag="";
  String returnATM="";
  String notes="";
  String status="";
  String invoiceno="";

  bool load = false;
  bool load1 = false;
  bool load2 = false;
  bool load3 = false;
  bool load4 = false;
  bool load5 = false;

  TextEditingController notesCont = new TextEditingController();
  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  loadOrderData() async {
    setState(() {
      load = true;
    });
    final orderController = Get.put(OrderController());
    orderController.driverGetOrderByID(orderController.orderModel.value.id.toString());
      close = orderController.orderModel.value.levelid.toString();
      customer = orderController.orderModel.value.clientName??"";
      branch = "branch";
      phone = "";
      pickText = orderController.orderModel.value.pickAddress??"";
      pickValue = orderController.orderModel.value.pickAddressLatLng??"";
      reachFlag = orderController.orderModel.value.levelid.toString()??"";
      reach = orderController.orderModel.value.canReachDrop.toString()??"";
      leaveFlag = "";
      leave ="";
      orderNo = orderController.orderModel.value.id.toString()??"";
      dropName = orderController.orderModel.value.dropAddress.toString()??"";
      dropPhone ="";
      dropText = "";
      dropValue = "";
      collAmount = "0";
      deliverFlag = orderController.orderModel.value.id.toString()??"";
      deliver = "";
      returnATMFlag = "";
      returnATM = "";
      notes = "";
      invoiceno =  orderController.orderModel.value.referancecode.toString()??"";
      // if (close == '1') {
      //   notesCont.text = notes;
      // }
      // status = decoded['Status'];
    // }
    setState(() {
      load = false;
    });
  }


  final orderController = Get.put(OrderController());
  @override
  void initState() {
    super.initState();
    loadOrderData();
  }



 
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          globals.loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: load
          ? Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xff3c2c63)),
                    )
                  ],
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(80.0),
                  child: AppBar(
                    backgroundColor: Color(0xff2b2b2b),
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                  globals.loc == 'en'
                                      ? 'Order Details'
                                      : 'تفاصيل الطلب',
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper(
                                              tab: 2,
                                            )));
                              },
                              child: Container(
                                  decoration: BoxDecoration(),
                                  child: Icon(Icons.arrow_forward,
                                      color: Colors.white)))
                        ],
                      ),
                    ),
                  )),
              body: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Image.asset('assets/Call.png', height: 50, width: 50),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                              '$customer',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '$branch',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                          onTap: () => launch("tel://" + '$phone'),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: new Text(
                              '$phone',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                       SizedBox(
                        height: 5,
                      ), Text(
                         globals.loc == 'en'
                                      ? 'Invoice No.' +  '$invoiceno'
                                      : ' رقم الفاتورة  ' +  '$invoiceno',
                       
                      
                      ),
                    
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => openMap(
                                double.parse(pickValue.split(',')[0]),
                                double.parse(pickValue.split(',')[1])),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(),
                              child: Image.asset('assets/location.png',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.fitWidth),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  globals.loc == 'en'
                                      ? 'Pickup Location'
                                      : 'موقع الاستلام',
                                ),
                                SizedBox(
                                  height: 7.5,
                                ),
                                GestureDetector(
                                  onTap: () => openMap(
                                      double.parse(pickValue.split(',')[0]),
                                      double.parse(pickValue.split(',')[1])),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      pickText,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.blue),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      close == '1'
                          ? Container(height: 0, width: 0)
                          : load1
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Color(0xff3c2c63)),
                                      ),
                                    )
                                  ],
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(globals.loc == 'en'
                                                ? 'Have you reached the store?'
                                                : 'هل وصلت الى المتجر؟'),
                                            Text(
                                              reach,
                                              style: TextStyle(
                                                  color: reachFlag == '1'
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Switch(
                                          activeColor: Colors.green,
                                          inactiveThumbColor: Colors.red,
                                          inactiveTrackColor:
                                              Colors.red.withOpacity(0.5),
                                          value:
                                              reachFlag == '1' ? true : false,
                                          onChanged: (value) async {
                                            if (value == true) {
                                              reachFlag = '1';
                                              setState(() {
                                                load1 = true;
                                              });
//                                               String soap =
//                                                   '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <ReachStoreOrderV2 xmlns="http://Mgra.WS/">
//       <ID>${widget.orderid}</ID>
//       <Status>$reachFlag</Status>
//     </ReachStoreOrderV2>
//   </soap:Body>
// </soap:Envelope>''';
//                                               http.Response response =
//                                                   await http
//                                                       .post(
//                                                           Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                                           headers: {
//                                                             "SOAPAction":
//                                                                 "http://Mgra.WS/ReachStoreOrderV2",
//                                                             "Content-Type":
//                                                                 "text/xml;charset=UTF-8",
//                                                           },
//                                                           body:
//                                                               utf8.encode(soap),
//                                                           encoding: Encoding
//                                                               .getByName(
//                                                                   "UTF-8"))
//                                                       .then((onValue) {
//                                                 return onValue;
//                                               });
                                              orderController.changeOrderStatus(orderNo, 2);

                                              setState(() {
                                                load1 = false;
                                              });
                                              loadOrderData();
                                            } else {}
                                          })
                                    ],
                                  ),
                                ),
                      close == '1'
                          ? Container(height: 0, width: 0)
                          : SizedBox(
                              height: 15,
                            ),
                      close == '1'
                          ? Container(height: 0, width: 0)
                          : Text(
                              globals.loc == 'en'
                                  ? 'Once you reach the store, click yes, this is to protect you for the time of quality'
                                  : 'بمجرد وصولك إلى المتجر ، انقر فوق نعم ، فهذا سيحميك لحساب وقت الجودة',
                              style: TextStyle(fontSize: 12)),
                      close == '1'
                          ? Container(height: 0, width: 0)
                          : reachFlag == '0'
                              ? Container(height: 0, width: 0)
                              : SizedBox(
                                  height: 20,
                                ),
                      close == '1'
                          ? Container(height: 0, width: 0)
                          : reachFlag == '0'
                              ? Container(height: 0, width: 0)
                              : load2
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 35,
                                          width: 35,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Color(0xff3c2c63)),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(globals.loc == 'en'
                                                    ? 'Have you left the store?'
                                                    : 'هل غادرت المتجر؟'),
                                                Text(
                                                  leave,
                                                  style: TextStyle(
                                                      color: leaveFlag == '1'
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Switch(
                                              activeColor: Colors.green,
                                              inactiveThumbColor: Colors.red,
                                              inactiveTrackColor:
                                                  Colors.red.withOpacity(0.5),
                                              value: leaveFlag == '1'
                                                  ? true
                                                  : false,
                                              onChanged: (value) async {
                                                if (value == true) {
                                                  leaveFlag = '1';

                                                  setState(() {
                                                    load2 = true;
                                                  });
//                                                   String soap =
//                                                       '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <LeaveStoreOrderV3 xmlns="http://Mgra.WS/">
//       <ID>${widget.orderid}</ID>
//       <Status>$leaveFlag</Status>
//     </LeaveStoreOrderV3>
//   </soap:Body>
// </soap:Envelope>''';
//                                                   http.Response response =
//                                                       await http
//                                                           .post(
//                                                               Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                                               headers: {
//                                                                 "SOAPAction":
//                                                                     "http://Mgra.WS/LeaveStoreOrderV3",
//                                                                 "Content-Type":
//                                                                     "text/xml;charset=UTF-8",
//                                                               },
//                                                               body: utf8
//                                                                   .encode(soap),
//                                                               encoding: Encoding
//                                                                   .getByName(
//                                                                       "UTF-8"))
//                                                           .then((onValue) {
//                                                     return onValue;
//                                                   });
                                                  orderController.changeOrderStatus(orderNo, 3);

                                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('ColorStatus', "4");
                                                  setState(() {
                                                    load2 = false;
                                                  });
                                                  loadOrderData();
                                                } else {}
                                              })
                                        ],
                                      ),
                                    ),
                      close == '1'
                          ? Container(height: 0, width: 0)
                          : leaveFlag == '0'
                              ? Container(height: 0, width: 0)
                              : SizedBox(
                                  height: 15,
                                ),
                      close == '1'
                          ? Container(height: 0, width: 0)
                          : leaveFlag == '0'
                              ? Container(height: 0, width: 0)
                              : Text(
                                  globals.loc == 'en'
                                      ? 'This option to show customer and drop off location'
                                      : 'هذا الخيار لعرض معلومات العميل وموقع التسليم',
                                  style: TextStyle(fontSize: 12)),
                      close == '1'
                          ? Container(height: 0, width: 0)
                          : leaveFlag == '0'
                              ? Container(height: 0, width: 0)
                              : SizedBox(
                                  height: 20,
                                ),
                      leaveFlag == '0'
                          ? Container(height: 0, width: 0)
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: close == '1'
                                      ? Colors.grey[600]
                                      : Color(0xff2b2b2b),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                globals.loc == 'en'
                                                    ? 'Order Number'
                                                    : 'رقم الطلب',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            SizedBox(height: 5),
                                            Text(orderNo,
                                                style: TextStyle(
                                                    color: Colors.white))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 7.5),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 7.5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(dropName,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(dropPhone,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      close == '1'
                                          ? Container(height: 0, width: 0)
                                          : SizedBox(width: 20),
                                      close == '1'
                                          ? Container(height: 0, width: 0)
                                          : GestureDetector(
                                              onTap: () => launch(
                                                  "tel://" + '$dropPhone'),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                   ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                child: Text(
                                                    globals.loc == 'en'
                                                        ? 'Call Customer'
                                                        : 'الاتصال بالعميل',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            )
                                    ],
                                  ),
                                  SizedBox(height: 7.5),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 7.5),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => openMap(
                                            double.parse(
                                                dropValue.split(',')[0]),
                                            double.parse(
                                                dropValue.split(',')[1])),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(),
                                          child: Image.asset(
                                              'assets/location.png',
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => openMap(
                                              double.parse(
                                                  dropValue.split(',')[0]),
                                              double.parse(
                                                  dropValue.split(',')[1])),
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            child: Text(
                                              dropText,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7.5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            globals.loc == 'en'
                                                ? 'Click on Google or the link to go to the customer'
                                                : 'انقر على جوجل أو الرابط للذهاب للعميل',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7.5),
                                  Divider(color: Colors.white),
                                  SizedBox(height: 7.5),
                                  close == '1'
                                      ? Container(height: 0, width: 0)
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  globals.loc == 'en'
                                                      ? 'Collection Amount'
                                                      : 'مبلغ التحصيل',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            SizedBox(width: 20),
                                            Text(collAmount,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                  close == '1'
                                      ? Container(height: 0, width: 0)
                                      : SizedBox(height: 7.5),
                                  close == '1'
                                      ? Container(height: 0, width: 0)
                                      : Divider(color: Colors.white),
                                  close == '1'
                                      ? Container(height: 0, width: 0)
                                      : SizedBox(height: 7.5),
                                  load3
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.white),
                                              ),
                                            )
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      globals.loc == 'en'
                                                          ? 'The order was delivered to the customer by hand'
                                                          : 'تم تسليم الطلب للعميل باليد',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  Text(
                                                    deliver,
                                                    style: TextStyle(
                                                        color:
                                                            deliverFlag == '1'
                                                                ? Colors.green
                                                                : Colors.red,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            close == '1'
                                                ? Container(height: 0, width: 0)
                                                : SizedBox(
                                                    width: 20,
                                                  ),
                                            close == '1'
                                                ? Container(height: 0, width: 0)
                                                : Switch(
                                                    activeColor: Colors.green,
                                                    inactiveThumbColor:
                                                        Colors.red,
                                                    inactiveTrackColor: Colors
                                                        .red
                                                        .withOpacity(0.5),
                                                    value: deliverFlag == '1'
                                                        ? true
                                                        : false,
                                                    onChanged: (value) async {
                                                      if (value == true) {
                                                        deliverFlag = '1';
                                                    
                                                        setState(() {
                                                          load3 = true;
                                                        });
//                                                         String soap =
//                                                             '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <StartOrderV3 xmlns="http://Mgra.WS/">
//       <ID>${widget.orderid}</ID>
//       <DriverID>${widget.user.id}</DriverID>
//       <Status>$deliverFlag</Status>
//     </StartOrderV3>
//   </soap:Body>
// </soap:Envelope>''';
//                                                         http.Response response =
//                                                             await http
//                                                                 .post(
//                                                                     Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                                                     headers: {
//                                                                       "SOAPAction":
//                                                                           "http://Mgra.WS/StartOrderV3",
//                                                                       "Content-Type":
//                                                                           "text/xml;charset=UTF-8",
//                                                                     },
//                                                                     body: utf8
//                                                                         .encode(
//                                                                             soap),
//                                                                     encoding: Encoding
//                                                                         .getByName(
//                                                                             "UTF-8"))
//                                                                 .then(
//                                                                     (onValue) {
//                                                           return onValue;
//                                                         });

                                                        orderController.changeOrderStatus(orderNo, 1);

                                                             SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('ColorStatus', "5");
                                                        setState(() {
                                                          load3 = false;
                                                        });
                                                        loadOrderData();
                                                      } else {}
                                                    })
                                          ],
                                        ),
                                  SizedBox(height: 10),
                                  load4
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.white),
                                              ),
                                            )
                                          ],
                                        )
                                      : SizedBox(),
                                  deliverFlag == '0'
                                      ? Container(height: 0, width: 0)
                                      : SizedBox(height: 15),
                                  deliverFlag == '0'
                                      ? Container(height: 0, width: 0)
                                      : TextFormField(
                                          readOnly: close == '1' ? true : false,
                                          controller: notesCont,
                                          decoration: InputDecoration(
                                              hintText: globals.loc == 'en'
                                                  ? 'Notes'
                                                  : 'ملاحظات',
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: BorderSide.none),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 12, 12, 36)),
                                        ),
                                  deliverFlag == '0'
                                      ? Container(height: 0, width: 0)
                                      : SizedBox(height: 25),
                                  close == '1'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(status,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            )
                                          ],
                                        )
                                      : deliverFlag == '0'
                                          ? Container(height: 0, width: 0)
                                          : load5
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 35,
                                                      width: 35,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          load5 = true;
                                                        });
//                                                         String soap =
//                                                             '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <CompleteOrderV3 xmlns="http://Mgra.WS/">
//       <OrderID>${widget.orderid}</OrderID>
//       <DriverID>${widget.user.id}</DriverID>
//       <Notes>${notesCont.text}</Notes>
//     </CompleteOrderV3>
//   </soap:Body>
// </soap:Envelope>''';
//                                                         http.Response response =
//                                                             await http
//                                                                 .post(
//                                                                     Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                                                     headers: {
//                                                                       "SOAPAction":
//                                                                           "http://Mgra.WS/CompleteOrderV3",
//                                                                       "Content-Type":
//                                                                           "text/xml;charset=UTF-8",
//                                                                     },
//                                                                     body: utf8
//                                                                         .encode(
//                                                                             soap),
//                                                                     encoding: Encoding
//                                                                         .getByName(
//                                                                             "UTF-8"))
//                                                                 .then(
//                                                                     (onValue) {
//                                                           return onValue;
//                                                         });
//                                                         String json = parse(
//                                                                 response.body)
//                                                             .getElementsByTagName(
//                                                                 'CompleteOrderV3Result')[0]
//                                                             .text;
//                                                         final decoded =
//                                                             jsonDecode(json);
                                                        orderController.changeOrderStatus(orderNo, 5);


                                                        SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('ColorStatus', "2");
                                                        setState(() {
                                                          load5 = false;
                                                        });
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (context) =>
                                                                    WillPopScope(
                                                                      onWillPop:
                                                                          () async {
                                                                        loadOrderData();
                                                                        Navigator.pop(
                                                                            context);
                                                                        return true;
                                                                      },
                                                                      child:
                                                                          Dialog(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(12.5),
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  loadOrderData();
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(),
                                                                                  child: Icon(
                                                                                    Icons.close,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 10),
                                                                              Text(
                                                                                "sms",
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .yellow[800],
                                                           ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 12.5,
                                                                horizontal:
                                                                    12.5),
                                                        child: Text(globals
                                                                    .loc ==
                                                                'en'
                                                            ? 'Click to close order'
                                                            : 'اضغط لانهاء الطلب'),
                                                      ),
                                                    )
                                                  ],
                                                )
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                         leaveFlag == '0'?
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Column(children: [
                           Row(
                            children: [
                              Expanded(
                                child: Text(globals.loc == 'en'
                                        ?'Customer Information' : 'معلومات العميل',
                                 style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        ),
                                         textAlign: TextAlign.center,
                                   ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(dropName,
                               
                                   ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                                    children: [
                                      Expanded(
                                        child: Text(dropPhone,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      close == '1'
                                          ? Container(height: 0, width: 0)
                                          : SizedBox(width: 20),
                                      close == '1'
                                          ? Container(height: 0, width: 0)
                                          : GestureDetector(
                                              onTap: () => launch(
                                                  "tel://" + '$dropPhone'),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                  ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                child: Text(
                                                    globals.loc == 'en'
                                                        ? 'Call Customer'
                                                        : 'الاتصال بالعميل',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            )
                                    ],
                                  ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Text(collAmount,
                                  ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.5),
                          Divider(
                            color: Colors.white,
                          ),
                          SizedBox(height: 7.5),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => openMap(
                                    double.parse(dropValue.split(',')[0]),
                                    double.parse(dropValue.split(',')[1])),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(),
                                  child: Image.asset('assets/location.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.fitWidth),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => openMap(
                                      double.parse(dropValue.split(',')[0]),
                                      double.parse(dropValue.split(',')[1])),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      dropText,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      )
                     : Container(), SizedBox(
                        height: 20,
                      ),
                      close == '1'
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WillPopScope(
                                        onWillPop: () async => false,
                                        child: HelpOne(
                                            user: widget.user,
                                            orderid: widget.orderid),
                                      ),
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: Row(children: [
                                  Expanded(
                                    child: Text(globals.loc == 'en'
                                        ? 'Help Center?'
                                        : 'طلب مساعدة؟'),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    Icons.help,
                                    color: Colors.black,
                                  )
                                ]),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
