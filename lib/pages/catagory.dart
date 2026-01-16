import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:money_manager_app/model/category_model.dart';
import 'package:money_manager_app/widget/catagory_dialog.dart';
import 'package:money_manager_app/widget/catogorylist.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Box<CategoryModel> categoryBox;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    categoryBox = Hive.box<CategoryModel>('categoryBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff0F172A),
        title: const Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(text: "Income"),
            Tab(text: "Expense"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CategoryList(type: 'income'),
          CategoryList(type: 'expense'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
        onPressed: () {
          showAddCategoryDialog(
            context: context,
            tabController: _tabController,
            categoryBox: categoryBox,
          );
        },
      ),
    );
  }
}