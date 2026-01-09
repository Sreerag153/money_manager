import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager_app/database/transactiondb.dart';

import 'package:money_manager_app/model/transaction_model.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  double getBalance(List<TransactionModel> transactions) {
    double income = 0;
    double expense = 0;

    for (var tx in transactions) {
      if (tx.type == 'income') {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }
    return income - expense;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 86, 86, 86),
      appBar: AppBar(
        title: const Text("Wallet"),
       
      ),

      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<TransactionModel>('transactions').listenable(),
        builder: (context, Box<TransactionModel> box, _) {

          final transactions = box.values.toList();

          return Column(
            children: [

              balanceCard(getBalance(transactions)),

              Expanded(
                child: transactions.isEmpty
                    ? const Center(
                        child: Text(
                          "No transactions yet",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {

                          final tx = box.getAt(index)!;

                          return Slidable(
                            key: ValueKey(tx.key),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    TransactionDB.delete(index);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),

                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: tx.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                  child: Icon(
                                    tx.type == 'income'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(tx.category),
                                subtitle: Text(
                                  tx.date.toString().split(' ')[0],
                                ),
                                trailing: Text(
                                  "${tx.type == 'income' ? '+' : '-'}₹${tx.amount}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: tx.type == 'income'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ),
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

  Widget balanceCard(double balance) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Balance",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              "₹ ${balance.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 26,
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
