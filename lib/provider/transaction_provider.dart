import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/database/transactiondb.dart';

class TransactionProvider extends ChangeNotifier {
  final _box = Hive.box<TransactionModel>('transactions');

  List<TransactionModel> get transactions => _box.values.toList();

  void addTransaction(TransactionModel tx) {
    TransactionDB.add(tx);
    notifyListeners();
  }

  void deleteTransaction(dynamic key) {
    TransactionDB.delete(key);
    notifyListeners();
  }

  List<TransactionModel> filterTransactions({
    required DateTime selectedDate,
    required String filterType,
  }) {
    return transactions.where((tx) {
      if (filterType == 'Yearly') return tx.date.year == selectedDate.year;
      if (filterType == 'Monthly') {
        return tx.date.year == selectedDate.year &&
            tx.date.month == selectedDate.month;
      }
      if (filterType == 'Daily') {
        return tx.date.year == selectedDate.year &&
            tx.date.month == selectedDate.month &&
            tx.date.day == selectedDate.day;
      }
      if (filterType == 'Weekly') {
        final start = selectedDate.subtract(
          Duration(days: selectedDate.weekday - 1),
        );
        final end = start.add(const Duration(days: 6));
        return tx.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            tx.date.isBefore(end.add(const Duration(days: 1)));
      }
      return true;
    }).toList();
  }
}
