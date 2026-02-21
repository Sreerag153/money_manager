import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/provider/transaction_provider.dart';
import 'package:money_manager_app/widget/colors.dart';
import 'package:money_manager_app/widget/drawer.dart';
import 'package:money_manager_app/widget/inc_exp_circle.dart';
import 'package:money_manager_app/widget/wallet_card.dart';
import 'package:money_manager_app/pages/add_expense.dart';
import 'package:money_manager_app/pages/add_income.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Monthly';
  final List<String> dropDownList = ['Monthly', 'Yearly', 'Weekly', 'Daily'];

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  String get formattedDate {
    if (dropdownValue == 'Yearly') return DateFormat('yyyy').format(selectedDate);
    if (dropdownValue == 'Daily') return DateFormat('dd MMM yyyy').format(selectedDate);
    if (dropdownValue == 'Weekly') {
      final start = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      final end = start.add(const Duration(days: 6));
      return "${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}";
    }
    return DateFormat('MMM yyyy').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final filtered = provider.filterTransactions(
      selectedDate: selectedDate,
      filterType: dropdownValue,
    );

    double inc = 0, exp = 0, accInc = 0, accExp = 0, cashInc = 0, cashExp = 0;

    for (var tx in filtered) {
      if (tx.type == 'income') {
        inc += tx.amount;
        tx.account == 'Account' ? accInc += tx.amount : cashInc += tx.amount;
      } else {
        exp += tx.amount;
        tx.account == 'Account' ? accExp += tx.amount : cashExp += tx.amount;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Money Manager', style: TextStyle(color: AppColors.moneyManagerTitle)),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: _fab(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _summaryCard(inc, exp, (inc + exp)),
            const SizedBox(height: 24),
            WalletCard(title: 'Bank Account', icon: Icons.account_balance, balance: accInc - accExp, income: accInc, expense: accExp),
            const SizedBox(height: 16),
            WalletCard(title: 'Cash', icon: Icons.wallet, balance: cashInc - cashExp, income: cashInc, expense: cashExp),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(double income, double expense, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd]),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: dropdownValue,
                underline: const SizedBox(),
                dropdownColor: const Color(0xff1E293B),
                items: dropDownList.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(),
                onChanged: (v) => setState(() => dropdownValue = v!),
              ),
              GestureDetector(
                onTap: pickDate,
                child: Text(formattedDate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularTile(title: 'Income', value: income, percent: total == 0 ? 0 : income / total, color: AppColors.income),
              CircularTile(title: 'Expense', value: expense, percent: total == 0 ? 0 : expense / total, color: AppColors.expense),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fab(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd])),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      onSelected: (v) => Navigator.push(context, MaterialPageRoute(builder: (_) => v == 'income' ? const AddIncomePage() : const AddExpensePage())),
      itemBuilder: (_) => [const PopupMenuItem(value: 'income', child: Text('Income')), const PopupMenuItem(value: 'expense', child: Text('Expense'))],
    );
  }
}