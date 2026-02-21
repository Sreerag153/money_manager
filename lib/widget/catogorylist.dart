import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager_app/provider/catagory_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/provider/transaction_provider.dart';

class CategoryList extends StatelessWidget {
  final String type;
  const CategoryList({super.key, required this.type});

  Future<bool?> _confirmDelete(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1E293B),
        title: const Text("Delete Category", style: TextStyle(color: Colors.white)),
        content: Text("Delete '$name'?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catProv = context.watch<CategoryProvider>();
    final txProv = context.watch<TransactionProvider>();
    final categories = catProv.getCategories(type);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final total = txProv.transactions
            .where((t) => t.category == cat.name && t.type == type)
            .fold(0.0, (sum, t) => sum + t.amount);

        return Slidable(
          key: ValueKey(cat.key),
          endActionPane: cat.isReserved ? null : ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  if (await _confirmDelete(context, cat.name) == true) {
                    catProv.deleteCategory(cat);
                  }
                },
                backgroundColor: Colors.redAccent,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xff1E293B), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: type == 'income' ? Colors.green : Colors.red,
                  child: const Icon(Icons.category, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cat.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      if (cat.isReserved)
                        const Text("System Reserved", style: TextStyle(color: Colors.amber, fontSize: 10)),
                    ],
                  ),
                ),
                Text("₹${total.toStringAsFixed(2)}",
                  style: TextStyle(color: type == 'income' ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}