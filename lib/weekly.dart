import 'package:flutter/material.dart';
import 'package:shifter/earnings_main.dart';
import 'package:shifter/operations.dart';
import 'package:shifter/user.dart';
import 'package:shifter/weekly_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';

class Weekly extends StatefulWidget {
  final User user;
  Weekly({required this.user});
  @override
  _WeeklyState createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  String? loc;
  List<WeeklySeries> data = <WeeklySeries>[];
  String duration = '',
      total = '',
      trip = '',
      takeen = '',
      debtor = '',
      creditor = '';

  loadData() async {
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <WeeklySummery xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
    </WeeklySummery>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(
      Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
      headers: {
        "SOAPAction": "http://Mgra.WS/WeeklySummery",
        "Content-Type": "text/xml;charset=UTF-8",
      },
      body: utf8.encode(soap),
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((onValue) {
      return onValue;
    });
    String json = parse(response.body)
        .getElementsByTagName('WeeklySummeryResult')[0]
        .text;
    final decoded = jsonDecode(json);
    print(decoded);
    duration = decoded['Duration'];
    total = decoded['Total'];
    trip = decoded['TripsCounter'];
    takeen = decoded['Taken'];
    debtor = decoded['Debtor'];
    creditor = decoded['Creditor'];
    data.add(WeeklySeries(
        earning: double.parse(decoded['Monday']),
        day: "Mon",
        barColor: Color(0xffb1e7d7)));
    data.add(WeeklySeries(
        earning: double.parse(decoded['Tuesday']),
        day: "Tue",
        barColor: Color(0xffb1e7d7)));
    data.add(WeeklySeries(
        earning: double.parse(decoded['Wednesday']),
        day: 'Wed',
        barColor: Color(0xffb1e7d7)));
    data.add(WeeklySeries(
        earning: double.parse(decoded['Thursday']),
        day: "Thu",
        barColor: Color(0xffb1e7d7)));
    data.add(WeeklySeries(
        earning: double.parse(decoded['Friday']),
        day: "Fri",
        barColor: Color(0xffb1e7d7)));
    data.add(WeeklySeries(
        earning: double.parse(decoded['Saturday']),
        day: "Sat",
        barColor: Color(0xffb1e7d7)));
    data.add(WeeklySeries(
        earning: double.parse(decoded['Sunday']),
        day: "Sun",
        barColor: Color(0xffb1e7d7)));
    setState(() {});
  }

  @override
  void initState() {
    loc = globals.loc;
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EarningsMain(user: widget.user),
              ));
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: AppBar(
                backgroundColor: Color(0xff2b2b2b),
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
                              loc == 'en' ? 'Weekly' : 'أسبوعي',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              endIndent:
                                  MediaQuery.of(context).size.width / 1.6,
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
                                  color: Colors.white)))
                    ],
                  ),
                ),
              )),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '$duration',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'SAR $total',
                          style: TextStyle(fontSize: 26),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(loc == 'en' ? 'Income' : 'الدخل',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                barGroups: data
                                    .asMap()
                                    .entries
                                    .map((entry) => BarChartGroupData(
                                          x: entry.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: entry.value.earning.toDouble(),
                                              color: entry.value.barColor,
                                            )
                                          ],
                                        ))
                                    .toList(),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                    )
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: (value, meta) {
      int index = value.toInt();
      if (index >= 0 && index < data.length) {
        return Text(
          data[index].day,
          style: TextStyle(fontSize: 12), // Customize the font size as needed
        );
      }
      return SizedBox(); // Return an empty SizedBox if no title is available
    },
                                    )
                                  )
                                
                             /*      bottomTitles: SideTitles(
                                  
                                    getTitles: (value) {
                                      int index = value.toInt();
                                      if (index >= 0 && index < data.length) {
                                        return data[index].day;
                                      }
                                      return '';
                                    },
                                    margin: 10,
                                    reservedSize: 30,
                                  ), */
                                ),
                              ),
                             
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text('$trip', style: TextStyle(fontSize: 23)),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Icon(
                                      Icons.help,
                                      color: Colors.grey,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  loc == 'en' ? 'Trips' : 'الرحلات',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 1.0,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text('$takeen', style: TextStyle(fontSize: 23)),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Icon(
                                      Icons.help,
                                      color: Colors.grey,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  loc == 'en'
                                      ? 'Schedule Time'
                                      : 'الوقت المجدول',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(loc == 'en' ? 'Debtor' : 'دائن',
                                  style: TextStyle(fontSize: 15)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                loc == 'en' ? 'Creditor' : 'مدين',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('-SAR $debtor',
                                  style: TextStyle(fontSize: 15)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '+SAR $creditor',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Operations(user: widget.user),
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 80),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xff2b2b2b),
                      ),
                      child: Center(
                        child: Text(
                          loc == 'en' ? 'Operations View' : 'عرض العمليات',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
