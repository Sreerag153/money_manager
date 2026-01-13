import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/model/wallet_model.dart';
import 'package:money_manager_app/pages/add_expense.dart';
import 'package:money_manager_app/pages/add_income.dart';
import 'package:money_manager_app/pages/walet_details.dart';
import 'package:money_manager_app/widget/drawer.dart';

List<String> dropDownList = [
  'Monthly',
  'Yearly',
  'Weekly',
  'Daily',
];

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  DateTime selectedDate = DateTime.now();
  String dropdownValue = dropDownList.first;

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  String get formattedDate {
    switch (dropdownValue) {
      case 'Yearly':
        return DateFormat('yyyy').format(selectedDate);
      case 'Weekly':
        final week = DateFormat('w').format(selectedDate);
        return 'Week $week, ${selectedDate.year}';
      case 'Daily':
        return DateFormat('dd MMM yyyy').format(selectedDate);
      default:
        return DateFormat('MMM yyyy').format(selectedDate);
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),

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
          if (box.isEmpty) {
            return const Center(child: Text('No Wallet Data'));
          }

          final wallet = box.getAt(0)!;

          final totalIncome = wallet.cashIncome + wallet.accIncome;
          final totalExpense = wallet.cashExpense + wallet.accExpense;
          final total = totalIncome + totalExpense;

          final incomePercent = total == 0 ? 0.0 : totalIncome / total;
          final expensePercent = total == 0 ? 0.0 : totalExpense / total;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 92, 77, 226),
                        Color.fromARGB(255, 52, 52, 52),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [ 
                          DropdownButton<String>(
                            value: dropdownValue,
                            dropdownColor: Colors.white,
                            underline: const SizedBox(),
                            items: dropDownList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => dropdownValue = value!);
                            },
                          ),
                          GestureDetector(
                            onTap: pickDate,
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _circularSummary(
                            title: 'Income',
                            amount: totalIncome,
                            percent: incomePercent,
                            color: Colors.green,
                          ),
                          _circularSummary(
                            title: 'Expense',
                            amount: totalExpense,
                            percent: expensePercent,
                            color: Colors.red,
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
          );
        },
      ),
    );
  }

  Widget _circularSummary({
    required String title,
    required double amount,
    required double percent,
    required Color color,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 8,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            Column(
              children: [
                Text(
                  "₹ ${amount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${(percent * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _walletCard({
    required String title,
    required double balance,
    required double income,
    required double expense,
  }) {
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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _walletText("Balance", balance, Colors.white),
                  _walletText("Income", income, Colors.green),
                  _walletText("Expense", -expense, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _walletText(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 5),
        Text(
          "₹ ${value.toStringAsFixed(2)}",
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
