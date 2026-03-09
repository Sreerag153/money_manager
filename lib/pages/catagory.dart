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
          backgroundColor: const Color(0xff0F172A),
          elevation: 0,
          title: const Text(
            "Categories",
            style: TextStyle(
              color: Color(0xff00FF62),
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: "Income"),
              Tab(text: "Expense"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CategoryList(type: 'income'),
            CategoryList(type: 'expense'),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.add),
              onPressed: () {
                final index =
                    DefaultTabController.of(context).index;

                showAddCategoryDialog(
                  context: context,
                  isIncomeTab: index == 0,
                );
              },
            );
          },
        ),
      ),
    );
  }
}