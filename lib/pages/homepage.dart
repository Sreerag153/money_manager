import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/model/wallet_model.dart';
import 'package:money_manager_app/pages/add_expense.dart';
import 'package:money_manager_app/pages/add_income.dart';
import 'package:money_manager_app/widget/drawer.dart';

List<String> dropDownlist = <String>[
  'monthly',
  'year',
  'weekly',
  'daily'
];

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  DateTime selectmonth = DateTime(2026, 1);
  String dropdownvalue = dropDownlist.first;

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectmonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        selectmonth = DateTime(date.year, date.month);
      });
    }
  }       




  @override
  Widget build(BuildContext context) {
    final walletBox = Hive.box<WalletModel>('wallet');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 86, 86, 86),
      appBar: AppBar(
        title: const Text(
          'MONEY MANAGER',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: AppDrawer(),
      floatingActionButton: PopupMenuButton<String>(
        icon: const Icon(Icons.add, color: Colors.white),
        onSelected: (value) {
          if (value == 'income') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddIncomePage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddExpensePage()),
            );
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'income', child: Text('Income')),
          PopupMenuItem(value: 'expense', child: Text('Expense')),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: walletBox.listenable(),
        builder: (context, Box<WalletModel> box, _) {
          final wallet = box.getAt(0)!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 92, 77, 226),
                          Color.fromARGB(255, 52, 52, 52),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              value: dropdownvalue,
                              onChanged: (value) {
                                setState(() => dropdownvalue = value!);
                              },
                              items: dropDownlist
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                            ),
                            GestureDetector(
                              onTap: pickDate,
                              child: Text(
                                DateFormat('MMM yyyy').format(selectmonth),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '₹ ${(wallet.cashIncome + wallet.accIncome).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 20),
                                ),
                                const Text(
                                  'Income',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '₹ -${(wallet.cashExpense + wallet.accExpense).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 20),
                                ),
                                const Text(
                                  'Expense',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _walletCard(
                    title: "Bank Account",
                    balance: wallet.accBalance,
                    income: wallet.accIncome,
                    expense: wallet.accExpense,
                  ),
                  const SizedBox(height: 20),
                  _walletCard(
                    title: "Cash",
                    balance: wallet.cashBalance,
                    income: wallet.cashIncome,
                    expense: wallet.cashExpense,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _walletCard({
    required String title,
    required double balance,
    required double income,
    required double expense,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _walletText("Balance", balance.toStringAsFixed(2), Colors.white),
                _walletText("Income", income.toStringAsFixed(2), Colors.green),
                _walletText("Expense", "-${expense.toStringAsFixed(2)}", Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletText(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(color: color)),
      ],
    );
  }
}
