// ignore_for_file: library_private_types_in_public_api, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class CinemaNearMe extends StatefulWidget {
  const CinemaNearMe({super.key});

  @override
  _MyHomePagestate createState() => _MyHomePagestate();
}

class _MyHomePagestate extends State<CinemaNearMe>{

  Future<LatLng> _getCurrentLocation() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } else {
      throw Exception('Location permissions not granted');
    }
  }

  Future<List<LatLng>> _searchNearbyCinemas(LatLng currentLocation) async {
    final response = await http.get(Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=Cinema+near+${currentLocation.latitude},${currentLocation.longitude}'));
    if (response.statusCode == 200) {
      List<dynamic> cinemas = jsonDecode(response.body);
      return cinemas.map((cinema) => LatLng(double.parse(cinema['lat']), double.parse(cinema['lon']))).toList();
    } else {
      throw Exception('Failed to load cinemas');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'Cinema near me',
        style: TextStyle(fontSize: 22),
        ),
      ),
      body: content(),
    );
  }

  Widget content() {
  return FutureBuilder(
    future: _getCurrentLocation(),
    builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError || snapshot.data == null) {
        return const Center(child: Text('Error fetching location'));
      } else {
        LatLng location = snapshot.data!;
        return FutureBuilder(
          future: _searchNearbyCinemas(location),
          builder: (BuildContext context, AsyncSnapshot<List<LatLng>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Center(child: Text('Error fetching cinemas'));
            } else {
              List<LatLng> cinemaLocations = snapshot.data!;
              return FlutterMap(
                options: MapOptions(
                  initialCenter: location,
                  initialZoom: 13,
                  interactionOptions: 
                    const InteractionOptions(flags: ~InteractiveFlag.doubleTapDragZoom),
                ), 
                children: [
                  openStreetMapTileLayer,
                  MarkerLayer(markers: [
                    Marker(
                      point: location,
                      width: 60,
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ), 
                    ),
                    // Add markers for each cinema
                    ...cinemaLocations.map((cinemaLocation) => Marker(
                      point: cinemaLocation,
                      width: 60,
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.local_movies,
                        size: 60,
                        color: Colors.blue,
                      ),
                    )).toList(),
                  ]
                  ),
                ],
              );
            }
          },
        );
      }
    },
  );
}
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.dleaflet.flutter_map.example',
);
