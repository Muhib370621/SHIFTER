import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeLanguage extends StatefulWidget {
  @override
  _HomeLanguageState createState() => _HomeLanguageState();
}

class _HomeLanguageState extends State<HomeLanguage> {
  String? loc;

   @override
  void initState() {
    loc = globals.loc;
    super.initState();
  
  }
  Future<void> addStringToSF(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Language', val);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xff3c2c63),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 100,
              right: 30,
              left: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/home_driver_c.png',
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                loc == 'en'
                    ? 'Welcome to the\n Shifter Captain application to connect \nthe captain version'
                    : 'مرحبا في\nتطبيق شفتر للتوصيل\nنسخة الكابتن',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffd0d0d0)),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                endIndent: MediaQuery.of(context).size.width / 1.5,
                color: Color(0xffd0d0d0),
                thickness: 2.0,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                      await addStringToSF(loc ='ar');
                         globals.loc = loc = 'ar' ;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ));
                      //login
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Color(0xff63b1ac),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            'عربي',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                      onTap: () async {
                      await addStringToSF(loc = 'en' );
                         globals.loc = loc = 'en' ;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ));
                      //login
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Color(0xffd0d0d0),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                               'English',
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
            ],
          ),
        ),
      ),
    );
  }
}
