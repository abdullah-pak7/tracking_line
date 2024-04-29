import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackingProvider extends ChangeNotifier {

  bool isLoading = true;
  late GeoPoint startPoint;
  late GeoPoint endPoint;

  final CollectionReference movementCollection = FirebaseFirestore.instance.collection('track');

  Future<void> getLocation() async {
    try{
      DocumentSnapshot startPointDocument = await movementCollection.doc('startPoint').get();
      DocumentSnapshot endPointDocument = await movementCollection.doc('endPoint').get();

      startPoint = GeoPoint(startPointDocument['latitude'], startPointDocument['longitude']);
      endPoint = GeoPoint(endPointDocument['latitude'], endPointDocument['longitude']);

      isLoading = false;
      notifyListeners();
    }
    catch(e){
      log(e.toString());
    }
  }
}