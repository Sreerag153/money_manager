import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:money_manager_app/model/category_model.dart';
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

  String capitalize(String text){
    if (text.isEmpty)return text;
    return text[0].toUpperCase()+text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 86, 86, 86),
      appBar: AppBar(
        title: const Text("Category"),
        bottom: TabBar(
          controller: _tabController,
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
      floatingActionButton: FloatingActionButton(
        onPressed: addCategoryDialog,
        child: const Icon(Icons.add),
      ),
    );

}

  void addCategoryDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Category"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Category name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isEmpty) return;

                final type = _tabController.index == 0 ? 'income' : 'expense';

                final category = CategoryModel(
                  name: capitalize(controller.text.trim()),
                  type: type,
                );

                categoryBox.add(category);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
