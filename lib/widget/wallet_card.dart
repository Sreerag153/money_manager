import 'package:flutter/material.dart';
import '../pages/walet_details.dart';

class WalletCard extends StatefulWidget {
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
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, animation, __) => FadeTransition(
              opacity: animation,
              child: WalletDetailPage(
                title: widget.title,
                balance: widget.balance,
                income: widget.income,
                expense: widget.expense,
              ),
            ),
          ),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xff334155)
                : const Color(0xff1E293B),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: _pressed ? 4 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(widget.icon, color: Colors.indigoAccent),
                  const SizedBox(width: 10),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _row('Balance', widget.balance, Colors.white),
              _row('Income', widget.income, Colors.greenAccent),
              _row('Expense', -widget.expense, Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: const Duration(milliseconds: 600),
            builder: (context, val, _) {
              return Text(
                '₹ ${val.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}