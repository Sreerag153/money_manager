import 'package:flutter/material.dart';
import 'package:money_manager_app/database/catagorydb.dart';
import 'package:money_manager_app/database/transactiondb.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/pages/transation.dart';


class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  DateTime selectedDate = DateTime.now();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  late String selectedCategory;
  String selectedAccount = "Account";

  @override
  void initState() {
    super.initState();
    selectedCategory = CategoryDB.getIncomeCategories().first.name;
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        CategoryDB.getIncomeCategories().map((e) => e.name).toList();

    return TransactionPage(
      title: "Add Income",
      color: Colors.green,
      categories: categories,
      selectedDate: selectedDate,
     onPickDate: () async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    setState(() {
      selectedDate = pickedDate;
    });
  }
},

      amountController: amountController,
      noteController: noteController,
      selectedCategory: selectedCategory,
      selectedAccount: selectedAccount,
      onAccountChanged: (v) => setState(() => selectedAccount = v),
      onCategoryChanged: (v) => setState(() => selectedCategory = v!),
      onSave: () {
        TransactionDB.add(
          TransactionModel(
            amount: double.parse(amountController.text),
            category: selectedCategory,
            type: "income",
            account: selectedAccount,
            date: selectedDate,
            note: noteController.text,
          ),
        );
        Navigator.pop(context);
      },
    );
  }
}
