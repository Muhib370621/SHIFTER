// import 'package:flutter/material.dart';
// import 'package:shifter/user.dart';
// import 'globals.dart' as globals;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:html/parser.dart';
//
// class Payments extends StatefulWidget {
//   final User user;
//   Payments({required this.user});
//   @override
//   _PaymentsState createState() => _PaymentsState();
// }
//
// class _PaymentsState extends State<Payments> {
//   List<OperationWidget> operations = <OperationWidget>[];
//   String? loc;
//   loadList() async {
//     operations = [];
//     String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <PaymentByDriver xmlns="http://Mgra.WS/">
//       <DriverID>${widget.user.id}</DriverID>
//       <Language>${loc!.toUpperCase()}</Language>
//     </PaymentByDriver>
//   </soap:Body>
// </soap:Envelope>''';
//     http.Response response = await http
//         .post( Uri.parse('http://tryconnect.net/api/MgraWebService.asmx' ),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/PaymentByDriver",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     String json = parse(response.body)
//         .getElementsByTagName('PaymentByDriverResult')[0]
//         .text;
//     final decoded = jsonDecode(json);
//     for (int i = 0; i < decoded.length; i++) {
//       operations.add(OperationWidget(
//         title: decoded[i]['status'],
//         date: decoded[i]['date'],
//         last: decoded[i]['value'],
//       ));
//     }
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     loc = globals.loc;
//     super.initState();
//     loadList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: PreferredSize(
//             preferredSize: Size.fromHeight(80.0),
//             child: AppBar(
//               backgroundColor: Color(0xff2b2b2b),
//               elevation: 0,
//               automaticallyImplyLeading: false,
//               flexibleSpace: Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 margin:
//                     EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Expanded(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             loc == 'en'
//                                 ? 'Transfer Operations'
//                                 : 'عمليات التحويل',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Divider(
//                             endIndent: MediaQuery.of(context).size.width / 1.85,
//                             color: Colors.white,
//                             thickness: 2.0,
//                           ),
//                           SizedBox(
//                             height: 7,
//                           )
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                     /*     GestureDetector(
//                           onTap: () {
//                            /*  Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => HelpOne(
//                                     user: widget.user,
//                                   ),
//                                 )); */
//                           },
//                           child: Directionality(
//                               textDirection: TextDirection.ltr,
//                               child: Icon(
//                                 Icons.help,
//                                 color: Colors.white,
//                               )),
//                         ),
//                      */    SizedBox(
//                           width: 15,
//                         ),
//                         GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(),
//                                 child: Icon(Icons.arrow_forward,
//                                     color: Colors.white)))
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             )),
//         body: Container(
//           padding: EdgeInsets.all(15),
//           child: ListView.separated(
//             itemCount: operations.length,
//             itemBuilder: (context, index) {
//               return operations[index];
//             },
//             separatorBuilder: (context, index) => Divider(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class OperationWidget extends StatelessWidget {
//   final String title, date, last;
//   OperationWidget({required this.date, required this.last, required this.title});
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Container(
//           color: Colors.white,
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       '$title',
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       '$date',
//                       style: TextStyle(fontSize: 14, color: Colors.grey),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 15,
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: <Widget>[
//                     Text(
//                       'SAR $last',
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           )),
//     );
//   }
// }
