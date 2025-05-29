import 'package:flutter/material.dart';
import 'account_icons.dart';

class HelpThree extends StatefulWidget {
  @override
  _HelpThreeState createState() => _HelpThreeState();
}

class _HelpThreeState extends State<HelpThree> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
              backgroundColor: Color(0xff3c2c63),
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'المساعدة',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            endIndent: MediaQuery.of(context).size.width / 1.55,
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
                              child: Icon(Icons.arrow_forward,
                                  color: Colors.white))
                  ],
                ),
              ),
            )),
            body: SingleChildScrollView(
                          child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Text('واجهتني مشكلة تتعلق بخدمة التوصيل',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Account.account_1),
                      SizedBox(width: 15),
                      Expanded(child: Text('لم أتمكن من العثور على عاشق الطعام/تأخر عاشق الطعام في الوصول')),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Account.account_1),
                      SizedBox(width: 15),
                      Expanded(child: Text('لقد تم توصيل الصنف (الأصناف)  غير الصحيح')),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Account.account_1),
                      SizedBox(width: 15),
                      Expanded(child: Text('لا يمكنني إتمام خدمة توصيل الطلب التابعة لي')),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Account.account_1),
                      SizedBox(width: 15),
                      Expanded(child: Text('لقد أنهيت الرحلة عن طريق الخطأ')),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Account.account_1),
                      SizedBox(width: 15),
                      Expanded(child: Text('لقد واجهت مشكلة في الانتظار')),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Account.account_1),
                      SizedBox(width: 15),
                      Expanded(child: Text('أواجه مشكلة مختلفة في أداء خدمة التوصيل')),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Account.account_1),
                      SizedBox(width: 15),
                      Expanded(child: Text('قام العميل بتغيير عنوان التوصيل')),
                    ],
                  ),
                ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}