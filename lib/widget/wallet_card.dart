import 'package:flutter/material.dart';
import '../pages/walet_details.dart';

class WalletCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double balance;
  final double income;
  final double expense;

  const WalletCard({
    super.key,
    required this.title,
    required this.icon,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WalletDetailPage(
              title: title,
              balance: balance,
              income: income,
              expense: expense,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xff1E293B),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.indigoAccent),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            row('Balance', balance, Colors.white),
            row('Income', income, Colors.greenAccent),
            row('Expense', -expense, Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget row(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            '₹ ${value.toStringAsFixed(2)}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
