
import 'package:material_ui/material_ui.dart';
import '../../features/customer/installations/installation_request_screen.dart';
import '../../features/customer/complaints/customer_complaint_screen.dart';
class RoleDashboard extends StatefulWidget {
  final String role;
  final String userName;
  final String greeting;
  final IconData roleIcon;
  final Color roleColor;
  final List<String> menuItems;
  final List<IconData> menuIcons;
  final List<String> statsTitles;
  final List<String> statsValues;

  const RoleDashboard({
    super.key,
    required this.role,
    required this.userName,
    required this.greeting,
    required this.roleIcon,
    required this.roleColor,
    required this.menuItems,
    required this.menuIcons,
    required this.statsTitles,
    required this.statsValues,
  });

  @override
  State<RoleDashboard> createState() => _RoleDashboardState();
}

class _RoleDashboardState extends State<RoleDashboard> {
  int currentIndex = 0;

  // NAVIGASI MENU
  void _openMenu(String menu) {
  switch (menu) {
    case 'Pengajuan Instalasi':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const InstallationRequestScreen(),
        ),
      );
      break;

case 'Pengaduan Gangguan':
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CustomerComplaintScreen(),
    ),
  );
  break;

    case 'Profil':
      setState(() {
        currentIndex = 2;
      });
      break;

    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$menu sedang dalam pengembangan'),
        ),
      );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIJALink'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),

      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [
            _buildHome(),
            _buildServices(),
            _buildProfile(),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Layanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // HOME
  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingCard(),

          const SizedBox(height: 24),

          const Text(
            'Ringkasan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.statsTitles.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.65,
            ),
            itemBuilder: (context, index) {
              return _buildStatCard(
                widget.statsTitles[index],
                widget.statsValues[index],
              );
            },
          ),

          const SizedBox(height: 24),

          const Text(
            'Menu Utama',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildMenuGrid(),
        ],
      ),
    );
  }

  // GREETING CARD
  Widget _buildGreetingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.roleColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            widget.roleIcon,
            color: Colors.white,
            size: 34,
          ),

          const SizedBox(height: 16),

          Text(
            widget.greeting,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            widget.userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.role,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STATISTICS CARD
  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: widget.roleColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // MENU GRID
  Widget _buildMenuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.menuItems.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
  _openMenu(widget.menuItems[index]);
},
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.menuIcons[index],
                  color: widget.roleColor,
                  size: 32,
                ),

                const SizedBox(height: 12),

                Text(
                  widget.menuItems[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // SERVICES
  Widget _buildServices() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Layanan SIJALink',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Pilih layanan yang tersedia untuk akun kamu.',
        ),

        const SizedBox(height: 20),

        ...List.generate(widget.menuItems.length, (index) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                widget.menuIcons[index],
                color: widget.roleColor,
              ),
              title: Text(widget.menuItems[index]),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
  _openMenu(widget.menuItems[index]);
},
            ),
          );
        }),
      ],
    );
  }

  // PROFILE
  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil Saya',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          CircleAvatar(
            radius: 40,
            backgroundColor:
                widget.roleColor.withValues(alpha: 0.15),
            child: Icon(
              widget.roleIcon,
              color: widget.roleColor,
              size: 40,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            widget.userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(widget.role),

          const SizedBox(height: 24),

          const Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Informasi akun'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),

          const Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Pengaturan'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text(
                'Keluar dari dashboard',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
