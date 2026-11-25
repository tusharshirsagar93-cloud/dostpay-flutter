import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/app_state.dart';

class HomeDashboardScreen extends ConsumerWidget {
  final ValueChanged<int> onNavigate;
  const HomeDashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(dostPayProvider);
    final notifier = ref.read(dostPayProvider.notifier);
    final inrEq = (s.rubBalance * 1.13).toStringAsFixed(0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('DostPay (SBP + Mir)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SegmentedButton<UserMode>(
              segments: const [
                ButtonSegment(value: UserMode.worker, label: Text('Worker')),
                ButtonSegment(value: UserMode.student, label: Text('Student')),
              ],
              selected: {s.mode},
              onSelectionChanged: (v) => notifier.toggleMode(v.first),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF4338CA), Color(0xFF2563EB)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Russia Wallet Balance (RUB)', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Text('₽ ${s.rubBalance.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              Text('≈ ₹ $inrEq INR (1 RUB = ₹1.13)', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickBtn(icon: Icons.qr_code, label: 'Scan QR', onTap: () => onNavigate(1)),
            _QuickBtn(icon: Icons.send, label: 'Send Home', onTap: () => onNavigate(2)),
            _QuickBtn(icon: Icons.add_circle, label: 'Load INR', onTap: () => onNavigate(3)),
            _QuickBtn(icon: Icons.credit_card, label: 'Mir Card', onTap: () => onNavigate(4)),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...s.transactions.map((tx) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text('${tx.subtitle} • ${tx.time}', style: const TextStyle(fontSize: 12)),
              trailing: Text(
                '${tx.rubAmount > 0 ? '+' : '-'}₽ ${tx.rubAmount.abs().toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tx.rubAmount > 0 ? Colors.green[700] : Colors.black87,
                ),
              ),
            )),
      ],
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            CircleAvatar(radius: 22, child: Icon(icon, size: 20)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
