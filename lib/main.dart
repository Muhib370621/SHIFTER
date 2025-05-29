import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shifter/services/local_storage/local_storage.dart';
import 'package:shifter/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

import 'package:url_launcher/url_launcher.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool result = await hasLanguage();
  if (result == false) {
    await addStringToSF();
    globals.loc = 'en';
  } else {
    globals.loc = await getStringValuesSF();
  }
    // await Firebase.initializeApp();
LocalStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

 _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
 _showVersionDialog(context) async {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "تحديث جديد";
        String message = "تم اصدار تحديث جديد للتطبيق، يرجى التحديث الان";
        String btnLabel = "حدث الان";

        if (globals.loc == 'en') {
          title = "New Update Available";
          message =
              "There is a newer version of app available please update it now.";
          btnLabel = "Update Now";
        }

        return new AlertDialog(
          title: Text(
            title,
            textDirection: globals.loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
          ),
          content: Text(
            message,
            textDirection: globals.loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
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

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    //    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;


    // try {
    //   // Using default duration to force fetching from remote server.
    //   await remoteConfig.fetch();
    //   //expiration: const Duration(seconds: 0)
    //   await remoteConfig.fetchAndActivate();
    //   remoteConfig.getString('force_update_current_version');
    //   double newVersion = double.parse(remoteConfig
    //       .getString('force_update_current_version')
    //       .trim()
    //       .replaceAll(".", ""));
    //   if (newVersion > currentVersion) {
    //     _showVersionDialog(context);
    //   }
    // } catch (exception) {
    //   print('Unable to fetch remote config. Cached or default values will be '
    //       'used');
    // }
  }

Future<String> getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('Language')?? 'en';
  return stringValue;
}

Future<void> addStringToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('Language', "en");
}

Future<bool> hasLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool checkValue = prefs.containsKey('Language');
  return checkValue;
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
     versionCheck(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          navigatorObservers: [globals.routeObserver],
          title: 'Shifter',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {'/wrapper': (context) => Wrapper()},
          theme: ThemeData(
            fontFamily: 'Almarai',
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: WillPopScope(onWillPop: () async => false, child: Wrapper()),
        );
      },
      child: Wrapper(),
    );

  }
}
