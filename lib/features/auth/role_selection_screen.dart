import 'package:material_ui/material_ui.dart';
import '../customer/dashboard/customer_dashboard.dart';
import '../officer/dashboard/officer_dashboard.dart';
import '../teacher_duty/dashboard/teacher_dashboard.dart';
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Role (Testing)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Masuk sebagai',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Pilih role untuk mencoba dashboard SIJALink.'),
            const SizedBox(height: 30),

            _roleCard(
              context,
              title: 'Pelanggan',
              description: 'Pengajuan instalasi dan laporan gangguan.',
              icon: Icons.person_rounded,
              color: Colors.blue,
              destination: const CustomerDashboard(),
            ),

            _roleCard(
              context,
              title: 'Petugas / Teknisi',
              description: 'Tugas teknisi, absensi, checklist dan laporan.',
              icon: Icons.engineering_rounded,
              color: Colors.orange,
              destination: const OfficerDashboard(),
            ),

            _roleCard(
              context,
              title: 'Guru Piket',
              description: 'Jadwal piket, checklist dan dokumentasi.',
              icon: Icons.school_rounded,
              color: Colors.green,
              destination: const TeacherDashboard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(description),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      ),
    );
  }
}