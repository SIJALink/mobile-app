
import 'package:material_ui/material_ui.dart';
class CustomerSettingsScreen extends StatefulWidget {
  const CustomerSettingsScreen({super.key});

  @override
  State<CustomerSettingsScreen> createState() =>
      _CustomerSettingsScreenState();
}

class _CustomerSettingsScreenState extends State<CustomerSettingsScreen> {
  static const Color primary = Color(0xFF244A7C);
  static const Color background = Color(0xFFF4F7FB);

  bool notificationEnabled = true;
  bool serviceNotification = true;
  bool promotionalNotification = false;
  bool biometricEnabled = false;

  void showChangePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    final oldPassword = TextEditingController();
    final newPassword = TextEditingController();
    final confirmPassword = TextEditingController();

    bool showOld = false;
    bool showNew = false;
    bool showConfirm = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                'Ubah Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      passwordField(
                        controller: oldPassword,
                        label: 'Password Lama',
                        visible: showOld,
                        onToggle: () {
                          setDialogState(() => showOld = !showOld);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password lama wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      passwordField(
                        controller: newPassword,
                        label: 'Password Baru',
                        visible: showNew,
                        onToggle: () {
                          setDialogState(() => showNew = !showNew);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password baru wajib diisi';
                          }
                          if (value.length < 8) {
                            return 'Minimal 8 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      passwordField(
                        controller: confirmPassword,
                        label: 'Konfirmasi Password',
                        visible: showConfirm,
                        onToggle: () {
                          setDialogState(() => showConfirm = !showConfirm);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password wajib diisi';
                          }
                          if (value != newPassword.text) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Permintaan perubahan password berhasil disimulasikan.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      oldPassword.dispose();
      newPassword.dispose();
      confirmPassword.dispose();
    });
  }

  Widget passwordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: primary),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            visible ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        icon: const Icon(Icons.logout, color: Colors.red, size: 35),
        title: const Text(
          'Keluar dari Akun?',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun SIJALink?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout belum terhubung dengan autentikasi.'),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 18, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget settingCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: children),
    );
  }

  Widget settingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: (iconColor ?? primary).withValues(alpha:0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? primary, size: 21),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
    );
  }

  Widget toggleTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: primary.withValues(alpha:0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primary, size: 21),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: Switch(
  value: value,
  activeThumbColor: primary,
  onChanged: onChanged,
),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Pengaturan Akun',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          sectionLabel('Akun & Keamanan'),
          settingCard(
            children: [
              settingTile(
                icon: Icons.lock_outline,
                title: 'Ubah Password',
                subtitle: 'Perbarui password akun secara berkala',
                onTap: showChangePasswordDialog,
              ),
              const Divider(height: 1, indent: 60),
              toggleTile(
                icon: Icons.fingerprint,
                title: 'Biometrik',
                subtitle: 'Login menggunakan sidik jari',
                value: biometricEnabled,
                onChanged: (value) {
                  setState(() => biometricEnabled = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? 'Biometrik diaktifkan (simulasi).'
                            : 'Biometrik dinonaktifkan.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          sectionLabel('Notifikasi'),
          settingCard(
            children: [
              toggleTile(
                icon: Icons.notifications_active_outlined,
                title: 'Notifikasi',
                subtitle: 'Aktifkan atau nonaktifkan seluruh notifikasi',
                value: notificationEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationEnabled = value;
                    if (!value) {
                      serviceNotification = false;
                      promotionalNotification = false;
                    }
                  });
                },
              ),
              if (notificationEnabled) ...[
                const Divider(height: 1, indent: 60),
                toggleTile(
                  icon: Icons.build_outlined,
                  title: 'Layanan',
                  subtitle: 'Status tiket, jadwal dan progres',
                  value: serviceNotification,
                  onChanged: (value) {
                    setState(() => serviceNotification = value);
                  },
                ),
                const Divider(height: 1, indent: 60),
                toggleTile(
                  icon: Icons.campaign_outlined,
                  title: 'Informasi & Promo',
                  subtitle: 'Informasi produk dan pengumuman',
                  value: promotionalNotification,
                  onChanged: (value) {
                    setState(() => promotionalNotification = value);
                  },
                ),
              ],
            ],
          ),

          sectionLabel('Informasi Aplikasi'),
          settingCard(
            children: [
              settingTile(
                icon: Icons.info_outline,
                title: 'Tentang SIJALink',
                subtitle: 'Informasi aplikasi',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'SIJALink Mobile',
                    applicationVersion: '1.0.0',
                    applicationLegalese: 'Aplikasi layanan pelanggan SIJALink.',
                  );
                },
              ),
              const Divider(height: 1, indent: 60),
              settingTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Kebijakan Privasi',
                subtitle: 'Informasi keamanan dan privasi data',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Kebijakan Privasi'),
                      content: const Text(
                        'Informasi pribadi pelanggan digunakan untuk mendukung '
                        'proses layanan SIJALink. Pengelolaan data dan '
                        'kebijakan lengkap akan tersedia setelah integrasi backend.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: showLogoutConfirmation,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Column(
              children: [
                Text(
                  'SIJALink Mobile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
