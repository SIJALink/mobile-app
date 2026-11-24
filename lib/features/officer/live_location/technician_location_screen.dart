
import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TechnicianLocationScreen extends StatefulWidget {
  const TechnicianLocationScreen({super.key});

  @override
  State<TechnicianLocationScreen> createState() =>
      _TechnicianLocationScreenState();
}

class _TechnicianLocationScreenState
    extends State<TechnicianLocationScreen> {
  final Color primary = const Color(0xFF244A7C);

  Position? currentPosition;
  StreamSubscription<Position>? positionSubscription;
  Timer? durationTimer;

  bool isTracking = false;
  int elapsedSeconds = 0;

  static const int maxTrackingSeconds = 8 * 60 * 60;

  
String get durationText {
  final hours = elapsedSeconds ~/ 3600;
  final minutes = (elapsedSeconds % 3600) ~/ 60;
  final seconds = elapsedSeconds % 60;

  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}


  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showMessage('GPS perangkat belum aktif.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      showMessage('Izin lokasi ditolak.');
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      showMessage('Izin lokasi ditolak permanen. Aktifkan melalui pengaturan.');
      return false;
    }

    return true;
  }

  Future<void> startTracking() async {
    if (isTracking) return;

    final allowed = await checkPermission();
    if (!allowed || !mounted) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        currentPosition = position;
        isTracking = true;
        elapsedSeconds = 0;
      });

      positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((position) {
        if (!mounted) return;
        setState(() {
          currentPosition = position;
        });
      });

      durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || !isTracking) return;

        if (elapsedSeconds >= maxTrackingSeconds - 1) {
          stopTracking(autoStopped: true);
          return;
        }

        setState(() {
          elapsedSeconds++;
        });
      });
    } catch (e) {
      if (mounted) {
        showMessage('Gagal mengambil lokasi GPS.');
      }
    }
  }

  Future<void> stopTracking({bool autoStopped = false}) async {
    await positionSubscription?.cancel();
    positionSubscription = null;

    durationTimer?.cancel();
    durationTimer = null;

    if (!mounted) return;

    setState(() {
      isTracking = false;
    });

    showMessage(
      autoStopped
          ? 'Tracking otomatis dihentikan setelah 8 jam.'
          : 'Tracking lokasi dihentikan.',
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String get latitude =>
      currentPosition?.latitude.toStringAsFixed(6) ?? '-';

  String get longitude =>
      currentPosition?.longitude.toStringAsFixed(6) ?? '-';

  @override
  void dispose() {
    positionSubscription?.cancel();
    durationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final latLng = currentPosition == null
        ? null
        : LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text('Lokasi Saya'),
      ),
      body: Column(
        children: [
          // STATUS TRACKING
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isTracking
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.grey.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.location_on,
                    color: isTracking ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTracking ? 'Tracking Aktif' : 'Tracking Tidak Aktif',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isTracking
                            ? 'GPS sedang memperbarui lokasi'
                            : 'Lokasi belum dibagikan',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.circle,
                  size: 12,
                  color: isTracking ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ),

          // MAP
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: latLng ?? const LatLng(-6.2, 106.8),
                    initialZoom: latLng == null ? 5 : 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.sijalink.mobile',
                    ),
                    if (latLng != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: latLng,
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.location_on,
                              color: primary,
                              size: 42,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // LOCATION DATA
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _coordinateItem('Latitude', latitude),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _coordinateItem('Longitude', longitude),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Durasi Tracking',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      durationText,
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Maksimal 8 jam per sesi',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // BUTTON
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isTracking
                    ? () => stopTracking()
                    : () => startTracking(),
                icon: Icon(
                  isTracking ? Icons.stop_circle_outlined : Icons.my_location,
                ),
                label: Text(
                  isTracking ? 'Berhenti Tracking' : 'Mulai Tracking Lokasi',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTracking ? Colors.red : primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _coordinateItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
