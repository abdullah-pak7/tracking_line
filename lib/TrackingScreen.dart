import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TrackingProvider.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {

  late TrackingProvider trackingProvider;

  @override
  void initState() {
    trackingProvider = Provider.of(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return trackingProvider.isLoading ? const Center(
      child: CircularProgressIndicator(),
    ) :
    const Center(
      child: Text('Data'),
    );
  }
}
