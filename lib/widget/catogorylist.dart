import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/category_model.dart';
import 'package:money_manager_app/model/transaction_model.dart';

class CategoryList extends StatelessWidget {
  final String type;

  const CategoryList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final categoryBox = Hive.box<CategoryModel>('categoryBox');
    final transactionBox = Hive.box<TransactionModel>('transactions');

    return ValueListenableBuilder(
      valueListenable: categoryBox.listenable(),
      builder: (context, Box<CategoryModel> box, _) {
        final categories =
            box.values.where((c) => c.type == type).toList();

        if (categories.isEmpty) {
          return const Center(
            child: Text(
              "No categories found",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final isIncome = type == 'income';

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            final totalAmount = transactionBox.values
                .where((t) =>
                    t.category == category.name && t.type == type)
                .fold(0.0, (sum, t) => sum + t.amount);

            return Slidable(
              key: ValueKey(category.key),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) =>
                        categoryBox.delete(category.key),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
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
                      child: const Icon(
                        Icons.category,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "₹${totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color:
                            isIncome ? Colors.greenAccent : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}