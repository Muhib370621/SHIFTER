import 'package:location/location.dart';
import 'user_location.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';


class LocationService {
  late UserLocation _currentLocation;
  Location location = Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          updateLocfire(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
          _currentLocation = UserLocation(
            latitude: locationData.latitude ?? 0.0,
            longitude: locationData.longitude ?? 0.0,
          );
          _locationController.add(_currentLocation);
                });
      }
    });
  }



 updateLocfire(double lat, double lng) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return String
      if (prefs.getString('ID') != null && prefs.getString('ID') != '' && prefs.getString('ColorStatus') != null) {
       
        final databaseReference = FirebaseDatabase.instance.ref();

        databaseReference
            .child('${prefs.getString('ID')}')
            .set({'angle': '0', 'lat': lat, 'lng': lng, 'status': prefs.getString('ColorStatus')});

      }
    
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
          latitude: userLocation.latitude??0.0, longitude: userLocation.longitude??0.0);
    } catch (e) {}

    return _currentLocation;
  }

}