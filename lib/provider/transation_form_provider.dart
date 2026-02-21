import 'package:flutter/material.dart';

class TransactionFormProvider extends ChangeNotifier {
  String _selectedAccount = "Cash";
  String _selectedCategory = "";
  DateTime _selectedDate = DateTime.now();

  String get selectedAccount => _selectedAccount;
  String get selectedCategory => _selectedCategory;
  DateTime get selectedDate => _selectedDate;

  void init(String defaultCategory, String defaultAccount) {
    _selectedCategory = defaultCategory;
    _selectedAccount = defaultAccount;
    _selectedDate = DateTime.now();
  }

  void setAccount(String account) {
    _selectedAccount = account;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}