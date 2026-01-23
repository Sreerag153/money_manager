import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/database/catagorydb.dart';

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
    CategoryDB.initializeDefaultCategories();
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
            color: Color.fromRGBO(0, 255, 98, 0.871),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: "Income"),
            Tab(text: "Expense"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CategoryList(type: 'income',),
          CategoryList(type: 'expense'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add,color: Colors.white,),
        label: const Text("Add Category",style: TextStyle(color: Colors.white),),
        onPressed: () => showAddCategoryDialog(
          context: context,
          tabController: _tabController,
          categoryBox: categoryBox,
        ),
      ),
    );
  }
}
