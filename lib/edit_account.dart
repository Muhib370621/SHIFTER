import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:shifter/controller/main_screen_controllers/front_page_controller.dart';
import 'package:shifter/loading.dart';
import 'package:shifter/services/local_storage/local_storage.dart';
import 'package:shifter/services/local_storage/local_storage_keys.dart';
import 'package:shifter/wrapper.dart';
import 'package:http/http.dart' as http;
import 'controller/main_screen_controllers/edit_account_controller.dart';
import 'core/utils/app_colors.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:shifter/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart';

// ignore: must_be_immutable
class EditAccount extends StatefulWidget {
  User user;

  EditAccount({required this.user});

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  bool load = false;
  String? loc;
  TextEditingController? fName, lName, mNo, eMail, pW;
  String? fNametx, lNametx, mNotx, eMailtx, pWtx;
  final editProfileController = Get.put(EditAccountController());
  final frontPageController = Get.put(FrontPageController());

  final _formKey = GlobalKey<FormState>();

  loadDriverData() {
    fName = new TextEditingController(
        text: frontPageController.userModel.value.firstName);
    lName = new TextEditingController(
        text: frontPageController.userModel.value.lastName);
    mNo = new TextEditingController(
        text: frontPageController.userModel.value.number);
    eMail = new TextEditingController(
        text: frontPageController.userModel.value.email);
    pW = new TextEditingController(text: "");
    setState(() {});
  }

//  Future<void>  driverdata() async {
//
//     String soap ='''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <DriverData xmlns="http://Mgra.WS/">
//       <ID>${widget.user.id}</ID>
//     </DriverData>
//   </soap:Body>
// </soap:Envelope>''';
//
//
//
//     http.Response response = await http
//                .post(Uri.parse( 'http://tryconnect.net/api/MgraWebService.asmx' ),
//             headers: {
//               "SOAPAction": "http://Mgra.WS/DriverData",
//               "Content-Type": "text/xml;charset=UTF-8",
//             },
//             body: utf8.encode(soap),
//             encoding: Encoding.getByName("UTF-8"))
//         .then((onValue) {
//       return onValue;
//     });
//     if (response.statusCode == 200) {
//       print(response.body);
//     String json =
//         parse(response.body).getElementsByTagName('DriverDataResult')[0].text;
//     final decoded = jsonDecode(json);
//     print(decoded);
//     fNametx = decoded['FirstName'];
//     lNametx = decoded['LastName'];
//     mNotx = decoded['Phone'];
//     eMailtx = decoded['Email'];
//     pWtx = decoded['Password'];
// }
//     fName = new TextEditingController(text: fNametx);
//     lName = new TextEditingController(text: lNametx);
//     mNo = new TextEditingController(text: mNotx);
//     eMail = new TextEditingController(text: eMailtx);
//     pW = new TextEditingController(text: pWtx);
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     if (fNametx != widget.user.firstName) prefs.setString('FirstName', fNametx!);
//
//     if (lNametx != widget.user.lastName) prefs.setString('LastName', lNametx!);
//
//     if (mNotx != widget.user.number) prefs.setString('PhoneNo', mNotx!);
//
//     if (eMailtx != widget.user.email) prefs.setString('Email', eMailtx!);
//
//     if (pWtx != widget.user.password) prefs.setString('Password', pWtx!);
//
//  setState(() {
//
//     });
//   }

  @override
  void initState() {
    loc = globals.loc;
    super.initState();

    loadData();
  }

