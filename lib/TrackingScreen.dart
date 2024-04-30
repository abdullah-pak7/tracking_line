import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:provider/provider.dart';

import 'TrackingProvider.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {

  late TrackingProvider trackingProvider;
  late List<MapLatLng> _polylinePoints;
  late AnimationController _animationController;
  late MapLatLng startPoint;
  late MapLatLng endPoint;
  late MapLatLng movingBody;
  late Animation _animation;


  @override
  void initState() {
    trackingProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await trackingProvider.getLocation();
      startPoint = MapLatLng(trackingProvider.startPoint.latitude, trackingProvider.startPoint.longitude);
      endPoint = MapLatLng(trackingProvider.endPoint.latitude, trackingProvider.endPoint.longitude);
      movingBody = MapLatLng(trackingProvider.startPoint.latitude, trackingProvider.startPoint.longitude);
      _polylinePoints = <MapLatLng>[
        startPoint,
        movingBody,
        endPoint,
      ];

      // _animationController = AnimationController(
      //   duration: const Duration(seconds: 5),
      //   vsync: this,
      // );

      _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      );

      _animationController.forward(from: 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TrackingProvider providerWatcher = (context).watch<TrackingProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking'),
        centerTitle: true,
      ),
      body:  providerWatcher.isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) :
      SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            initialZoomLevel: 15,
            initialFocalLatLng: getPoint(),
            initialMarkersCount: _polylinePoints.length,
            markerBuilder: (BuildContext context, int index) {
              if (index == _polylinePoints.length - 1) {
                return MapMarker(
                  latitude: _polylinePoints[index].latitude,
                  longitude: _polylinePoints[index].longitude,
                  child: Transform.translate(
                    offset: const Offset(0, -5.0),
                    child:
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                  ),
                );
              }
              else if(index != 0){
                return MapMarker(
                  latitude: _polylinePoints[index].latitude,
                  longitude: _polylinePoints[index].longitude,
                  child: Transform.translate(
                    offset: const Offset(0, -5.0),
                    child:
                    InkWell(
                      onTap: (){
                        getPointsPath();
                      },
                      child: const Icon(Icons.directions_walk, color: Colors.black, size: 20),
                    ),
                  ),
                );
              }
              else {
                return MapMarker(
                  latitude: _polylinePoints[index].latitude,
                  longitude: _polylinePoints[index].longitude,
                  iconType: MapIconType.circle,
                  iconColor: Colors.white,
                  iconStrokeWidth: 1.0,
                  size: index == 0 ? const Size(8.0, 8.0) : const Size(3.0, 3.0),
                  iconStrokeColor: Colors.black,
                );
              }
            },
            sublayers: [
              MapPolylineLayer(
                polylines: {
                  MapPolyline(
                    points: _polylinePoints,
                    color: const Color.fromRGBO(0, 102, 255, 1.0),
                    width: 3.0,
                  )
                },
                // animation: _animationController,
              ),
            ],
          ),
        ],
      ),
    );
  }
  MapLatLng getPoint(){
    MapLatLng point = const MapLatLng(0, 0);
    point = MapLatLng((trackingProvider.startPoint.latitude + trackingProvider.startPoint.latitude) / 2,
        (trackingProvider.startPoint.longitude + trackingProvider.startPoint.longitude) / 2) ;
    return point;
  }

  void getPointsPath(){
    double latDiff = endPoint.latitude - startPoint.latitude;
    double longDiff = endPoint.longitude - startPoint.longitude;

    double latStep = latDiff / 200;
    double longStep = longDiff / 200;

    for (int i = 1; i <= 200; i++) {
      double lat = startPoint.latitude + (latStep * i);
      double lon = startPoint.longitude + (longStep * i);
      movingBody = MapLatLng(lat, lon);
      setState(() {});
    }
  }
}
