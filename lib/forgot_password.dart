import 'package:flutter/material.dart';
import 'package:shifter/login.dart';
import 'package:shifter/register.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? loc;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: loc=='en'?TextDirection.ltr:TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.white,
        appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          loc=='en'?'Restore Password':'إستعادة كلمة المرور',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: loc=='en'?'Mobile No/Email':'البريد الإلكتروني'
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffc0d8df),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Center(child: Text(loc=='en'?'Next':'التالى',style: TextStyle(fontWeight: FontWeight.bold),),),
                  ),
                ),
                SizedBox(height: 40,),
                ListView(
                  shrinkWrap: true,
                      children: ListTile.divideTiles(context: context, tiles: [
                        ListTile(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
                          },
                          dense: true,
                          title: Text(
                            loc=='en'?'No account? Register now':'ليس لديك حساب؟ سجل الان',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 14),
                        ),
                       /*  ListTile(
                          dense: true,
                          title: Text(
                            loc=='en'?'Have a problem with your account? Ask for help':'لديك مشكلة مع حسابك؟ أطلب المساعدة',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 14),
                        ), */
                      ]).toList(),
                    )
            ],
          ),
        ),
      ),
      ),
    );
  }
}