import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/provider/transaction_provider.dart';

class BalanceCard extends StatelessWidget {
  final double total, cash, bank;
  const BalanceCard({super.key, required this.total, required this.cash, required this.bank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: [Color(0xff4F46E5), Color(0xff7C3AED)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Balance", style: TextStyle(color: Colors.white70)),
          Text("₹ ${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniBalance(title: "Account", amount: bank, icon: Icons.account_balance),
              _MiniBalance(title: "Cash", amount: cash, icon: Icons.money),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniBalance extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  const _MiniBalance({required this.title, required this.amount, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 14, color: Colors.white70), const SizedBox(width: 4), Text(title, style: const TextStyle(color: Colors.white70))]),
        Text("₹ ${amount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final dynamic tx;
  const TransactionItem({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == 'income';
    return Slidable(
      key: ValueKey(tx.key),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => context.read<TransactionProvider>().deleteTransaction(tx.key),
            backgroundColor: Colors.redAccent,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xff1E293B), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.green : Colors.red),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.category.isEmpty ? 'General' : tx.category, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(tx.account, style: const TextStyle(fontSize: 12, color: Colors.white38)),
                ],
              ),
            ),
            Text("${isIncome ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}", 
                style: TextStyle(fontWeight: FontWeight.bold, color: isIncome ? Colors.greenAccent : Colors.redAccent)),
          ],
        ),
      ),
    );
  }
}