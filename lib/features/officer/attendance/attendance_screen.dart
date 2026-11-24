
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ImagePicker picker = ImagePicker();

  bool isLoading = false;
  DateTime? checkInTime;
  DateTime? checkOutTime;

  XFile? selfie;
  Position? attendancePosition;
  Position? checkOutPosition;

  String? locationAddress;

  bool get hasCheckedIn => checkInTime != null;
  bool get hasCheckedOut => checkOutTime != null;

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (mounted) {
        _showMessage('GPS perangkat belum aktif.');
      }
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        _showMessage('Izin lokasi belum diberikan.');
      }
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<XFile?> takeSelfie() async {
    try {
      return await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 75,
      );
    } catch (e) {
      if (mounted) {
        _showMessage('Kamera tidak dapat dibuka.');
      }
      return null;
    }
  }

  Future<void> checkIn() async {
    if (isLoading || hasCheckedIn) return;

    setState(() => isLoading = true);

    try {
      // 1. Ambil selfie
      final photo = await takeSelfie();

      if (!mounted) return;

      if (photo == null) {
        setState(() => isLoading = false);
        return;
      }

      // 2. Ambil GPS
      final position = await getCurrentPosition();

      if (!mounted) return;

      if (position == null) {
        setState(() => isLoading = false);
        return;
      }

      // 3. Simpan data check-in sementara
      setState(() {
        selfie = photo;
        attendancePosition = position;
        checkInTime = DateTime.now();
        locationAddress =
            '${position.latitude}, ${position.longitude}';
        isLoading = false;
      });

      _showMessage('Check-in berhasil!');
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMessage('Check-in gagal. Silakan coba kembali.');
    }
  }

  Future<void> checkOut() async {
    if (isLoading || !hasCheckedIn || hasCheckedOut) return;

    setState(() => isLoading = true);

    try {
      final position = await getCurrentPosition();

      if (!mounted) return;

      if (position == null) {
        setState(() => isLoading = false);
        return;
      }

      setState(() {
        checkOutPosition = position;
        checkOutTime = DateTime.now();
        isLoading = false;
      });

      _showMessage('Check-out berhasil!');
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMessage('Check-out gagal. Silakan coba kembali.');
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) return '--:--';

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute WIB';
  }

  String formatDate(DateTime date) {
    const days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis',
      'Jumat', 'Sabtu', 'Minggu'
    ];

    const months = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember'
    ];

    return '${days[date.weekday - 1]}, ${date.day} '
        '${months[date.month - 1]} ${date.year}';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        foregroundColor: const Color(0xFF244A7C),
        elevation: 0,
        title: const Text(
          'Absensi Teknisi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dateCard(today),
            const SizedBox(height: 20),
            _statusCard(),
            const SizedBox(height: 20),
            _attendanceCard(),
            const SizedBox(height: 20),
            _selfieCard(),
            const SizedBox(height: 20),
            _locationCard(),
            const SizedBox(height: 24),
            _actionButton(),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Pastikan kamera dan GPS aktif saat melakukan absensi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7B8798),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DATE CARD
  Widget _dateCard(DateTime today) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tanggal Absensi',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatDate(today),
            style: const TextStyle(
              color: Color(0xFF244A7C),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // STATUS CARD
  Widget _statusCard() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (hasCheckedOut) {
      statusColor = const Color(0xFF32A879);
      statusText = 'Absensi selesai';
      statusIcon = Icons.check_circle_rounded;
    } else if (hasCheckedIn) {
      statusColor = const Color(0xFF4479C5);
      statusText = 'Sedang bertugas';
      statusIcon = Icons.work_rounded;
    } else {
      statusColor = const Color(0xFFE49A43);
      statusText = 'Belum melakukan absensi';
      statusIcon = Icons.access_time_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Hari Ini',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 15,
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ATTENDANCE TIME
  Widget _attendanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waktu Kehadiran',
            style: TextStyle(
              color: Color(0xFF244A7C),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _timeItem(
                  title: 'Check-in',
                  time: formatTime(checkInTime),
                  icon: Icons.login_rounded,
                  color: const Color(0xFF32A879),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _timeItem(
                  title: 'Check-out',
                  time: formatTime(checkOutTime),
                  icon: Icons.logout_rounded,
                  color: const Color(0xFFE49A43),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeItem({
    required String title,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF244A7C),
            ),
          ),
        ],
      ),
    );
  }

  // SELFIE CARD
  Widget _selfieCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foto Selfie Absensi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF244A7C),
            ),
          ),
          const SizedBox(height: 14),
          if (selfie == null)
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: 40,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Selfie belum diambil',
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(selfie!.path),
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),
          if (!hasCheckedIn)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : checkIn,
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Ambil Selfie & Check-in'),
              ),
            ),
        ],
      ),
    );
  }

  // LOCATION CARD
  Widget _locationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lokasi Absensi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF244A7C),
            ),
          ),
          const SizedBox(height: 14),
          _locationRow(
            title: 'Lokasi Check-in',
            position: attendancePosition,
          ),
          if (checkOutPosition != null) ...[
            const SizedBox(height: 16),
            _locationRow(
              title: 'Lokasi Check-out',
              position: checkOutPosition,
            ),
          ],
        ],
      ),
    );
  }

  Widget _locationRow({
    required String title,
    required Position? position,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.location_on_rounded,
          color: Color(0xFF4479C5),
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                position == null
                    ? 'Lokasi belum tersedia'
                    : '${position.latitude}, ${position.longitude}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF244A7C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // MAIN BUTTON
  Widget _actionButton() {
    String buttonText;
    IconData buttonIcon;
    VoidCallback? onPressed;

    if (isLoading) {
      buttonText = 'Sedang memproses...';
      buttonIcon = Icons.hourglass_top_rounded;
      onPressed = null;
    } else if (!hasCheckedIn) {
      buttonText = 'Check-in Sekarang';
      buttonIcon = Icons.login_rounded;
      onPressed = checkIn;
    } else if (!hasCheckedOut) {
      buttonText = 'Check-out Sekarang';
      buttonIcon = Icons.logout_rounded;
      onPressed = checkOut;
    } else {
      buttonText = 'Absensi Hari Ini Selesai';
      buttonIcon = Icons.check_circle_rounded;
      onPressed = null;
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(buttonIcon),
        label: Text(
          buttonText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF244A7C),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF9AAFC5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
