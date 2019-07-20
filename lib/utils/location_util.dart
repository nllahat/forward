import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';

class LocationUtil {
  static Future<Address> getAddressByGeoPoint(GeoPoint geoPoint) async {
    Coordinates coordinates =
        new Coordinates(geoPoint.latitude, geoPoint.longitude);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses != null && addresses.length > 0
        ? addresses.first
        : Address();
  }
}
