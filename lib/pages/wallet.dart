import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:money_manager_app/database/transactiondb.dart';
import 'package:money_manager_app/model/transaction_model.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  DateTimeRange? selectedRange;
  String filterType = 'all';

  double getBalance(List<TransactionModel> transactions) {
    double income = 0;
    double expense = 0;
    for (var tx in transactions) {
      tx.type == 'income' ? income += tx.amount : expense += tx.amount;
    }
    return income - expense;
  }

  List<TransactionModel> applyFilters(List<TransactionModel> all) {
    return all.where((tx) {
      final matchType = filterType == 'all' ? true : tx.type == filterType;
      final matchDate = selectedRange == null
          ? true
          : (tx.date.isAfter(selectedRange!.start.subtract(const Duration(days: 1))) &&
              tx.date.isBefore(selectedRange!.end.add(const Duration(days: 1))));
      return matchType && matchDate;
    }).toList();
  }

  Map<String, List<TransactionModel>> groupByDate(List<TransactionModel> list) {
    final Map<String, List<TransactionModel>> map = {};
    for (var tx in list) {
      final key = DateFormat('yyyy-MM-dd').format(tx.date);
      map.putIfAbsent(key, () => []).add(tx);
    } 
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title: const Text(
          "Wallet",
          style: TextStyle(
            color: Color.fromRGBO(0, 255, 98, 0.871),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TransactionModel>('transactions').listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          final allTransactions = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          final filteredTransactions = applyFilters(allTransactions);
          final grouped = groupByDate(filteredTransactions);
          final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return Column(
            children: [
              _balanceCard(getBalance(allTransactions)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text("Transation History " ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: const Color.fromARGB(255, 125, 3, 246)),),
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: filterType,
                          dropdownColor: const Color(0xff1E293B),
                          style: const TextStyle(color: Colors.white),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All')),
                            DropdownMenuItem(value: 'income', child: Text('Income')),
                            DropdownMenuItem(value: 'expense', child: Text('Expense')),
                          ],
                          onChanged: (value) {
                            setState(() => filterType = value!);
                          },
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.date_range, color: Colors.white),
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => selectedRange = picked);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredTransactions.isEmpty
                    ? const Center(
                        child: Text(
                          "No transactions found",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          final dateKey = dates[index];
                          final items = grouped[dateKey]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                                child: Text(
                                  DateFormat('dd MMM yyyy')
                                      .format(DateTime.parse(dateKey)),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...items.map((tx) {
                                final isIncome = tx.type == 'income';
                                return Slidable(
                                  key: ValueKey(tx.key),
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) =>
                                            TransactionDB.delete(tx.key),
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff1E293B),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor:
                                              isIncome ? Colors.green : Colors.red,
                                          child: Icon(
                                            isIncome
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tx.category.isEmpty
                                                    ? 'General'
                                                    : tx.category,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                isIncome ? 'Credited' : 'Debited',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isIncome
                                                      ? Colors.greenAccent
                                                      : Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "${isIncome ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: isIncome
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _balanceCard(double balance) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Balance",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              "₹ ${balance.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
