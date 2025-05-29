// import 'package:flutter/material.dart';
// import 'package:shifter/document_details_IDback.dart';
// import 'package:shifter/document_details_IDfront.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shifter/user.dart';
// import 'package:shifter/wrapper.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:flutter/services.dart';
// import 'dart:math' as math;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:html/parser.dart';
// import 'dart:io';
// import 'globals.dart' as globals;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Documents extends StatefulWidget {
//   final User user;
//   Documents({required this.user});
//   @override
//   _DocumentsState createState() => _DocumentsState();
// }
//
// class _DocumentsState extends State<Documents> {
//   late File file;
//   String fileName = '';
//   String loc = "";
//   String lic = "", idFront = "", idBack = "", dp = "";
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   updateImg(String img) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('Photo', img);
//   }
//
//   loadStatus() async {
//     String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <CheckDocuments xmlns="http://Mgra.WS/">
//       <DriverID>${widget.user.id}</DriverID>
//     </CheckDocuments>
//   </soap:Body>
// </soap:Envelope>''';
//     http.Response response = await http
//         .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/CheckDocuments",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     String json = parse(response.body)
//         .getElementsByTagName('CheckDocumentsResult')[0]
//         .text;
//     final decoded = jsonDecode(json);
//     lic = decoded['license'];
//     idFront = decoded['frontidentity'];
//     idBack = decoded['backidentity'];
//     dp = decoded['image'];
//     setState(() {});
//   }
//
//   Future filePickerImg(BuildContext context) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//       if (result != null) {
//         file = File(result.files.single.path!);
//
//         final tempDir = await path_provider.getTemporaryDirectory();
//         final path = tempDir.path;
//         fileName = path.split('/')[0];
//         int rand = new math.Random().nextInt(10000);
//         List<int> imageBytes = file.readAsBytesSync();
//         String base64Image = base64Encode(imageBytes);
//         String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
// <soap:Body>
//   <UpdateDriverImg xmlns="http://Mgra.WS/">
//     <ID>${widget.user.id}</ID>
//     <Img>$base64Image</Img>
//   </UpdateDriverImg>
// </soap:Body>
// </soap:Envelope>''';
//         http.Response response = await http
//             .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//                 headers: {
//                   "SOAPAction": "http://Mgra.WS/UpdateDriverImg",
//                   "Content-Type": "text/xml;charset=UTF-8",
//                 },
//                 body: utf8.encode(soap),
//                 encoding: Encoding.getByName("UTF-8"))
//             .then((onValue) {
//           return onValue;
//         });
//         await updateImg(base64Image);
//         User user = new User(
//             email: widget.user.email,
//             password: widget.user.password,
//             number: widget.user.number,
//             firstName: widget.user.firstName,
//             lastName: widget.user.lastName,
//             city: widget.user.city,
//             id: widget.user.id,
//             photo: base64Image,
//             status: '');
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => Wrapper()));
//             }
//     } on PlatformException catch (e) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Sorry...'),
//               content: Text('Unsupported exception: $e'),
//               actions: <Widget>[
//                 ElevatedButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             );
//           });
//     }
//   }
//
//   Future filePickerLicense(BuildContext context) async {
//     try {
//       //file = await FilePicker.getFile(type: FileType.image);
//       FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//       if (result != null) {
//         file = File(result.files.single.path!);
//         final tempDir = await path_provider.getTemporaryDirectory();
//         final path = tempDir.path;
//         fileName = path.split('/')[0];
//         int rand = new math.Random().nextInt(10000);
//         List<int> imageBytes = file.readAsBytesSync();
//         String base64Image = base64Encode(imageBytes);
//         String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
// <soap:Body>
//   <DriverLicense xmlns="http://Mgra.WS/">
//     <ID>${widget.user.id}</ID>
//     <License>$base64Image</License>
//   </DriverLicense>
// </soap:Body>
// </soap:Envelope>''';
//         http.Response response = await http
//             .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//                 headers: {
//                   "SOAPAction": "http://Mgra.WS/DriverLicense",
//                   "Content-Type": "text/xml;charset=UTF-8",
//                 },
//                 body: utf8.encode(soap),
//                 encoding: Encoding.getByName("UTF-8"))
//             .then((onValue) {
//           return onValue;
//         });
//         String json = parse(response.body)
//             .getElementsByTagName('DriverLicenseResult')[0]
//             .text;
//         final decoded = jsonDecode(json);
//         if (decoded == '-1') {
//           /*  _scaffoldKey.currentState.showSnackBar(
//             SnackBar(content: Text(loc == 'en' ? 'Failed' : 'فشل'))); */
//         } else {
//           /* _scaffoldKey.currentState.showSnackBar(SnackBar(
//             content: Text(loc == 'en' ? 'Successfully Done' : 'تم بنجاح'))); */
//         }
//         await Future.delayed(Duration(seconds: 3)).then((v) {
//           loadStatus();
//         });
//             }
//     } on PlatformException catch (e) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Sorry...'),
//               content: Text('Unsupported exception: $e'),
//               actions: <Widget>[
//                 ElevatedButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             );
//           });
//     }
//   }
//
//   @override
//   void initState() {
//     loc = globals.loc;
//     super.initState();
//     loadStatus();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
//       child: Scaffold(
//         key: _scaffoldKey,
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
//                             loc == 'en' ? 'Documents' : 'المستندات والوثائق',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Divider(
//                             endIndent: MediaQuery.of(context).size.width / 1.55,
//                             color: Colors.white,
//                             thickness: 2.0,
//                           ),
//                           SizedBox(
//                             height: 7,
//                           )
//                         ],
//                       ),
//                     ),
//                     GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                             decoration: BoxDecoration(),
//                             child:
//                                 Icon(Icons.arrow_forward, color: Colors.white)))
//                   ],
//                 ),
//               ),
//             )),
//         body: Container(
//           padding: EdgeInsets.all(25),
//           child: Column(
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.only(top: 10),
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: () {
//                         filePickerLicense(context);
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(),
//                         child: Row(
//                           children: <Widget>[
//                             lic == '0'
//                                 ? Icon(Icons.warning,
//                                     size: 50, color: Colors.red)
//                                 : Icon(Icons.check_circle_outline,
//                                     size: 50, color: Colors.green[400]),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     loc == 'en'
//                                         ? 'Driving License'
//                                         : 'رخصة القيادة',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               color: Colors.black,
//                               size: 17,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Divider(),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DocDetailsIDFront(
//                                 user: widget.user,
//                               ),
//                             ));
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(),
//                         child: Row(
//                           children: <Widget>[
//                             idFront == '0'
//                                 ? Icon(Icons.warning,
//                                     size: 50, color: Colors.red)
//                                 : Icon(Icons.check_circle_outline,
//                                     size: 50, color: Colors.green[400]),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     loc == 'en'
//                                         ? 'National Identity(Front Side)'
//                                         : 'صورة الهوية أو رخصة الاقامة(الواجهة الأمامية)',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   // SizedBox(
//                                   //   height: 7,
//                                   // ),
//                                   // Text(
//                                   //   '${loc=='en'?'End On':'تنتهي بتاريخ'}: 07-07-2020',
//                                   //   style: TextStyle(color: Colors.orange),
//                                   // )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               color: Colors.black,
//                               size: 17,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Divider(),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DocDetailsIDBack(
//                                 user: widget.user,
//                               ),
//                             ));
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(),
//                         child: Row(
//                           children: <Widget>[
//                             idBack == '0'
//                                 ? Icon(Icons.warning,
//                                     size: 50, color: Colors.red)
//                                 : Icon(Icons.check_circle_outline,
//                                     size: 50, color: Colors.green[400]),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 loc == 'en'
//                                     ? 'National Identity(Back Side)'
//                                     : 'صورة الهوية أو رخصة الاقامة (الواجهة الخلفية)',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               color: Colors.black,
//                               size: 17,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Divider(),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         filePickerImg(context);
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(),
//                         child: Row(
//                           children: <Widget>[
//                             dp == '0'
//                                 ? Icon(Icons.warning,
//                                     size: 50, color: Colors.red)
//                                 : Icon(Icons.check_circle_outline,
//                                     size: 50, color: Colors.green[400]),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 loc == 'en' ? 'Driver Image' : 'صورة السائق',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               color: Colors.black,
//                               size: 17,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
