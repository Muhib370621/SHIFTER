import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shifter/front_page.dart';
import 'package:shifter/home.dart';
import 'package:shifter/incoming_messages.dart';
import 'package:shifter/loading.dart';
import 'package:shifter/location_service.dart';
import 'package:shifter/order_details.dart';
import 'package:shifter/payment_ask.dart';
import 'package:shifter/user.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

late User user = User(
    firstName: '',
    lastName: '',
    id: '',
    email: '',
    password: '',
    number: '',
    city: '',
    photo: '',
    status: "");

// FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
// FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
late BuildContext notifyContext;

Future onSelectNotify(String? payload) async {
  var data = json.decode(payload!);
  print('Click');
  print(data['notificationtype']);
  if (data['notificationtype'] == 'SMS' ||
      data['notificationtype'] == 'Offer') {
    Navigator.push(
        notifyContext,
        MaterialPageRoute(
          builder: (context) => IncomingMessages(user: globals.user!),
        ));
  } else if (data['notificationtype'] == 'OrderUpdate') {
    if (data['type'] == '1') {
      Navigator.push(
          notifyContext,
          MaterialPageRoute(
            builder: (context) =>
                OrderDetails(
                  user: globals.user!,
                  orderid: data['ID'],
                ),
          ));
    } else {
      Navigator.push(
          notifyContext,
          MaterialPageRoute(
            builder: (context) =>
                OrderDetails(
                  user: globals.user!,
                  orderid: data['ID'],
                  /* ordertype: '2', */
                ),
          ));
    }
  } else if (data['notificationtype'] == 'ViewOrder' ||
      data['notificationtype'] == 'CancelOrder') {
    if (data['notificationtype'] == 'CancelOrder') {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('ColorStatus', '2');
    }

    if (data['type'] == '1') {
      final key = GlobalKey<FrontPageState>();
      globals.keys.add(key);
      Navigator.push(
          notifyContext,
          MaterialPageRoute(
              builder: (context) =>
                  WillPopScope(
                      onWillPop: () async => false,
                      child: FrontPage(
                        user: user,
                        tab: 2,
                        // key: key,
                      ))));
    } else {
      final key = GlobalKey<FrontPageState>();
      globals.keys.add(key);
      Navigator.push(
          notifyContext,
          MaterialPageRoute(
              builder: (context) =>
                  WillPopScope(
                      onWillPop: () async => false,
                      child: FrontPage(
                        user: user,
                        tab: 2,
                        // key: key,
                      ))));
    }
  } else if (data['notificationtype'] == 'Force') {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ColorStatus', '3');
    final key = GlobalKey<FrontPageState>();
    globals.keys.add(key);
    Navigator.push(
        notifyContext,
        MaterialPageRoute(
            builder: (context) =>
                WillPopScope(
                    onWillPop: () async => false,
                    child: FrontPage(
                      user: user,
                      tab: 1,
                      // key: key,
                    ))));
  }
  /*  else if (data['notificationtype'] == 'Chatting') {
    Navigator.push(
        notifyContext,
        MaterialPageRoute(
          builder: (context) => Chat(
              user: globals.user!,
              orderno: data['ID'],
              status: data['status'],
              type: data['type'],
              amount: data['amount'],
              custName: data['clientname']),
        ));
  } */ else if (data['notificationtype'] == 'payment') {
    Navigator.push(
        notifyContext,
        MaterialPageRoute(
          builder: (context) =>
              PaymentAsk(
                  orderId: data['ID'],
                  user: globals.user!,
                  type: data['type'],
                  sms: data['title']),
        ));
  } else if (data['notificationtype'] == 'active') {
    final key = GlobalKey<FrontPageState>();
    globals.keys.add(key);
    Navigator.push(
        notifyContext,
        MaterialPageRoute(
            builder: (context) =>
                WillPopScope(
                    onWillPop: () async => false,
                    child: FrontPage(
                      user: user,
                      tab: 0,
                      // key: key,
                    ))));
  }
  /*  else if (data['notificationtype'] == 'Invoice') {
    Navigator.push(
        notifyContext,
        MaterialPageRoute(
          builder: (context) => Chat(
              user: globals.user,
              orderno: data['ID'],
              status: data['status'],
              type: data['type'],
              amount: data['amount'],
              custName: data['clientname']),
        ));
  } */ else if (data['notificationtype'] == 'Order') {
    final key = GlobalKey<FrontPageState>();
    globals.keys.add(key);
    Navigator.push(
        notifyContext,
        MaterialPageRoute(
            builder: (context) =>
                WillPopScope(
                    onWillPop: () async => false,
                    child: FrontPage(
                      user: user,
                      tab: 0,
                      // key: key,
                    ))));

    /*  Navigator.push(
        notifyContext,
        MaterialPageRoute(
          builder: (context) => MapTwo(
            user: globals.user,
            orderid: data['ID'],
            type: data['type'],
            custName: data['clientname'],
            dropoff: data['dropoff'],
            p: data['profit'],
            ev: data['expectedvalue'],
            distance: data['distance'],
            timeSlot: data['timeslot'],
          ),
        ));
  */
  } else if (data['notificationtype'] == 'Reached') {} else {}
}