  void loadData() async {
    setState(() {
      load = true;
    });
    await editProfileController.getDriverByID();
    loadDriverData();

    // await driverdata();
    setState(() {
      load = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    log("access token " +
        LocalStorage.readJson(key: LocalStorageKeys.accessToken));
    /*   Future resetPass(String newPass) async {
      var message;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: prefs.getString("Email").toString(),
              password: prefs.getString("Password").toString());
      if (result != null) {
        result.user
            .updatePassword(newPass)
            .then(
              (value) => message = 'Success',
            )
            .catchError((onError) => message = 'error');
      }
      return message;
    }
 */
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: load
          ? Scaffold(
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Loading()],
          ),
        ),
      )
          : Scaffold(
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
                    top: MediaQuery
                        .of(context)
                        .padding
                        .top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            loc == 'en' ? 'Edit Account' : 'تعديل الحساب',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            endIndent:
                            MediaQuery
                                .of(context)
                                .size
                                .width / 1.55,
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
                          child: Icon(Icons.arrow_forward,
                              color: Colors.white),
                        ))
                  ],
                ),
              ),
            )),
        body: Obx(() {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blue[100],
                          child: widget.user.photo!.isEmpty
                              ? Container()
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.memory(
                              base64Decode(widget.user.photo ?? ""),
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        ListTile(
                            title: Text(
                              loc == 'en' ? 'First Name' : 'الاسم الاول',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: TextFormField(
                              controller: fName,
                              validator: (val) {
                                if (val!.length == 0)
                                  return loc == 'en' ? 'Required' : 'مطلوب';
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        ListTile(
                            title: Text(
                              loc == 'en' ? 'Last Name' : 'الاسم الأخبر',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: TextFormField(
                              controller: lName,
                              validator: (val) {
                                if (val!.length == 0)
                                  return loc == 'en' ? 'Required' : 'مطلوب';
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        ListTile(
                            trailing: SizedBox(
                              width: 100,
                              height: 45,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffe5fae2),
                                    borderRadius:
                                    BorderRadius.circular(50)),
                                child: Center(
                                  child: Text(
                                      loc == 'en' ? 'Activated' : "مفعّل"),
                                ),
                              ),
                            ),
                            title: Text(
                              loc == 'en' ? 'Mobile No' : 'رقم الجوال',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: TextFormField(
                              controller: mNo,
                              validator: (val) {
                                if (val!.length == 0)
                                  return loc == 'en' ? 'Required' : 'مطلوب';
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        ListTile(
                            trailing: SizedBox(
                              width: 100,
                              height: 45,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xfffae2e2),
                                    borderRadius:
                                    BorderRadius.circular(50)),
                                child: Center(
                                  child: Text(loc == 'en'
                                      ? 'Unconfirmed'
                                      : "غير مؤكد"),
                                ),
                              ),
                            ),
                            title: Text(
                              loc == 'en' ? 'Email' : 'البريد الإلكتروني',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: TextFormField(
                              controller: eMail,
                              validator: (val) {
                                if (val!.length == 0)
                                  return loc == 'en' ? 'Required' : 'مطلوب';
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        ListTile(
                            title: Text(
                              loc == 'en' ? 'Password' : 'كلمة المرور',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: TextFormField(
                              controller: pW,
                              validator: (val) {
                                if (val!.length == 0)
                                  return loc == 'en' ? 'Required' : 'مطلوب';
                                else
                                  return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        editProfileController.updateDriver(
                            fName!.text, lName!.text, eMail!.text);
                      },
//                           onTap: () async {
//                             setState(() {
//                               load = true;
//                             });
//
//                             String soap =
//                                 '''<?xml version="1.0" encoding="utf-8"?>
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <UpdateDriver xmlns="http://Mgra.WS/">
//       <ID>${widget.user.id}</ID>
//       <FirstName>${fName!.text}</FirstName>
//       <LastName>${lName!.text}</LastName>
//       <Phone>${mNo!.text}</Phone>
//       <Email>${eMail!.text}</Email>
//       <Password>${pW!.text}</Password>
//     </UpdateDriver>
//   </soap:Body>
// </soap:Envelope>''';
//                             http.Response response = await http
//                                 .post(
//                                    Uri.parse(  'http://tryconnect.net/api/MgraWebService.asmx'),
//                                     headers: {
//                                       "SOAPAction":
//                                           "http://Mgra.WS/UpdateDriver",
//                                       "Content-Type": "text/xml;charset=UTF-8",
//                                     },
//                                     body: utf8.encode(soap),
//                                     encoding: Encoding.getByName("UTF-8"))
//                                 .then((onValue) {
//                               return onValue;
//                             });
//
//                             await addData(
//                                 fName!.text,
//                                 lName!.text,
//                                 eMail!.text,
//                                 pW!.text,
//                                 widget.user.id??"",
//                                 mNo!.text,
//                                 widget.user.city??"",
//                                 widget.user.photo??"");
//                             setState(() {
//                               load = false;
//                             });
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Wrapper()));
//                           },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 90),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Color(0xff2b2b2b),
                        ),
                        child: editProfileController.isLoading.value
                            ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.pureWhite,
                          ),
                        )
                            : Center(
                          child: Text(
                            loc == 'en' ? 'Update' : "تحديث",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
