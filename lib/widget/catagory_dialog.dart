import 'package:flutter/material.dart';
import 'package:money_manager_app/provider/catagory_provider.dart';
import 'package:provider/provider.dart';

void showAddCategoryDialog({
  required BuildContext context,
  required bool isIncomeTab,
}) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xff1E293B),
        title: Text(
          isIncomeTab
              ? "Add Income Category"
              : "Add Expense Category",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Category name",
            hintStyle:
                const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xff0F172A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              await Provider.of<CategoryProvider>(
                context,
                listen: false,
              ).addCategory(
                name,
                isIncomeTab ? 'income' : 'expense',
              );

              Navigator.pop(dialogContext);
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}