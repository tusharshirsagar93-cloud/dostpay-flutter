import 'package:flutter/material.dart';
import 'features/auth_kyc/otp_login_screen.dart';
import 'features/wallet/home_dashboard_screen.dart';
import 'features/qr_pay/sbp_qr_scanner_screen.dart';
import 'features/remittance/send_home_screen.dart';
import 'features/wallet/load_inr_screen.dart';
import 'features/mir_card/mir_card_screen.dart';

class DostPayApp extends StatelessWidget {
  const DostPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DostPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4338CA)),
        useMaterial3: true,
      ),
      home: const MainShell(),
      routes: {
        '/login': (_) => const OtpLoginScreen(),
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeDashboardScreen(onNavigate: (i) => setState(() => _index = i)),
      SbpQrScannerScreen(onDone: () => setState(() => _index = 0)),
      SendHomeScreen(onDone: () => setState(() => _index = 0)),
      LoadInrScreen(onDone: () => setState(() => _index = 0)),
      const MirCardScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Scan QR'),
          NavigationDestination(icon: Icon(Icons.send_outlined), selectedIcon: Icon(Icons.send), label: 'Send'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Load INR'),
          NavigationDestination(icon: Icon(Icons.credit_card_outlined), label: 'Mir Card'),
        ],
      ),
    );
  }
}
