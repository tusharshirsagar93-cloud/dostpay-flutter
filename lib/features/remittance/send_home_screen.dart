import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_state.dart';

class SendHomeScreen extends ConsumerStatefulWidget {
  final VoidCallback onDone;
  const SendHomeScreen({super.key, required this.onDone});

  @override
  ConsumerState<SendHomeScreen> createState() => _SendHomeScreenState();
}

class _SendHomeScreenState extends ConsumerState<SendHomeScreen> {
  String _currency = 'INR';
  final _rubCtrl = TextEditingController(text: '15000');
  final _recipCtrl = TextEditingController(text: 'maa.sharma@okicici');

  static const _rates = {
    'INR': 1.13,
    'BDT': 1.28,
    'NPR': 1.44,
    'PKR': 3.02,
    'LKR': 3.20,
    'KES': 1.42,
  };

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(dostPayProvider);
    final notifier = ref.read(dostPayProvider.notifier);
    final rub = double.tryParse(_rubCtrl.text) ?? 0;
    final marginPct = s.plan == PlanTier.pro ? 0.001 : 0.008;
    final flatFee = s.plan == PlanTier.pro ? 50.0 : 120.0;
    final marginRub = rub * marginPct;
    final netRub = (rub - flatFee - marginRub).clamp(0, double.infinity);
    final payout = netRub * (_rates[_currency] ?? 1.0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Send Money Home (RUB → Asia/Africa)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SegmentedButton<PlanTier>(
          segments: const [
            ButtonSegment(value: PlanTier.free, label: Text('Free (0.80% + ₽120)')),
            ButtonSegment(value: PlanTier.pro, label: Text('Pro (0.10% + ₽50)')),
          ],
          selected: {s.plan},
          onSelectionChanged: (v) => notifier.togglePlan(v.first),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _currency,
          decoration: const InputDecoration(labelText: 'Destination Currency', border: OutlineInputBorder()),
          items: _rates.keys.map((c) => DropdownMenuItem(value: c, child: Text('$c (1 RUB = ${_rates[c]})'))).toList(),
          onChanged: (v) => setState(() => _currency = v ?? 'INR'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _rubCtrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'You Send (RUB ₽)', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _recipCtrl,
          decoration: const InputDecoration(labelText: 'Recipient UPI / bKash / M-Pesa', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('FX Margin:'),
                  Text('₽ ${marginRub.toStringAsFixed(0)}'),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Flat Fee:'),
                  Text('₽ ${flatFee.toStringAsFixed(0)}'),
                ]),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Family Receives:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${payout.toStringAsFixed(0)} $_currency', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: () {
            final ok = notifier.sendHome(_recipCtrl.text, _currency, rub, payout.toDouble());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ok ? 'Sent ${payout.toStringAsFixed(0)} $_currency!' : 'Insufficient RUB balance')),
            );
            if (ok) widget.onDone();
          },
          child: const Text('Send Money Home Now'),
        ),
      ],
    );
  }
}
