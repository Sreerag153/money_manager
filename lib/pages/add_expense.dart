import 'package:flutter/material.dart';
import 'package:money_manager_app/provider/transation_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/database/catagorydb.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/pages/transation.dart';
import 'package:money_manager_app/provider/transaction_provider.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final categories = CategoryDB.getExpenseCategories(includeReserved: true).map((e) => e.name).toList();

    return ChangeNotifierProvider(
      create: (_) => TransactionFormProvider()..init(categories.first, "Cash"),
      child: Consumer<TransactionFormProvider>(
        builder: (context, form, _) => TransactionPage(
          title: "Add Expense",
          color: Colors.red,
          categories: categories,
          amountController: amountController,
          noteController: noteController,
          onSave: () {
            if (amountController.text.isEmpty) return;
            context.read<TransactionProvider>().addTransaction(TransactionModel(
              amount: double.parse(amountController.text),
              category: form.selectedCategory,
              type: "expense",
              account: form.selectedAccount,
              date: form.selectedDate,
              note: noteController.text,
            ));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}