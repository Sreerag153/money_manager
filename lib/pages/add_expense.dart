import 'package:flutter/material.dart';
import 'package:money_manager_app/database/catagorydb.dart';
import 'package:money_manager_app/database/transactiondb.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/pages/transation.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});
  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  DateTime selectedDate = DateTime.now();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  String? selectedCategory;
  String selectedAccount = "Cash";
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    categories = CategoryDB.getExpenseCategories(includeReserved: true).map((e) => e.name).toList();
    if (categories.isNotEmpty) selectedCategory = categories.first;
  }

  void refreshCategories() {
    final updated = CategoryDB.getExpenseCategories(includeReserved: true).map((e) => e.name).toList();
    setState(() {
      categories = updated;
      if (!categories.contains(selectedCategory)) selectedCategory = categories.isNotEmpty ? categories.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TransactionPage(
      title: "Add Expense",
      color: Colors.red,
      categories: categories,
      selectedDate: selectedDate,
      onPickDate: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) setState(() => selectedDate = pickedDate);
      },
      amountController: amountController,
      noteController: noteController,
      selectedCategory: selectedCategory!,
      selectedAccount: selectedAccount,
      onAccountChanged: (v) => setState(() => selectedAccount = v),
      onCategoryChanged: (v) => setState(() => selectedCategory = v),
      onSave: () {
        if (selectedCategory == null || amountController.text.isEmpty) return;
        TransactionDB.add(TransactionModel(
          amount: double.parse(amountController.text),
          category: selectedCategory!,
          type: "expense",
          account: selectedAccount,
          date: selectedDate,
          note: noteController.text,
        ));
        Navigator.pop(context);
      },
    );
  }
}