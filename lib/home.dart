
import 'package:flutter/material.dart';
import 'package:shifter/login.dart';
import 'package:shifter/register.dart';
import 'package:location/location.dart';
import 'globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? loc;
  var location = Location();
  PermissionStatus? status;
  @override
  void initState() {
    loc = globals.loc;
   // versionCheck(context);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      status = await location.hasPermission();
      if (status != PermissionStatus.granted) {
        _showPermissionDialog(context);
      }
    });
  }

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      //expiration: const Duration(seconds: 0)
      await remoteConfig.fetch();
      await remoteConfig.fetchAndActivate();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    }  catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showPermissionDialog(context) async {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "أذونات";
        String message =
            "يجمع هذا التطبيق بيانات الموقع لتتبع الموقع الحالي للسائق حتى عندما يكون التطبيق مغلقًا أو غير مستخدم";
        String btnLabel = "نعم";

        if (loc == 'en') {
          title = "Permissions";
          message =
          "This app collects location data to track current location of driver even when the app is closed or not in use";
          btnLabel = "Ok";
        }

        return WillPopScope(
          onWillPop: () async => false,
          child: new AlertDialog(
            title: Text(
              title,
              textDirection:
              loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
            ),
            content: Text(
              message,
              textDirection:
              loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
            ),
            actions: <Widget>[
              ElevatedButton(
                  child: Text(btnLabel, textAlign: TextAlign.center),
                  onPressed: () {
                    Navigator.pop(context);
                    location.requestPermission();
                  }),
            ],
          ),
        );
      },
    );
  }

  _showVersionDialog(context) async {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "تحديث جديد";
        String message = "تم اصدار تحديث جديد للتطبيق، يرجى التحديث الان";
        String btnLabel = "حدث الان";

        if (loc == 'en') {
          title = "New Update Available";
          message =
              "There is a newer version of app available please update it now.";
          btnLabel = "Update Now";
        }

        return new AlertDialog(
          title: Text(
            title,
            textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
          ),
          content: Text(
            message,
            textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(btnLabel, textAlign: TextAlign.center),
              onPressed: () => _launchURL(
                  'https://play.google.com/store/apps/details?id=com.example.shifter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //_showPermissionDialog(context);
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor:Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
         
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Image.asset(
                      'assets/mobilescreen.png',
                      fit: BoxFit.fill,
                  
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(height: 50,),
              Container(
                 padding: EdgeInsets.only(
              right: 30,
              left: 30),
              
              child: Column(
                  mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
                children:  <Widget>[
                
              Text(
                loc == 'en'
                    ? 'Welcome to the Shifter Captain application\nthe captain version'
                    : 'مرحبا في تطبيق شفتر \nنسخة الكابتن',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                   textAlign: loc == 'en' ? TextAlign.left : TextAlign.right,
              ),
              SizedBox(
                height: 20,
              ),
             
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                            color:Colors.black,
                           ),
                        child: Center(
                          child: Text(
                            loc == 'en' ? 'Login' : 'تسجيل دخول',
                            style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Color(0xffd0d0d0),
                           ),
                        child: Center(
                          child: Text(
                              loc == 'en' ? 'Registration' : 'تسجيل جديد',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              )
        ]   ),) ],
          ),
        ),
      ),
    );
  }
}
