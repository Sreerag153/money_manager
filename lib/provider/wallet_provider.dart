import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/model/transaction_model.dart';

class WalletProvider extends ChangeNotifier {
  DateTimeRange? _selectedRange;
  String _filterType = 'all';

  DateTimeRange? get selectedRange => _selectedRange;
  String get filterType => _filterType;

  void setRange(DateTimeRange? range) {
    _selectedRange = range;
    notifyListeners();
  }

  void setFilterType(String type) {
    _filterType = type;
    notifyListeners();
  }

  List<TransactionModel> applyFilters(List<TransactionModel> all) {
    return all.where((tx) {
      final matchType = _filterType == 'all' ? true : tx.type == _filterType;
      final matchDate = _selectedRange == null
          ? true
          : (tx.date.isAfter(_selectedRange!.start.subtract(const Duration(days: 1))) &&
             tx.date.isBefore(_selectedRange!.end.add(const Duration(days: 1))));
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

  double getTotalBalance(List<TransactionModel> list) {
    double income = 0, expense = 0;
    for (var tx in list) {
      if (tx.type == 'income') income += tx.amount;
      else expense += tx.amount;
    }
    return income - expense;
  }

  double getCashBalance(List<TransactionModel> list) {
    double income = 0, expense = 0;
    for (var tx in list) {
      if (tx.account.toLowerCase() == 'cash') {
        if (tx.type == 'income') income += tx.amount;
        else expense += tx.amount;
      }
    }
    return income - expense;
  }

  double getBankBalance(List<TransactionModel> list) {
    double income = 0, expense = 0;
    for (var tx in list) {
      if (tx.account.toLowerCase() == 'bank' || tx.account.toLowerCase() == 'account') {
        if (tx.type == 'income') income += tx.amount;
        else expense += tx.amount;
      }
    }
    return income - expense;
  }
}