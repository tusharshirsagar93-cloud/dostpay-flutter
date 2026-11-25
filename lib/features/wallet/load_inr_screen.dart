import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_state.dart';

class LoadInrScreen extends ConsumerStatefulWidget {
  final VoidCallback onDone;
  const LoadInrScreen({super.key, required this.onDone});

  @override
  ConsumerState<LoadInrScreen> createState() => _LoadInrScreenState();
}

class _LoadInrScreenState extends ConsumerState<LoadInrScreen> {
  final _inrCtrl = TextEditingController(text: '10000');
  String _purpose = 'S1301';

  @override
  Widget build(BuildContext context) {
    final inr = double.tryParse(_inrCtrl.text) ?? 0;
    final rub = inr / 1.13;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Load Wallet from India (RBI LRS)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _purpose,
          decoration: const InputDecoration(labelText: 'Purpose Code', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'S1301', child: Text('S1301 — Student Living Expenses')),
            DropdownMenuItem(value: 'S0305', child: Text('S0305 — University Tuition Fee')),
          ],
          onChanged: (v) => setState(() => _purpose = v ?? 'S1301'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _inrCtrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'Amount (INR ₹)', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        Text('Credited @ 1 RUB = ₹1.13: ₽ ${rub.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            if (inr < 500) return;
            ref.read(dostPayProvider.notifier).loadInr(inr, _purpose);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ₽${rub.toStringAsFixed(0)}!')));
            widget.onDone();
          },
          child: const Text('Pay via Indian UPI (Sandbox)'),
        ),
      ],
    );
  }
}
