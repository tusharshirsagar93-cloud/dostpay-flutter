import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_state.dart';

class SbpQrScannerScreen extends ConsumerStatefulWidget {
  final VoidCallback onDone;
  const SbpQrScannerScreen({super.key, required this.onDone});

  @override
  ConsumerState<SbpQrScannerScreen> createState() => _SbpQrScannerScreenState();
}

class _SbpQrScannerScreenState extends ConsumerState<SbpQrScannerScreen> {
  final _merchantCtrl = TextEditingController(text: 'Pyaterochka Grocery (Moscow)');
  final _amtCtrl = TextEditingController(text: '640');

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Scan Russian SBP / Universal QR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          height: 180,
          decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(18)),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_scanner, color: Colors.white70, size: 56),
                SizedBox(height: 8),
                Text('Camera Ready (Connect mobile_scanner)', style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(controller: _merchantCtrl, decoration: const InputDecoration(labelText: 'Merchant', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _amtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (RUB ₽)', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            final amt = double.tryParse(_amtCtrl.text) ?? 0;
            final ok = ref.read(dostPayProvider.notifier).payQr(_merchantCtrl.text, amt);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ok ? 'Paid ₽${amt.toStringAsFixed(0)} via SBP QR' : 'Payment failed / Card frozen')),
            );
            if (ok) widget.onDone();
          },
          child: const Text('Pay via SBP Instant'),
        ),
      ],
    );
  }
}
