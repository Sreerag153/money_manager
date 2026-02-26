import 'package:flutter/material.dart';
import 'package:money_manager_app/provider/catagory_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/provider/transaction_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager_app/model/category_model.dart';

class CategoryList extends StatelessWidget {
  final String type;
  const CategoryList({super.key, required this.type});

  Future<void> _confirmDelete(
      BuildContext context, CategoryModel category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xff1E293B),
          title: const Text(
            "Delete Category",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Are you sure you want to delete '${category.name}'?",  
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).deleteCategory(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final categories = categoryProvider.getCategories(type);

    if (categories.isEmpty) {
      return const Center(
        child: Text(
          "No categories found",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final total = transactionProvider.transactions
            .where((t) => t.category == category.name && t.type == type)
            .fold(0.0, (sum, t) => sum + t.amount);

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Slidable(
            key: ValueKey(category.key),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _confirmDelete(context, category),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        type == 'income' ? Colors.green : Colors.red,
                    child:
                        const Icon(Icons.category, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "₹${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: type == 'income'
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}