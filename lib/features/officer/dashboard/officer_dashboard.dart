
import 'package:material_ui/material_ui.dart';

import '../attendance/attendance_screen.dart';
import '../tasks/task_screen.dart';
import '../complaints/complaint_screen.dart';
import '../dynamic_qr/technician_qr_screen.dart';
import '../live_location/technician_location_screen.dart';
import '../history/technician_history_screen.dart';
import '../profile/technician_profile_screen.dart';
import '../notifications/technician_notification_screen.dart';
import '../schedule/technician_schedule_screen.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  int selectedIndex = 0;

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan segera dibuat.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void navigateTo(String title) {
  Widget? page;

  switch (title) {
    case 'Tugas Saya':
      page = const TaskScreen();
      break;

    case 'Keluhan':
      page = const ComplaintScreen();
      break;

    case 'QR Teknisi':
      page = const TechnicianQrScreen();
      break;

    case 'Lokasi Saya':
      page = const TechnicianLocationScreen();
      break;

    case 'Riwayat Pekerjaan':
      page = const TechnicianHistoryScreen();
      break;

    case 'Notifikasi':
  page = const TechnicianNotificationScreen();
  break;

case 'Jadwal Teknisi':
  page = const TechnicianScheduleScreen();
  break;

case 'Profil Saya':
case 'Profil':
case 'Profil teknisi':
  page = const TechnicianProfileScreen();
  break;

    default:
      showComingSoon(title);
      return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => page!),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 24),
              _attendanceCard(),
              const SizedBox(height: 22),
              _taskSummary(),
              const SizedBox(height: 24),
              _quickMenu(),
              const SizedBox(height: 24),
              _sectionHeader(
                'Tugas Hari Ini',
                'Lihat Semua',
                () => navigateTo('Tugas Saya'),
              ),
              const SizedBox(height: 12),
              _taskCard(
                title: 'Perbaikan jaringan',
                location: 'Ruang Server • Gedung A',
                time: '09.00 WIB',
                status: 'Prioritas Tinggi',
                color: const Color(0xFFE45D5D),
                icon: Icons.wifi_rounded,
              ),
              const SizedBox(height: 12),
              _taskCard(
                title: 'Pengecekan koneksi',
                location: 'Lab Komputer • Gedung B',
                time: '10.30 WIB',
                status: 'Terjadwal',
                color: const Color(0xFF4479C5),
                icon: Icons.computer_rounded,
              ),
              const SizedBox(height: 24),
              _sectionHeader(
                'Tiket Keluhan',
                'Lihat Semua',
                () => navigateTo('Keluhan'),
              ),
              const SizedBox(height: 12),
              _complaintCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SIJALink Mobile',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Halo, Teknisi 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF244A7C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Siap bertugas hari ini?',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => navigateTo('Profil teknisi'),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE1EAF5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFF244A7C),
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _attendanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF244A7C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Status Kehadiran',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Belum Absen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Anda belum memulai tugas hari ini.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AttendanceScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF244A7C),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Mulai Absensi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskSummary() {
    return Row(
      children: [
        Expanded(
          child: _summaryItem(
            icon: Icons.assignment_rounded,
            title: 'Total Tugas',
            value: '4',
            color: const Color(0xFF4479C5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryItem(
            icon: Icons.check_circle_rounded,
            title: 'Selesai',
            value: '0',
            color: const Color(0xFF32A879),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryItem(
            icon: Icons.confirmation_number_rounded,
            title: 'Keluhan',
            value: '2',
            color: const Color(0xFFE49A43),
          ),
        ),
      ],
    );
  }

  Widget _summaryItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF244A7C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickMenu() {
    final menus = [
      _MenuData(
        icon: Icons.assignment_outlined,
        title: 'Tugas Saya',
        color: const Color(0xFF4479C5),
      ),
      _MenuData(
        icon: Icons.confirmation_number_outlined,
        title: 'Keluhan',
        color: const Color(0xFFE49A43),
      ),
      _MenuData(
        icon: Icons.qr_code_2_rounded,
        title: 'QR Teknisi',
        color: const Color(0xFF32A879),
      ),
      _MenuData(
        icon: Icons.location_on_outlined,
        title: 'Lokasi Saya',
        color: const Color(0xFF8B6CC1),
      ),
      _MenuData(
        icon: Icons.calendar_month_outlined,
        title: 'Jadwal Teknisi',
        color: const Color(0xFF328C9B),
      ),
      _MenuData(
        icon: Icons.history_rounded,
        title: 'Riwayat Pekerjaan',
        color: const Color(0xFF718096),
      ),
      _MenuData(
        icon: Icons.notifications_active_outlined,
        title: 'Notifikasi',
        color: const Color(0xFFE06B75),
      ),
      _MenuData(
        icon: Icons.person_outline_rounded,
        title: 'Profil Saya',
        color: const Color(0xFF8B6CC1),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Utama',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF244A7C),
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: menus.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 18,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final menu = menus[index];

            return InkWell(
              onTap: () => navigateTo(menu.title),
              borderRadius: BorderRadius.circular(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: menu.color.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      menu.icon,
                      color: menu.color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    menu.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _sectionHeader(
    String title,
    String action,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF244A7C),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4479C5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskCard({
    required String title,
    required String location,
    required String time,
    required String status,
    required Color color,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => navigateTo('Tugas Saya'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 23),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF244A7C),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _complaintCard() {
    return InkWell(
      onTap: () => navigateTo('Keluhan'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFE49A43).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Color(0xFFE49A43),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keluhan #SL-0024',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF244A7C),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Internet tidak dapat terhubung',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Menunggu penanganan',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFE49A43),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    final items = [
      _NavItem(Icons.home_rounded, 'Beranda'),
      _NavItem(Icons.assignment_rounded, 'Tugas'),
      _NavItem(Icons.confirmation_number_rounded, 'Keluhan'),
      _NavItem(Icons.person_rounded, 'Profil'),
    ];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() => selectedIndex = index);

        switch (index) {
          case 0:
            break;
          case 1:
            navigateTo('Tugas Saya');
            break;
          case 2:
            navigateTo('Keluhan');
            break;
          case 3:
            navigateTo('Profil');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF244A7C),
      unselectedItemColor: const Color(0xFF94A3B8),
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 8,
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        );
      }).toList(),
    );
  }
}

class _MenuData {
  final IconData icon;
  final String title;
  final Color color;

  _MenuData({
    required this.icon,
    required this.title,
    required this.color,
  });
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem(this.icon, this.label);
}
