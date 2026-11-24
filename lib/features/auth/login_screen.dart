import 'package:material_ui/material_ui.dart';
import 'role_selection_screen.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;

void login() async {
  if (emailController.text.trim().isEmpty ||
      passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email dan password wajib diisi'),
      ),
    );
    return;
  }

  setState(() => isLoading = true);

  // Simulasi proses login
  await Future.delayed(const Duration(seconds: 1));

  if (!mounted) return;

  setState(() => isLoading = false);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const RoleSelectionScreen(),
    ),
  );
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'SIJALink',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Sistem Layanan Customer Service SIJA',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login untuk mengakses layanan SIJALink.',
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Email / Username',
                  hint: 'Masukkan email atau username',
                  controller: emailController,
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Password',
                  hint: 'Masukkan password',
                  controller: passwordController,
                  obscureText: !showPassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Text(
                      showPassword
                          ? 'Sembunyikan password'
                          : 'Tampilkan password',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Login',
                  isLoading: isLoading,
                  onPressed: login,
                  icon: Icons.login_rounded,
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'SIJALink · School IT Service Center',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
