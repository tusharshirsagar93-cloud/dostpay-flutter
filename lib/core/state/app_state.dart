import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserMode { worker, student }
enum PlanTier { free, pro }

class TxItem {
  final String title;
  final String subtitle;
  final double rubAmount;
  final String time;

  const TxItem({
    required this.title,
    required this.subtitle,
    required this.rubAmount,
    required this.time,
  });
}

class DostPayState {
  final UserMode mode;
  final PlanTier plan;
  final double rubBalance;
  final bool cardFrozen;
  final bool nfcEnabled;
  final List<TxItem> transactions;

  const DostPayState({
    this.mode = UserMode.worker,
    this.plan = PlanTier.pro,
    this.rubBalance = 48500,
    this.cardFrozen = false,
    this.nfcEnabled = true,
    this.transactions = const [
      TxItem(
        title: 'Pyaterochka Grocery',
        subtitle: 'SBP Universal QR • Moscow',
        rubAmount: -840,
        time: 'Today, 6:15 PM',
      ),
      TxItem(
        title: 'Sent to Maa (India UPI)',
        subtitle: 'Instant IMPS • INR',
        rubAmount: -20120,
        time: 'Yesterday',
      ),
      TxItem(
        title: 'Salary Credit (Rubles)',
        subtitle: 'Employer Payroll • MIR Bank',
        rubAmount: 65000,
        time: '20 Nov',
      ),
    ],
  });

  DostPayState copyWith({
    UserMode? mode,
    PlanTier? plan,
    double? rubBalance,
    bool? cardFrozen,
    bool? nfcEnabled,
    List<TxItem>? transactions,
  }) {
    return DostPayState(
      mode: mode ?? this.mode,
      plan: plan ?? this.plan,
      rubBalance: rubBalance ?? this.rubBalance,
      cardFrozen: cardFrozen ?? this.cardFrozen,
      nfcEnabled: nfcEnabled ?? this.nfcEnabled,
      transactions: transactions ?? this.transactions,
    );
  }
}

class DostPayNotifier extends StateNotifier<DostPayState> {
  DostPayNotifier() : super(const DostPayState());

  void toggleMode(UserMode mode) => state = state.copyWith(mode: mode);
  void togglePlan(PlanTier plan) => state = state.copyWith(plan: plan);
  void toggleFreeze() => state = state.copyWith(cardFrozen: !state.cardFrozen);
  void toggleNfc() => state = state.copyWith(nfcEnabled: !state.nfcEnabled);

  bool payQr(String merchant, double rubAmt) {
    if (state.cardFrozen || rubAmt <= 0 || rubAmt > state.rubBalance) return false;
    state = state.copyWith(
      rubBalance: state.rubBalance - rubAmt,
      transactions: [
        TxItem(
          title: merchant,
          subtitle: 'SBP Universal QR • Paid',
          rubAmount: -rubAmt,
          time: 'Just now',
        ),
        ...state.transactions,
      ],
    );
    return true;
  }

  bool sendHome(String recipient, String currency, double rubAmt, double payoutAmt) {
    if (rubAmt < 200 || rubAmt > state.rubBalance) return false;
    state = state.copyWith(
      rubBalance: state.rubBalance - rubAmt,
      transactions: [
        TxItem(
          title: 'Sent to $recipient',
          subtitle: '${payoutAmt.toStringAsFixed(0)} $currency • Instant',
          rubAmount: -rubAmt,
          time: 'Just now',
        ),
        ...state.transactions,
      ],
    );
    return true;
  }

  void loadInr(double inrAmt, String purposeCode) {
    final rubAdded = inrAmt / 1.13;
    state = state.copyWith(
      rubBalance: state.rubBalance + rubAdded,
      transactions: [
        TxItem(
          title: 'Loaded via Indian UPI',
          subtitle: '₹${inrAmt.toStringAsFixed(0)} INR • LRS $purposeCode',
          rubAmount: rubAdded,
          time: 'Just now',
        ),
        ...state.transactions,
      ],
    );
  }
}

final dostPayProvider = StateNotifierProvider<DostPayNotifier, DostPayState>(
  (ref) => DostPayNotifier(),
);
