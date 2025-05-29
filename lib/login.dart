/* import 'package:firebase_auth/firebase_auth.dart'; */
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shifter/controller/login_driver_controller.dart';
import 'package:shifter/loading.dart';
import 'package:shifter/user.dart';
import 'package:shifter/wrapper.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool obscure = true;
  bool load = false;
  String error = '';
  String loc = "";
  String cred = "",
      password = "";
  String token = "";
  bool forgetValidation = false;

  final _formKey = GlobalKey<FormState>();

  addData(String firstName, String lastName, String email, String password,
      String id, String phone, String city, String photo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FirstName', firstName);
    prefs.setString('LastName', lastName);
    prefs.setString('Email', email);
    prefs.setString('Password', password);
    prefs.setString('ID', id);
    prefs.setString('Photo', photo);
    prefs.setString('City', city);
    prefs.setString('PhoneNo', phone);
  }

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  _getToken() {
    // _firebaseMessaging.getToken().then((value) {
    //   setState(() {
    //     token = value!;
    //   });
    // });
  }

  @override
  void initState() {
    loc = globals.loc;
    super.initState();
    _getToken();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginDriverController());
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .padding
                    .top, bottom: 20),
            child: Obx(() {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/mobilescreen.png',
                        fit: BoxFit.fill,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                      ),
                      SizedBox(height: 30,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              loc == 'en' ? 'Login' : 'تسجيل دخول',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: loginController
                                    .phoneNumberController.value,
                                validator: (val) {
                                  if (val!.length == 0)
                                    return loc == 'en' ? 'Required' : 'مطلوب';
                                  else
                                    return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    cred = val;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: loc == 'en'
                                        ? 'Phone Number'
                                        : 'البريد الإلكتروني'),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 20),
                      //   child: Row(
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: TextFormField(
                      //           controller: loginController.phoneNumberController.value,
                      //
                      //           keyboardType: TextInputType.emailAddress,
                      //           validator: (val) {
                      //             if (val!.length == 0 && !forgetValidation)
                      //               return loc == 'en' ? 'Required' : 'مطلوب';
                      //             else
                      //               return null;
                      //           },
                      //           onChanged: (val) {
                      //             setState(() {
                      //               password = val;
                      //             });
                      //           },
                      //           obscureText: obscure,
                      //           decoration: InputDecoration(
                      //               suffixIcon: GestureDetector(
                      //                   onTap: () {
                      //                     setState(() {
                      //                       obscure = !obscure;
                      //                     });
                      //                   },
                      //                   child: Icon(obscure
                      //                       ? Icons.visibility_off
                      //                       : Icons.visibility)),
                      //               contentPadding: EdgeInsets.symmetric(
                      //                   horizontal: 10, vertical: 10),
                      //               hintText:
                      //                   loc == 'en' ? 'Password' : 'كلمة المرور'),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              forgetValidation = true;
                            });
                            if (_formKey.currentState
                            !.validate()) //validate email just.
                                {
                              loginController.login();
//                             String soap =
//                                 '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//       <ResetPass xmlns="http://Mgra.WS/">
//           <Email>$cred</Email>
//           <userType>1</userType>
//       </ResetPass>
//   </soap:Body>
// </soap:Envelope>''';
//                             http.Response response = await http
//                                 .post(
//                                     Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                     headers: {
//                                       "SOAPAction": "http://Mgra.WS/ResetPass",
//                                       "Content-Type": "text/xml;charset=UTF-8",
//                                     },
//                                     body: utf8.encode(soap),
//                                     encoding: Encoding.getByName("UTF-8"))
//                                 .then((onValue) {
//                               return onValue;
//                             });
//
//                             if (response.statusCode == 200) {
//                               String json = parse(response.body)
//                                   .getElementsByTagName('ResetPassResult')[0]
//                                   .text;
//                               showDialog(
//                                 context: context,
//                                 builder: (context) => Dialog(
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 15, vertical: 30),
//                                     child: Text(json),
//                                   ),
//                                 ),
//                               );
//                             }
                            }
                            setState(() {
                              forgetValidation = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(),
                            child: Text(
                              loc == 'en'
                                  ? 'Forgot Password'
                                  : 'هل نسيت كلمة المرور',
                              style: TextStyle(
                                  color: Colors.blue[400], fontSize: 13),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$error',
                            style: TextStyle(color: Colors.red),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      !loginController.isLoading.value
                          ? GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            loginController.login();
//                                 setState(() {
//                                   forgetValidation = false;
//                                   load = true;
//                                 });
//                                 String soap =
//                                     '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <LoginDriver xmlns="http://Mgra.WS/">
//       <Username>$cred</Username>
//       <Password>$password</Password>
//       <language>$loc</language>
//     </LoginDriver>
//   </soap:Body>
// </soap:Envelope>''';
//                                 http.Response response = await http
//                                     .post(
//                                         Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                         headers: {
//                                           "SOAPAction":
//                                               "http://Mgra.WS/LoginDriver",
//                                           "Content-Type":
//                                               "text/xml;charset=UTF-8",
//                                         },
//                                         body: utf8.encode(soap),
//                                         encoding: Encoding.getByName("UTF-8"))
//                                     .then((onValue) {
//                                   return onValue;
//                                 });
//                                 print(response.body);
//                                 setState(() {
//                                   load = false;
//                                 });
//                                 if (response.statusCode == 200) {
//                                   String json = parse(response.body)
//                                       .getElementsByTagName(
//                                           'LoginDriverResult')[0]
//                                       .text;
//                                   final decoded = jsonDecode(json);
//                                   if (decoded ==
//                                           "Username or Password incorrect" ||
//                                       decoded == "error" ||
//                                       decoded == "") {
//                                     print('true');
//                                     setState(() {
//                                       error = loc == 'en'
//                                           ? 'Invalid Username or Password'
//                                           : 'اسم المستخدم او كلمة المرور غير صحيح';
//                                     });
//                                   } else {
//                                     /*  AuthResult result = await FirebaseAuth
//                                         .instance
//                                         .signInWithEmailAndPassword(
//                                             email: cred, password: password); */
//                                     print(decoded);
//                                     // await _firebaseMessaging
//                                     //     .getToken()
//                                     //     .then((value) {
//                                     //   token = value!;
//                                     // });
//                                     String soapToken =
//                                         '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <UpdateDriverToken xmlns="http://Mgra.WS/">
//       <ID>${decoded['ID'].toString()}</ID>
//       <firebase_tokenkey>$token</firebase_tokenkey>
//     </UpdateDriverToken>
//   </soap:Body>
// </soap:Envelope>''';
//                                     http.Response response = await http
//                                         .post(
//                                             Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//                                             headers: {
//                                               "SOAPAction":
//                                                   "http://Mgra.WS/UpdateDriverToken",
//                                               "Content-Type":
//                                                   "text/xml;charset=UTF-8",
//                                             },
//                                             body: utf8.encode(soapToken),
//                                             encoding:
//                                                 Encoding.getByName("UTF-8"))
//                                         .then((onValue) {
//                                       return onValue;
//                                     });
//                                     print(response.body);
//                                     User user = User(
//                                         firstName: decoded['FirstName'],
//                                         lastName: decoded['LastName'],
//                                         id: decoded['ID'].toString(),
//                                         email: decoded['Email'],
//                                         password: decoded['Password'],
//                                         number: decoded['Phone'],
//                                         city: decoded['City'],
//                                         photo: decoded['Img'],
//                                         status: "");
//                                     await addData(
//                                         decoded['FirstName'],
//                                         decoded['LastName'],
//                                         decoded['Email'],
//                                         decoded['Password'],
//                                         decoded['ID'].toString(),
//                                         decoded['Phone'],
//                                         decoded['City'],
//                                         decoded['Img']);
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => Wrapper()));
//                                   }
//                                 } else {
//                                   setState(() {
//                                     error = loc == 'en'
//                                         ? 'Unknown Error'
//                                         : 'خطأ غير معروف';
//                                   });
//                                 }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 70),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xff2b2b2b),),
                          child: Center(
                            child: Text(
                              loc == 'en' ? 'Login' : 'تسجيل دخول',
                              style: TextStyle(fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Loading(),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }
}
