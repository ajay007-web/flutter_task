import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? _currentLatLng;
  Timer? _timer;
  GoogleMapController? _mapController;
  bool _loading = true;

  static const String _latKey = 'last_latitude';
  static const String _lngKey = 'last_longitude';

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    await _handlePermission();
    await _loadLastLocation();
    _startLocationUpdates();
  }

  Future<void> _handlePermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text('This app needs location access to function. Please enable it in settings.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    if (lat != null && lng != null) {
      setState(() {
        _currentLatLng = LatLng(lat, lng);
        _loading = false;
      });
    } else {
      await _updateLocation();
    }
  }

  void _startLocationUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _updateLocation());
  }

  Future<void> _updateLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLatLng = latLng;
        _loading = false;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_latKey, latLng.latitude);
      await prefs.setDouble(_lngKey, latLng.longitude);
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(latLng),
        );
      }
    } catch (e) {
      // Handle error (e.g., location services off)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page'),centerTitle: true,),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                      text: _currentLatLng?.latitude.toStringAsFixed(6) ?? '-',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                      text: _currentLatLng?.longitude.toStringAsFixed(6) ?? '-',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
