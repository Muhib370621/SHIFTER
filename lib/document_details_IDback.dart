// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shifter/documents.dart';
// import 'package:shifter/user.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:flutter/services.dart';
// import 'dart:math' as math;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:html/parser.dart';
// import 'dart:io';
// import 'globals.dart' as globals;
//
// class DocDetailsIDBack extends StatefulWidget {
//   final User user;
//   DocDetailsIDBack({required this.user});
//   @override
//   _DocDetailsIDBackState createState() => _DocDetailsIDBackState();
// }
//
// class _DocDetailsIDBackState extends State<DocDetailsIDBack> {
//   late File file;
//   String fileName = '';
//   String loc = "";
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   Future filePickerImg(BuildContext context) async {
//     try {
//      // file = await FilePicker.getFile(type: FileType.image);
//       FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//       if (result != null) {
//         file = File(result.files.single.path!);
//       final tempDir = await path_provider.getTemporaryDirectory();
//       final path = tempDir.path;
//       fileName = path.split('/')[0];
//       int rand = new math.Random().nextInt(10000);
//       List<int> imageBytes = file.readAsBytesSync();
//       String base64Image = base64Encode(imageBytes);
//       String soap = '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
// <soap:Body>
//   <DriverIdentityBack xmlns="http://Mgra.WS/">
//     <ID>${widget.user.id}</ID>
//     <IdntityBack>$base64Image</IdntityBack>
//   </DriverIdentityBack>
// </soap:Body>
// </soap:Envelope>''';
//       http.Response response = await http
//           .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//               headers: {
//                 "SOAPAction": "http://Mgra.WS/DriverIdentityBack",
//                 "Content-Type": "text/xml;charset=UTF-8",
//               },
//               body: utf8.encode(soap),
//               encoding: Encoding.getByName("UTF-8"))
//           .then((onValue) {
//         return onValue;
//       });
//       String json = parse(response.body)
//           .getElementsByTagName('DriverIdentityBackResult')[0]
//           .text;
//       final decoded = jsonDecode(json);
//       if (decoded == '-1') {
//        /*  _scaffoldKey.currentState.showSnackBar(
//             SnackBar(content: Text(loc == 'en' ? 'Failed' : 'فشل'))); */
//       } else {
//         /* _scaffoldKey.currentState.showSnackBar(SnackBar(
//             content: Text(loc == 'en' ? 'Successfully Done' : 'تم بنجاح'))); */
//       }
//       await Future.delayed(Duration(seconds: 3)).then((v) {
//        // Navigator.pop(context);
//         Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Documents(
//                             user: widget.user,
//                           ),
//                         ));
//
//       });
//           }
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
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Documents(user: widget.user),
//             ));
//         return true;
//       },
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: Colors.white,
//           appBar: PreferredSize(
//               preferredSize: Size.fromHeight(80.0),
//               child: AppBar(
//                 backgroundColor: Color(0xff2b2b2b),
//                 elevation: 0,
//                 automaticallyImplyLeading: false,
//                 flexibleSpace: Container(
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   margin:
//                       EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               'المستندات والوثائق',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Divider(
//                               endIndent:
//                                   MediaQuery.of(context).size.width / 1.55,
//                               color: Colors.white,
//                               thickness: 2.0,
//                             ),
//                             SizedBox(
//                               height: 7,
//                             )
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                               decoration: BoxDecoration(),
//                               child: Icon(Icons.arrow_forward,
//                                   color: Colors.white)))
//                     ],
//                   ),
//                 ),
//               )),
//           body: SingleChildScrollView(
//             child: Container(
//               padding: EdgeInsets.all(25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     loc == 'en'
//                         ? 'National Identity(Back Side)'
//                         : 'الهوية الوطنية (الواجهة الخلفية)',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Text(loc == 'en'
//                       ? '1-Place the back-end ID photo'
//                       : '1-قم بوضع صورة الواجهة الخلفية للهوية'),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(loc == 'en'
//                       ? '2-Ensure that all image details are in the provided frame'
//                       : '2-قم بالتأكد بأن جميع تفاصيل الصورة في الإطار المخصص'),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(loc == 'en' ? '3-Take a picture' : '3-التقط الصورة'),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(loc == 'en'
//                       ? '4-Attach the photo and upload it'
//                       : '4-ارفق الصورة وقم برفعها'),
//                   SizedBox(
//                     height: 50,
//                   ),
//                   Center(
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 180,
//                       child: Image.asset(
//                         'assets/id_back.png',
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 50,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       filePickerImg(context);
//                     },
//                     child: Center(
//                       child: Container(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//                         decoration: BoxDecoration(
//                             color: Color(0xff2b2b2b),
//                           ),
//                         child: Text(
//                           loc == 'en' ? 'Upload Image' : 'رفع الصورة',
//                           style: TextStyle(fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
