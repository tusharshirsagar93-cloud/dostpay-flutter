import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_state.dart';

class MirCardScreen extends ConsumerWidget {
  const MirCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(dostPayProvider);
    final notifier = ref.read(dostPayProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF312E81)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DOSTPAY VIRTUAL', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  Text('MIR', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 28),
              Text('2200 •••• •••• 4829', style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2)),
              SizedBox(height: 18),
              Text('AARAV SHARMA  •  11/29', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('NFC Tap & Pay (Android)'),
          value: s.nfcEnabled,
          onChanged: (_) => notifier.toggleNfc(),
        ),
        SwitchListTile(
          title: const Text('Freeze Card'),
          value: s.cardFrozen,
          onChanged: (_) => notifier.toggleFreeze(),
        ),
      ],
    );
  }
}
