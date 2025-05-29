// /* import 'package:firebase_auth/firebase_auth.dart'; */
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:shifter/loading.dart';
// import 'package:shifter/user.dart';
// import 'package:shifter/wrapper.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:html/parser.dart';
// import 'globals.dart' as globals;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Register extends StatefulWidget {
//   @override
//   _RegisterState createState() => _RegisterState();
// }
//
// class _RegisterState extends State<Register> {
//   bool load = false;
//   String? loc;
//   String? fname, lname, city, email, password, number;
//   String error = '';
//   String? token;
//   final _formKey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     loc = globals.loc;
//     super.initState();
//     _getToken();
//   }
//
//   // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   _getToken() {
//     // _firebaseMessaging.getToken().then((value) {
//     //   setState(() {
//     //     token = value;
//     //   });
//     // });
//   }
//
//   addData(String firstName, String lastName, String email, String password,
//       String id, String phone, String city, String photo) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('FirstName', firstName);
//     prefs.setString('LastName', lastName);
//     prefs.setString('Email', email);
//     prefs.setString('Password', password);
//     prefs.setString('ID', id);
//     prefs.setString('Photo', photo);
//     prefs.setString('City', city);
//     prefs.setString('PhoneNo', phone);
//     prefs.setString('Status', '0');
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
//               backgroundColor: Colors.white,
//               elevation: 0,
//               automaticallyImplyLeading: false,
//               flexibleSpace: Container(
//                 alignment: Alignment.bottomCenter,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 margin:
//                     EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       loc == 'en' ? 'Registration' : 'تسجيل جديد',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             )),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(20),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Expanded(
//                         child: TextFormField(
//                           validator: (val) {
//                             if (val!.length == 0)
//                               return loc == 'en' ? 'Required' : 'مطلوب';
//                             else
//                               return null;
//                           },
//                           onChanged: (val) {
//                             setState(() {
//                               fname = val;
//                             });
//                           },
//                           decoration: InputDecoration(
//                               hintText:
//                                   loc == 'en' ? 'First Name' : 'الاسم الاول'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                         child: TextFormField(
//                           validator: (val) {
//                             if (val!.length == 0)
//                               return loc == 'en' ? 'Required' : 'مطلوب';
//                             else
//                               return null;
//                           },
//                           onChanged: (val) {
//                             setState(() {
//                               lname = val;
//                             });
//                           },
//                           decoration: InputDecoration(
//                               hintText:
//                                   loc == 'en' ? 'Last Name' : 'الاسم الأخبر'),
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: TextFormField(
//                           validator: (val) {
//                             if (val!.length == 0)
//                               return loc == 'en' ? 'Required' : 'مطلوب';
//                             else
//                               return null;
//                           },
//                           onChanged: (val) {
//                             setState(() {
//                               email = val;
//                             });
//                           },
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                               hintText:
//                                   loc == 'en' ? 'Email' : 'البريد الإلكتروني'),
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: TextFormField(
//                           validator: (val) {
//                             if (val!.length == 0)
//                               return loc == 'en' ? 'Required' : 'مطلوب';
//                             else
//                               return null;
//                           },
//                           onChanged: (val) {
//                             setState(() {
//                               number = val;
//                             });
//                           },
//                           keyboardType: TextInputType.phone,
//                           decoration: InputDecoration(
//                               hintText:
//                                   loc == 'en' ? 'Mobile No' : 'رقم الجوال'),
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: TextFormField(
//                           validator: (val) {
//                             if (val!.length < 6)
//                               return loc == 'en'
//                                   ? 'Atleast 6 characters'
//                                   : '6 حروف على الأقل';
//                             else
//                               return null;
//                           },
//                           onChanged: (val) {
//                             setState(() {
//                               password = val;
//                             });
//                           },
//                           obscureText: true,
//                           decoration: InputDecoration(
//                               suffixIcon: GestureDetector(
//                                   child: Icon(Icons.visibility_off)),
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               hintText:
//                                   loc == 'en' ? 'Password' : 'كلمة المرور'),
//                         ),
//                       )
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: TextFormField(
//                           validator: (val) {
//                             if (val!.length == 0)
//                               return loc == 'en' ? 'Required' : 'مطلوب';
//                             else
//                               return null;
//                           },
//                           onChanged: (val) {
//                             setState(() {
//                               city = val;
//                             });
//                           },
//                           decoration: InputDecoration(
//                               hintText: loc == 'en' ? 'City' : 'المدينة'),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 25,
//                   ),
//                   Text(
//                     loc == 'en'
//                         ? 'By registering, I certify that I have read the terms and conditions of Shifter Delivery Company and have agreed to the terms of use policy'
//                         : 'عبر التسجيل، أقر بإنني قرأت الشروط والأحكام الخاصة بشركة شفتر للتوصيل وقد وافقت على ما جاء في سياسة الإستخدام',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                       loc == 'en'
//                           ? 'I also agree to the usage agreement with regard to delivery via the data attached above, and I confirm its authenticity. The Shifter Company for Delivery has the right to use this data for marketing purpose'
//                           : 'كذلك أوفق على اتفاقية الإستخدام فيما يتعلق بالتوصيل عبر البيانات المرفقة اعلاه، وأؤكد على صحتها، ويحق لشركة شفتر للتوصيل ان تقوم باستخدام هذه البيانات بغرض التسويق',
//                       style: TextStyle(fontSize: 12)),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     '$error',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   !load
//                       ? GestureDetector(
//                           onTap: () async {
//                             if (_formKey.currentState!.validate()) {
//                               setState(() {
//                                 load = true;
//                               });
//
//                               String soap =
//                                   '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <InsertDriver xmlns="http://Mgra.WS/">
//       <FirstName>$fname</FirstName>
//       <LastName>$lname</LastName>
//       <Phone>$number</Phone>
//       <Email>$email</Email>
//       <Password>$password</Password>
//       <City>$city</City>
//     </InsertDriver>
//   </soap:Body>
// </soap:Envelope>''';
//                               http.Response response = await http
//                                   .post(
//                                    Uri.parse(   'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                       headers: {
//                                         "SOAPAction":
//                                             "http://Mgra.WS/InsertDriver",
//                                         "Content-Type":
//                                             "text/xml;charset=UTF-8",
//                                       },
//                                       body: utf8.encode(soap),
//                                       encoding: Encoding.getByName("UTF-8"))
//                                   .then((onValue) {
//                                 return onValue;
//                               });
//
//                               if (response.statusCode == 200) {
//                                 String result = parse(response.body)
//                                     .getElementsByTagName(
//                                         'InsertDriverResult')[0]
//                                     .text;
//                                 final status = jsonDecode(result);
//
//                                 /*  if (status != '-1' && status != '0') {
//                                   AuthResult result = await FirebaseAuth
//                                       .instance
//                                       .createUserWithEmailAndPassword(
//                                           email: email, password: password);
//                                   FirebaseUser fuser = result.user;
//                                 } */
//                                 if (status == '-1') {
//                                   setState(() {
//                                     error = loc == 'en'
//                                         ? 'Account already exists'
//                                         : 'الحساب موجود بالفعل';
//                                   });
//                                   setState(() {
//                                     load = false;
//                                   });
//                                 } else if (status == '0') {
//                                   setState(() {
//                                     error = loc == 'en'
//                                         ? 'Please enter correct email!'
//                                         : 'يرجى ادخال ايميل صحيح';
//                                   });
//                                   setState(() {
//                                     load = false;
//                                   });
//                                 } else {
//                                   /*  AuthResult loginResult = await FirebaseAuth
//                                       .instance
//                                       .signInWithEmailAndPassword(
//                                           email: email, password: password); */
//                                   // _firebaseMessaging.getToken().then((value) {
//                                   //   token = value;
//                                   // });
//                                   String soapToken =
//                                       '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <UpdateDriverToken xmlns="http://Mgra.WS/">
//       <ID>$status</ID>
//       <firebase_tokenkey>$token</firebase_tokenkey>
//     </UpdateDriverToken>
//   </soap:Body>
// </soap:Envelope>''';
//                                   response = await http
//                                       .post(
//                                           Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                           headers: {
//                                             "SOAPAction":
//                                                 "http://Mgra.WS/UpdateDriverToken",
//                                             "Content-Type":
//                                                 "text/xml;charset=UTF-8",
//                                           },
//                                           body: utf8.encode(soapToken),
//                                           encoding: Encoding.getByName("UTF-8"))
//                                       .then((onValue) {
//                                     return onValue;
//                                   });
//                                   String soap =
//                                       '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <LoginDriver xmlns="http://Mgra.WS/">
//       <Username>$email</Username>
//       <Password>$password</Password>
//     </LoginDriver>
//   </soap:Body>
// </soap:Envelope>''';
//                                   response = await http
//                                       .post(
//                                            Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
//                                           headers: {
//                                             "SOAPAction":
//                                                 "http://Mgra.WS/LoginDriver",
//                                             "Content-Type":
//                                                 "text/xml;charset=UTF-8",
//                                           },
//                                           body: utf8.encode(soap),
//                                           encoding: Encoding.getByName("UTF-8"))
//                                       .then((onValue) {
//                                     return onValue;
//                                   });
//                                   String json = parse(response.body)
//                                       .getElementsByTagName(
//                                           'LoginDriverResult')[0]
//                                       .text;
//                                   final decoded = jsonDecode(json);
//                                   User user = User(
//                                       firstName: decoded['FirstName'],
//                                       lastName: decoded['LastName'],
//                                       id: decoded['ID'].toString(),
//                                       email: decoded['Email'],
//                                       password: decoded['Password'],
//                                       number: decoded['Phone'],
//                                       city: decoded['City'],
//                                       photo: decoded['Img'],
//                                       status: '0');
//                                   await addData(
//                                       decoded['FirstName'],
//                                       decoded['LastName'],
//                                       decoded['Email'],
//                                       decoded['Password'],
//                                       decoded['ID'].toString(),
//                                       decoded['Phone'],
//                                       decoded['City'],
//                                       decoded['Img']);
//                                   setState(() {
//                                     load = false;
//                                   });
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => Wrapper()));
//                                 }
//                               }
//                             }
//                           },
//                           child: Container(
//                             margin: EdgeInsets.symmetric(horizontal: 40),
//                             padding: EdgeInsets.all(15),
//                             decoration: BoxDecoration(
//                                 color: Color(0xffc0d8df),),
//                             child: Center(
//                               child: Text(
//                                 loc == 'en' ? 'Register' : 'تسجيل',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Loading(),
//                           ],
//                         )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
