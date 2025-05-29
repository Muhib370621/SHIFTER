library my_prj.globals;

import 'package:flutter/material.dart';
/* import 'package:flutter_mapbox_navigation/library.dart'; */
import 'package:shifter/front_page.dart';
import 'package:shifter/user.dart';

String loc="en";
//MapboxNavigation directions;
User? user;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
List<GlobalKey<FrontPageState>> keys = <GlobalKey<FrontPageState>>[];
var platformChannelSpecifics;
