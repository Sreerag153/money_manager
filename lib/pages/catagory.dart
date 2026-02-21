import 'package:flutter/material.dart';
import 'package:money_manager_app/widget/catagory_dialog.dart';
import 'package:money_manager_app/widget/catogorylist.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xff0F172A),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff0F172A),
          title: const Text(
            "Categories",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff00FF62)),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.white,
            tabs: [Tab(text: "Income"), Tab(text: "Expense")],
          ),
        ),
        body: const TabBarView(
          children: [
            CategoryList(type: 'income'),
            CategoryList(type: 'expense'),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            backgroundColor: Colors.indigo,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Add Category", style: TextStyle(color: Colors.white)),
            onPressed: () {
              final currentIndex = DefaultTabController.of(context).index;
              showAddCategoryDialog(
                context: context,
                isIncomeTab: currentIndex == 0,
              );
            },
          ),
        ),
      ),
    );
  }
}