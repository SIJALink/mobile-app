import 'package:material_ui/material_ui.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/customer/dashboard/customer_dashboard.dart';
import 'features/customer/installations/installation_request_screen.dart';

class SijaLinkApp extends StatelessWidget {
  const SijaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIJALink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      routes: {
        '/customer/dashboard': (context) => const CustomerDashboard(),
        '/customer/installation': (context) => const InstallationRequestScreen(),
      },
    );
  }
}