Future _showNotificationWithDefaultSound(String title, String data) async {
  // var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //     'noti_push_1', 'noti_push',
  //     playSound: true,
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     sound: RawResourceAndroidNotificationSound('notify'));
  //
  //
  // //  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  // var platformChannelSpecifics = new NotificationDetails(
  //     android: androidPlatformChannelSpecifics);
  // await flutterLocalNotificationsPlugin!.show(
  //     0, 'Connect', '$title', platformChannelSpecifics,
  //     payload: data);

  /* var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin!
      .show(0, 'Galaxy Driver', title, platformChannelSpecifics, payload: data); */
}


@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage data) async {
  //print('Notification is received in background');
  Map message = data.data;
  var initializationAndroid =
//   const AndroidInitializationSettings('ic_stat_name');
// //  var initializationIos = const IOSInitializationSettings();
//   var initialization = InitializationSettings(
//       android: initializationAndroid);
//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  /* flutterLocalNotificationsPlugin!
      .initialize(initialization, onSelectNotification: onSelectNotify);
 */
  _showNotificationWithDefaultSound(
      '${message['title']}', json.encode(message));

  if (message.containsKey('notification')) {
    // Handle notification message
    // ignore: unused_local_variable
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}


class Wrapper extends StatefulWidget {
  final int tab;

  Wrapper({this.tab = 0});

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with WidgetsBindingObserver {
  bool del = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          toMapCheck();
          _WrapperState createState() => _WrapperState();
          break;
        case AppLifecycleState.inactive:
          print("app in inactive");
          break;
        case AppLifecycleState.paused:
          print("app in paused");
          break;
        case AppLifecycleState.detached:
          print("app in detached");
          break;
        default:
        // Handle AppLifecycleState.hidden or other unexpected states
          break;
      }
    });
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String orderid = "";
  String type = "";
  String custName = "";
  String dropoff = "";
  String timeSlot = "";
  String ev = "";
  String p = "";
  String distance = "";
  String delflag = "";
  String colorstatus = "";
  var data;
  bool gettingData = false;

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('Email') ?? '';
    print(stringValue);
    return stringValue;
  }

  Future<String> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('Password') ?? '';
    return stringValue;
  }

  Future<String> getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('FirstName') ?? '';
    return stringValue;
  }

  Future<String> getLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('LastName') ?? '';
    return stringValue;
  }

  Future<String> getCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('City') ?? '';
    return stringValue;
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('ID') ?? '';
    return stringValue;
  }

  Future<String> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('PhoneNo') ?? '';
    return stringValue;
  }

  Future<String> getPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('Photo') ?? '';
    return stringValue;
  }

  void loadData() async {
    setState(() {
      gettingData = true;
    });
    user = User(
        firstName: await getFirstName(),
        lastName: await getLastName(),
        email: await getEmail(),
        password: await getPassword(),
        id: await getID(),
        city: await getCity(),
        photo: await getPhoto(),
        number: await getPhone()
        ,
        status: '');
    toMapCheck();
    globals.user = user;
    String token = "";

    // await _firebaseMessaging.getToken().then((value) {
    //   token = value!;
    // });

    String soapToken = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
<UpdateDriverToken xmlns="http://Mgra.WS/">
  <ID>${user.id}</ID>
  <firebase_tokenkey>$token</firebase_tokenkey>
</UpdateDriverToken>
</soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
        headers: {
          "SOAPAction": "http://Mgra.WS/UpdateDriverToken",
          "Content-Type": "text/xml;charset=UTF-8",
        },
        body: utf8.encode(soapToken),
        encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    print(response.body);
    print('Token is: $token');
    setState(() {
      gettingData = false;
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
              onPressed: () =>
                  _launchURL(
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
    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch();
      //expiration: const Duration(seconds: 0)
      await remoteConfig.fetchAndActivate();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  void toMapCheck() async {
    String soap2 = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
  <checkdefpageV2 xmlns="http://Mgra.WS/">
    <DriverID>${user.id}</DriverID>
    <language>${globals.loc}</language>
  </checkdefpageV2>
</soap:Body>
</soap:Envelope>''';
    http.Response response2 = await http
        .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
        headers: {
          "SOAPAction": "http://Mgra.WS/checkdefpageV2",
          "Content-Type": "text/xml;charset=UTF-8",
        },
        body: utf8.encode(soap2),
        encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    String json = parse(response2.body)
        .getElementsByTagName('checkdefpageV2Result')[0]
        .text;
    final decoded = jsonDecode(json);

    print(decoded);
    if (decoded['ID'] != null) {
      orderid = decoded['ID'];
      type = decoded['type'];
      p = decoded['profit'];
      ev = decoded['expectedvalue'];
      distance = decoded['distance'];
      custName = decoded['clientname'];
      dropoff = decoded['dropoff'];
      timeSlot = decoded['timeslot'];
    }
    delflag = decoded['deleteflag'];
    colorstatus = decoded['ColorStatus'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ColorStatus', colorstatus);
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("FirstName");
    prefs.remove("LastName");
    prefs.remove("Email");
    prefs.remove("Password");
    prefs.remove("ID");
    prefs.remove("Photo");
    prefs.remove("City");
    prefs.remove("PhoneNo");
  }

  void checkdelete() async {
    setState(() {
      del = true;
    });
    if (delflag == '1') {
      String tempID = user.id??"";
      await removeValues();
      String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <logout xmlns="http://Mgra.WS/">
      <UserID>${user.id}</UserID>
      <type>1</type>
    </logout>
  </soap:Body>
</soap:Envelope>''';
      http.Response response = await http
          .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
          headers: {
            "SOAPAction": "http://Mgra.WS/logout",
            "Content-Type": "text/xml;charset=UTF-8",
          },
          body: utf8.encode(soap),
          encoding: Encoding.getByName("UTF-8"))
          .then((onValue) {
        return onValue;
      });

      final databaseReference = FirebaseDatabase.instance.ref();
      databaseReference.child(tempID).remove();
      user = globals.user!;
      // heba comment = null
      /*  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WillPopScope(onWillPop: () async => false, child: Home()))); */
    }
    setState(() {
      del = false;
    });
  }

  void _loadingInitialData() async {
    await Future.delayed(Duration(seconds: 8)).then((v) {
      setState(() {
        gettingData = false;
      });
    });
  }

  bool load = false;
  final key = GlobalKey<FrontPageState>();

  ReceivePort port = ReceivePort();

  _confirgure() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage data) async {
      Map message = data.data;
      Platform.isAndroid
          ? _showNotificationWithDefaultSound(
          '${message['title']}', json.encode(message))
          : _showNotificationWithDefaultSound(
          '${message['title']}', json.encode(message));

      try {
        if (globals.keys[globals.keys.length - 1].currentState?.controller.index == 0) {
          globals.keys[globals.keys.length - 1].currentState?.setState(() {
            globals.keys[globals.keys.length - 1].currentState?.loadOrders =
            true;
          });
          // await globals.keys[globals.keys.length - 1].currentState?.loadNew();
          globals.keys[globals.keys.length - 1].currentState?.setState(() {
            globals.keys[globals.keys.length - 1].currentState?.loadOrders =
            false;
          });
        } else if (globals.keys[globals.keys.length - 1].currentState?.controller.index == 1) {
          globals.keys[globals.keys.length - 1].currentState?.setState(() {
            globals.keys[globals.keys.length - 1].currentState?.loadOrders = true;
          });
          // await globals.keys[globals.keys.length - 1].currentState?.loadPending();

          globals.keys[globals.keys.length - 1].currentState?.setState(() {
            globals.keys[globals.keys.length - 1].currentState?.loadOrders = true;
          });
        } else {
          globals.keys[globals.keys.length - 1].currentState?.setState(() {
            globals.keys[globals.keys.length - 1].currentState?.loadOrders = true;
          });
          // await globals.keys[globals.keys.length - 1].currentState?.loadAll();

          globals.keys[globals.keys.length - 1].currentState?.setState(() {
            globals.keys[globals.keys.length - 1].currentState?.loadOrders = false;
          });
        }
      } catch (e) {}
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _showNotificationWithDefaultSound(
          '${message.data['title']}', json.encode(message.data));
    });
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    // await _firebaseMessaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
  }


  @override
  void initState() {
    // versionCheck(context);

    super.initState();

    var initializationAndroid =
    // const AndroidInitializationSettings('ic_stat_name');
    // //  var initializationIos = const IOSInitializationSettings();
    // var initialization = InitializationSettings(
    //     android: initializationAndroid);
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    /*  flutterLocalNotificationsPlugin!
        .initialize(initialization, onSelectNotification: onSelectNotify); */
    _confirgure();
    // _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);


    loadData();
    _loadingInitialData();

    WidgetsBinding.instance.addObserver(this);
    LocationService().locationStream;
  }

  @override
  Widget build(BuildContext context) {
    notifyContext = context;
    if (gettingData) {
      if (user.id == '') {
        return WillPopScope(
            onWillPop: () async => false,
            child: Home());
      }
      else {
        return Scaffold(
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
        );
      }
    } else {
      if (user.id == '') {
        return WillPopScope(
            onWillPop: () async => false,
            child: Home());
      }

      if (orderid == '' &&
          type == '' &&
          distance == '' &&
          custName == '' &&
          dropoff == '' &&
          timeSlot == '' &&
          ev == '' &&
          p == '') {
        if (delflag == '1') {
          return WillPopScope(
              onWillPop: () async => false,
              child: FrontPage(
                // key: key,
                tab: widget.tab,
                user: user,
              ));
        } else {
          return WillPopScope(
              onWillPop: () async => false,
              child: FrontPage(
                // key: key,
                tab: widget.tab,
                user: user,
              ));
        }
      } else {
        if (delflag == '1') {
          return WillPopScope(
              onWillPop: () async => false,
              child: FrontPage(
                // key: key,
                tab: widget.tab,
                user: user,
              ));
        } else {
          /* return MapTwo(
            user: user,
            distance: distance,
            ev: ev,
            p: p,
            custName: custName,
            dropoff: dropoff,
            timeSlot: timeSlot,
            orderid: orderid,
            type: type,
          ); */
          return WillPopScope(
              onWillPop: () async => false,
              child: FrontPage(
                // key: key,
                tab: widget.tab,
                user: user,
              ));
        }
      }
    }
  }
}
