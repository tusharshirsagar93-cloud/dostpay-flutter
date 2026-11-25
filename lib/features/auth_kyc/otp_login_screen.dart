import 'package:flutter/material.dart';

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final _phoneCtrl = TextEditingController(text: '+7 999 412 8810');
  final _otpCtrl = TextEditingController(text: '123456');
  bool _otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DostPay Login & KYC')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter Phone Number (Russia / India)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(border: OutlineInputBorder())),
            if (_otpSent) ...[
              const SizedBox(height: 16),
              const Text('Sandbox OTP (123456)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: _otpCtrl, decoration: const InputDecoration(border: OutlineInputBorder())),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (!_otpSent) {
                  setState(() => _otpSent = true);
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(_otpSent ? 'Verify & Continue' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
