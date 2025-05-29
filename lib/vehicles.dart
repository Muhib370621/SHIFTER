import 'package:flutter/material.dart';
import 'package:shifter/loading.dart';
import 'package:shifter/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'globals.dart' as globals;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:math' as math;
import 'dart:io';

String group = "";
final _scaffoldKey = GlobalKey<ScaffoldState>();

class Vehicles extends StatefulWidget {
  final User user;
  Vehicles({required this.user});
  @override
  _VehiclesState createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  bool load = false;

  String carPic = '', licensePic = '';
  String loc = "";
  TextEditingController carType = new TextEditingController();
  TextEditingController plateNo = new TextEditingController();
  List<VehicleWidget> vehicles = <VehicleWidget>[];
  final _overlayKey = GlobalKey<FormState>();
  late OverlayEntry overlayEntry;
  bool overlay = false;

  showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Directionality(
        textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(
                left: 15,
                right: 15,
                top: MediaQuery.of(context).padding.top,
                bottom: 15),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.all(10),
            child: Scaffold(
                backgroundColor: Colors.grey[200],
                body: StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        child: Form(
                          key: _overlayKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      overlayEntry.remove();
                                      setState(() {
                                        overlay = false;
                                      });
                                    },
                                    child: Icon(Icons.close, color: Colors.red),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  loc == 'en'
                                      ? 'Enter Car Type'
                                      : 'أدخل نوع المركبة',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return loc == 'en' ? 'Required' : 'مطلوب';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: carType,
                                decoration: InputDecoration(
                                    hintText: loc == 'en'
                                        ? 'Enter Car Type'
                                        : 'أدخل نوع المركبة'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                loc == 'en'
                                    ? 'Enter Plate No'
                                    : 'أدخل رقم اللوحة',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.newline,
                                maxLines: null,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return loc == 'en' ? 'Required' : 'مطلوب';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: plateNo,
                                decoration: InputDecoration(
                                    hintText: loc == 'en'
                                        ? 'Enter Plate No'
                                        : 'أدخل رقم اللوحة'),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        loc == 'en'
                                            ? 'Upload Car Pic'
                                            : 'ارفع صورة المركبة',
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          File file;
                                          String fileName = '';

                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles();

                                          if (result != null) {
                                            file =
                                                File(result.files.single.path!);
                                            /*  file = await FilePicker.getFile(
                                              type: FileType.image); */
                                            final tempDir = await path_provider
                                                .getTemporaryDirectory();
                                            final path = tempDir.path;
                                            fileName = path.split('/')[0];
                                            int rand = new math.Random()
                                                .nextInt(10000);
                                            List<int> imageBytes =
                                                file.readAsBytesSync();
                                            String base64Image =
                                                base64Encode(imageBytes);
                                            carPic = base64Image;
                                            setState(() {});
                                          } else {
                                            // User canceled the picker
                                          }
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black45)),
                                          child: carPic.isEmpty
                                              ? Center(
                                                  child: Icon(
                                                  Icons.add,
                                                  size: 30,
                                                  color: Colors.black45,
                                                ))
                                              : Image.memory(
                                                  base64Decode(carPic),
                                                  width: double.infinity,
                                                ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        loc == 'en'
                                            ? 'Upload License Pic'
                                            : 'ارفع صورة الرخصة',
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          File file;
                                          String fileName = '';
                                          /*  file = await FilePicker.getFile(
                                              type: FileType.image); */

                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles();

                                          if (result != null) {
                                            file =
                                                File(result.files.single.path!);
                                            final tempDir = await path_provider
                                                .getTemporaryDirectory();
                                            final path = tempDir.path;
                                            fileName = path.split('/')[0];
                                            int rand = new math.Random()
                                                .nextInt(10000);
                                            List<int> imageBytes =
                                                file.readAsBytesSync();
                                            String base64Image =
                                                base64Encode(imageBytes);
                                            licensePic = base64Image;
                                            setState(() {});
                                          } else {}
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black45)),
                                          child: licensePic.isEmpty
                                              ? Center(
                                                  child: Icon(
                                                  Icons.add,
                                                  size: 30,
                                                  color: Colors.black45,
                                                ))
                                              : Image.memory(
                                                  base64Decode(licensePic),
                                                  width: double.infinity,
                                                ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              /*  RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12), */
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Color(0xff2b2b2b),
                                 
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 15),
                                ),
                                child: Text(
                                  loc == 'en' ? 'Save' : 'احفظ',
                                  style: TextStyle(fontWeight: FontWeight.w600,
                                  color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_overlayKey.currentState!.validate() &&
                                      carPic.isNotEmpty &&
                                      licensePic.isNotEmpty) {
                                    setState(() {
                                      overlay = false;
                                      load = true;

                                    });
                                    overlayEntry.remove();
                                    String soap =
                                        '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <AddCarbyDriver xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
      <Cartype>${carType.text}</Cartype>
      <license>$licensePic</license>
      <PlateNo>${plateNo.text}</PlateNo>
      <Photo>$carPic</Photo>
    </AddCarbyDriver>
  </soap:Body>
</soap:Envelope>''';
                                    http.Response response = await http
                                        .post(
                                            Uri.parse(
                                                'http://tryconnect.net/api/MgraWebService.asmx'),
                                            headers: {
                                              "SOAPAction":
                                                  "http://Mgra.WS/AddCarbyDriver",
                                              "Content-Type":
                                                  "text/xml;charset=UTF-8",
                                            },
                                            body: utf8.encode(soap),
                                            encoding:
                                                Encoding.getByName("UTF-8"))
                                        .then((onValue) {
                                      return onValue;
                                    });
                               
                                    await loadCars();
                                    setState(() {
                                      load = false;
                                    });
                                  /*   Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Vehicles(
                                            user: widget.user,
                                          ),
                                        )); */
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
        ),
      ),
    );
    overlayState.insert(overlayEntry);
  }

  @override
  void initState() {
    loc = globals.loc;
    super.initState();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    loadData();
  }

  void loadData() async {
    setState(() {
      load = true;
    });

    await loadStatus();
    await loadCars();
    setState(() {
      load = false;
    });
  }

  Future<void> loadStatus() async {
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ActiveCar xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
    </ActiveCar>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
            headers: {
              "SOAPAction": "http://Mgra.WS/ActiveCar",
              "Content-Type": "text/xml;charset=UTF-8",
            },
            body: utf8.encode(soap),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    print(response.body);
    String json =
        parse(response.body).getElementsByTagName('ActiveCarResult')[0].text;
    final decoded = jsonDecode(json);
    print(decoded);
    group = decoded;
    setState(() {});
  }

  Future<void> loadCars() async {
     setState(() {
              load = true;

      });
    vehicles = [];
    String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetDriverCars xmlns="http://Mgra.WS/">
      <DriverID>${widget.user.id}</DriverID>
    </GetDriverCars>
  </soap:Body>
</soap:Envelope>''';
    http.Response response = await http
        .post(Uri.parse('http://tryconnect.net/api/MgraWebService.asmx'),
            headers: {
              "SOAPAction": "http://Mgra.WS/GetDriverCars",
              "Content-Type": "text/xml;charset=UTF-8",
            },
            body: utf8.encode(soap),
            encoding: Encoding.getByName("UTF-8"))
        .then((onValue) {
      return onValue;
    });
    if (response.statusCode == 200) {
      String json = parse(response.body)
          .getElementsByTagName('GetDriverCarsResult')[0]
          .text;
      final decoded = jsonDecode(json);
      for (int i = 0; i < decoded.length; i++) {
        vehicles.add(VehicleWidget(
          radio: decoded[i]['ID'].toString(),
          car: decoded[i]['CarType'],
          plate: decoded[i]['PlateNo'],
          photo: decoded[i]['Photo'],
          callback: () async {
           
            await loadCars();
          
          },
        ));
      }
      setState(() {
              load = false;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: loc == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if (overlay) {
            overlayEntry.remove();
            setState(() {
              overlay = false;
            });
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
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
                              loc == 'en' ? 'Vehicles' : 'المركبات',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              endIndent:
                                  MediaQuery.of(context).size.width / 1.55,
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
          body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        loc == 'en' ? 'Ready to drive' : 'جاهز للقيادة',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          overlay = true;
                        });
                        showOverlay(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Color(0xffe5fae2),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child:
                              Text(loc == 'en' ? 'Add Vehicle' : "اضافة مركبة"),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  loc == 'en' ? 'Choose a vehicle' : 'إختر أحد المركبات',
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 30,
                ),
                load
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Loading())
                    : Expanded(
                        child: ListView.separated(
                          itemCount: vehicles.length,
                          itemBuilder: (context, index) => vehicles[index],
                          separatorBuilder: (context, index) => Divider(),
                        ),
                      ),
                load
                    ? Container()
                    : GestureDetector(
                        onTap: () async {
                          print('$group');
                          String soap =
                              '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SelectCarByDriver xmlns="http://Mgra.WS/">
        <DriverID>${widget.user.id}</DriverID>
        <CarID>$group</CarID>
    </SelectCarByDriver>
  </soap:Body>
</soap:Envelope>''';
                          http.Response response = await http
                              .post(
                                  Uri.parse(
                                      'http://tryconnect.net/api/MgraWebService.asmx'),
                                  headers: {
                                    "SOAPAction":
                                        "http://Mgra.WS/SelectCarByDriver",
                                    "Content-Type": "text/xml;charset=UTF-8",
                                  },
                                  body: utf8.encode(soap),
                                  encoding: Encoding.getByName("UTF-8"))
                              .then((onValue) {
                            return onValue;
                          });
                          print(response.body);
                          String json = parse(response.body)
                              .getElementsByTagName(
                                  'SelectCarByDriverResult')[0]
                              .text;
                          print(json);
                          if (json == '-1') {
                            /*   _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(loc == 'en' ? 'Failed' : 'فشل'))); */
                          } else {
                            /*   _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                        loc == 'en' ? 'Successfully Done' : 'تم بنجاح',
                      ))); */
                          }
                          await Future.delayed(Duration(seconds: 3)).then((v) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Vehicles(
                                    user: widget.user,
                                  ),
                                ));
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, right: 90, left: 90),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                              color:  Color(0xff2b2b2b),
                             ),
                          child: Center(
                            child: Text(
                              loc == 'en' ? 'Choose' : "إختر",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef StringValue = void Function();

class VehicleWidget extends StatefulWidget {
  final String radio, car, plate, photo;
  final void Function()? callback;
  //final StringValue callback;
  VehicleWidget(
      {this.radio = "",
      this.car = "",
      this.photo = "",
      this.plate = "",
      this.callback});

  @override
  _VehicleWidgetState createState() => _VehicleWidgetState();
}

class _VehicleWidgetState extends State<VehicleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue[200],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: widget.photo.isNotEmpty
                ? Image.memory(
                    base64Decode(widget.photo),
                    fit: BoxFit.fill,
                    width: double.infinity,
                  )
                : Container(),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${widget.car}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 7,
              ),
              Text('${widget.plate}', style: TextStyle(color: Colors.grey))
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Radio(
          value: widget.radio,
          groupValue: group,
          onChanged: (val) {
            group = val as String;
            widget.callback!();
          },
          activeColor: Colors.black,
        )
      ],
    ));
  }
}
