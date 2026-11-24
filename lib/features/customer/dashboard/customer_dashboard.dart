
import 'package:material_ui/material_ui.dart';

import '../installations/installation_request_screen.dart';
import '../complaints/customer_complaint_screen.dart';
import '../tickets/customer_tickets_screen.dart';
import '../tracking/customer_tracking_screen.dart';
import '../history/customer_service_history_screen.dart';
import '../notifications/customer_notification_screen.dart';
import '../chat/customer_chat_screen.dart';
import '../profile/customer_profile_screen.dart';
import '../settings/customer_settings_screen.dart';
import '../qr_scanner/customer_qr_screen.dart';
class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int selectedIndex = 0;

  // NAVIGASI MENU
  void openFeature(String feature) {
    Widget? page;

    switch (feature) {
      case 'Pengajuan Instalasi':
        page = const InstallationRequestScreen();
        break;

      case 'Buat Keluhan':
        page = const CustomerComplaintScreen();
        break;

      case 'Tiket Saya':
      case 'Daftar Tiket':
        page = const CustomerTicketsScreen();
        break;

      case 'Tracking Status':
        page = const CustomerTrackingScreen();
        break;

      case 'Riwayat Layanan':
        page = const CustomerServiceHistoryScreen();
        break;

      case 'Notifikasi':
        page = const CustomerNotificationScreen();
        break;

      case 'Chat Petugas':
      case 'Chat Teknisi':
        page = const CustomerChatScreen();
        break;

      case 'Profil Saya':
      case 'Profil':
      case 'Profil Pelanggan':
        page = const CustomerProfileScreen();
        break;

      case 'Pengaturan':
      case 'Pengaturan Akun':
        page = const CustomerSettingsScreen();
        break;

      case 'Verifikasi Petugas':
        page = const CustomerQrScannerScreen();
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$feature akan segera tersedia.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
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
              _serviceCard(),
              const SizedBox(height: 20),
              _summary(),
              const SizedBox(height: 26),
              _mainMenu(),
              const SizedBox(height: 26),
              _sectionHeader(
                'Tiket Terbaru',
                'Lihat Semua',
                () => openFeature('Daftar Tiket'),
              ),
              const SizedBox(height: 12),
              _ticketCard(
                ticketId: 'SL-0024',
                title: 'Internet tidak dapat terhubung',
                date: '24 November 2026',
                status: 'Menunggu Teknisi',
                statusColor: const Color(0xFFE49A43),
                icon: Icons.wifi_rounded,
              ),
              const SizedBox(height: 12),
              _ticketCard(
                ticketId: 'SL-0021',
                title: 'Permintaan instalasi jaringan',
                date: '22 November 2026',
                status: 'Dalam Proses',
                statusColor: const Color(0xFF4479C5),
                icon: Icons.router_rounded,
              ),
              const SizedBox(height: 24),
              _helpCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  // HEADER
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
                'Halo, Pelanggan 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF244A7C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ada yang bisa kami bantu?',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        // PROFIL
        InkWell(
          onTap: () => openFeature('Profil Saya'),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE1EAF5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFF244A7C),
              size: 27,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // PENGATURAN
        InkWell(
          onTap: () => openFeature('Pengaturan Akun'),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE1EAF5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: Color(0xFF244A7C),
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  // SERVICE CARD
  Widget _serviceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF244A7C),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Layanan SIJALink',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                  'Pelanggan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Butuh bantuan jaringan atau instalasi?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajukan layanan dengan mudah dan pantau prosesnya melalui aplikasi.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 44,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => openFeature('Pengajuan Instalasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF244A7C),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: 19),
                  SizedBox(width: 6),
                  Text(
                    'Ajukan Instalasi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SUMMARY
  Widget _summary() {
    return Row(
      children: [
        Expanded(
          child: _summaryItem(
            icon: Icons.confirmation_number_rounded,
            title: 'Total Tiket',
            value: '2',
            color: const Color(0xFF4479C5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryItem(
            icon: Icons.pending_actions_rounded,
            title: 'Diproses',
            value: '1',
            color: const Color(0xFFE49A43),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryItem(
            icon: Icons.check_circle_rounded,
            title: 'Selesai',
            value: '1',
            color: const Color(0xFF32A879),
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
        horizontal: 8,
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
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // MAIN MENU
  Widget _mainMenu() {
    final menus = [
      _MenuData(
        icon: Icons.add_circle_outline_rounded,
        title: 'Pengajuan\nInstalasi',
        color: const Color(0xFF4479C5),
      ),
      _MenuData(
        icon: Icons.report_problem_outlined,
        title: 'Buat\nKeluhan',
        color: const Color(0xFFE49A43),
      ),
      _MenuData(
        icon: Icons.confirmation_number_outlined,
        title: 'Tiket\nSaya',
        color: const Color(0xFF32A879),
      ),
      _MenuData(
        icon: Icons.track_changes_rounded,
        title: 'Tracking\nStatus',
        color: const Color(0xFF8B6CC1),
      ),
      _MenuData(
        icon: Icons.history_rounded,
        title: 'Riwayat\nLayanan',
        color: const Color(0xFF328C9B),
      ),
      _MenuData(
        icon: Icons.notifications_active_outlined,
        title: 'Notifikasi',
        color: const Color(0xFFE06B75),
      ),
      _MenuData(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'Chat\nPetugas',
        color: const Color(0xFF5D83B6),
      ),
      _MenuData(
        icon: Icons.qr_code_scanner_rounded,
        title: 'Verifikasi\nPetugas',
        color: const Color(0xFF244A7C),
      ),
      _MenuData(
        icon: Icons.person_outline_rounded,
        title: 'Profil\nSaya',
        color: const Color(0xFF718096),
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 18,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final menu = menus[index];

            return InkWell(
              onTap: () {
                openFeature(menu.title.replaceAll('\n', ' '));
              },
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

  // SECTION HEADER
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

  // TICKET CARD
  Widget _ticketCard({
    required String ticketId,
    required String title,
    required String date,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => openFeature('Detail Tiket $ticketId'),
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
                color: statusColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: statusColor, size: 23),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticketId,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF244A7C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
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

  // HELP CARD
  Widget _helpCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFF8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.support_agent_rounded,
            color: Color(0xFF244A7C),
            size: 30,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh bantuan?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF244A7C),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hubungi petugas kami untuk mendapatkan bantuan.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => openFeature('Chat Petugas'),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFF244A7C),
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION
  Widget _bottomNavigation() {
    final items = [
      _NavItem(Icons.home_rounded, 'Beranda'),
      _NavItem(Icons.confirmation_number_rounded, 'Tiket'),
      _NavItem(Icons.history_rounded, 'Riwayat'),
      _NavItem(Icons.person_rounded, 'Profil'),
    ];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });

        switch (index) {
          case 0:
            break;

          case 1:
            openFeature('Tiket Saya');
            break;

          case 2:
            openFeature('Riwayat Layanan');
            break;

          case 3:
            openFeature('Profil Pelanggan');
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

// MODEL MENU
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

// MODEL BOTTOM NAVIGATION
class _NavItem {
  final IconData icon;
  final String label;

  _NavItem(this.icon, this.label);
}
