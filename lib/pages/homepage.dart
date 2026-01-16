import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/pages/add_expense.dart';
import 'package:money_manager_app/pages/add_income.dart';
import 'package:money_manager_app/widget/drawer.dart';
import 'package:money_manager_app/widget/inc_exp_circle.dart';
import 'package:money_manager_app/widget/wallet_card.dart';

List<String> dropDownList = ['Monthly', 'Yearly', 'Weekly', 'Daily'];

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  DateTime selectedDate = DateTime.now();
  String dropdownValue = dropDownList.first;

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  String get formattedDate {
    switch (dropdownValue) {
      case 'Yearly':
        return DateFormat('yyyy').format(selectedDate);
      case 'Weekly':
        return 'Week ${DateFormat('w').format(selectedDate)}, ${selectedDate.year}';
      case 'Daily':
        return DateFormat('dd MMM yyyy').format(selectedDate);
      default:
        return DateFormat('MMM yyyy').format(selectedDate);
    }
  }

  List<TransactionModel> filterTransactions(
      List<TransactionModel> transactions) {
    return transactions.where((tx) {
      final d = tx.date;

      switch (dropdownValue) {
        case 'Daily':
          return d.year == selectedDate.year &&
              d.month == selectedDate.month &&
              d.day == selectedDate.day;

        case 'Weekly':
          return DateFormat('w').format(d) ==
                  DateFormat('w').format(selectedDate) &&
              d.year == selectedDate.year;

        case 'Yearly':
          return d.year == selectedDate.year;

        case 'Monthly':
        default:
          return d.year == selectedDate.year &&
              d.month == selectedDate.month;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final transactionBox =
        Hive.box<TransactionModel>('transactions');

    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Money Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: _fab(context),
      body: ValueListenableBuilder(
        valueListenable: transactionBox.listenable(),
        builder: (_, Box<TransactionModel> box, __) {
          final allTransactions = box.values.toList();
          final filtered = filterTransactions(allTransactions);

          double income = 0;
          double expense = 0;

          double accIncome = 0;
          double accExpense = 0;
          double cashIncome = 0;
          double cashExpense = 0;

          for (var tx in filtered) {
            if (tx.type == 'income') {
              income += tx.amount;
              tx.account == 'Account'
                  ? accIncome += tx.amount
                  : cashIncome += tx.amount;
            } else {
              expense += tx.amount;
              tx.account == 'Account'
                  ? accExpense += tx.amount
                  : cashExpense += tx.amount;
            }
          }

          final total = income + expense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
                    ),
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
                            items: dropDownList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => dropdownValue = v!),
                          ),
                          GestureDetector(
                            onTap: pickDate,
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularTile(
                            title: 'Income',
                            value: income,
                            percent: total == 0 ? 0 : income / total,
                            color: Colors.greenAccent,
                          ),
                          CircularTile(
                            title: 'Expense',
                            value: expense,
                            percent: total == 0 ? 0 : expense / total,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                WalletCard(
                  title: 'Bank Account',
                  icon: Icons.account_balance,
                  balance: accIncome - accExpense,
                  income: accIncome,
                  expense: accExpense,
                ),
                const SizedBox(height: 16),
                WalletCard(
                  title: 'Cash',
                  icon: Icons.wallet,
                  balance: cashIncome - cashExpense,
                  income: cashIncome,
                  expense: cashExpense,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _fab(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      onSelected: (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                value == 'income'
                    ? const AddIncomePage()
                    : const AddExpensePage(),
          ),
        );
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'income', child: Text('Income')),
        PopupMenuItem(value: 'expense', child: Text('Expense')),
      ],
    );
  }
}
