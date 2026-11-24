
import 'package:material_ui/material_ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primary = Color(0xFF244A7C);
  static const Color background = Color(0xFFF4F7FB);

  final TextEditingController nameController =
      TextEditingController(text: 'Guru Piket');

  final TextEditingController emailController =
      TextEditingController(text: 'gurupiket@sijalink.sch.id');

  final TextEditingController roleController =
      TextEditingController(text: 'Guru Penanggung Jawab');

  bool isEditing = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    super.dispose();
  }

  void saveProfile() {
    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan profil tersimpan sementara.'),
      ),
    );
  }

  void logout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari Akun?'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari aplikasi SIJALink?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Fitur logout akan dihubungkan dengan autentikasi.',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Profil Guru Piket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _profileHeader(),
          const SizedBox(height: 20),
          _profileForm(),
          const SizedBox(height: 18),
          _informationCard(),
          const SizedBox(height: 22),
          _actionButton(),
          const SizedBox(height: 12),
          _logoutButton(),
          const SizedBox(height: 25),
          const Center(
            child: Text(
              'SIJALink • School Service Center',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF244A7C),
            Color(0xFF3875B8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: primary,
              size: 48,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            nameController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Guru Penanggung Jawab',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Akun Guru Piket',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Akun',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 18),
          _field(
            label: 'Nama Lengkap',
            controller: nameController,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 15),
          _field(
            label: 'Email',
            controller: emailController,
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 15),
          _field(
            label: 'Jabatan',
            controller: roleController,
            icon: Icons.badge_outlined,
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: !isEditing,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: primary),
            filled: true,
            fillColor: const Color(0xFFFAFBFD),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _informationCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi SIJALink',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          SizedBox(height: 15),
          _InfoRow(
            icon: Icons.school_outlined,
            title: 'Unit',
            value: 'Teaching Factory SIJALink',
          ),
          SizedBox(height: 13),
          _InfoRow(
            icon: Icons.security_outlined,
            title: 'Hak Akses',
            value: 'Guru Piket',
          ),
          SizedBox(height: 13),
          _InfoRow(
            icon: Icons.verified_user_outlined,
            title: 'Status Akun',
            value: 'Aktif',
          ),
        ],
      ),
    );
  }

  Widget _actionButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          if (isEditing) {
            saveProfile();
          } else {
            setState(() {
              isEditing = true;
            });
          }
        },
        icon: Icon(
          isEditing ? Icons.save_rounded : Icons.edit_rounded,
        ),
        label: Text(
          isEditing ? 'Simpan Perubahan' : 'Edit Profil',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: logout,
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Keluar dari Akun'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(
        color: const Color(0xFFE7ECF2),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF244A7C), size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
