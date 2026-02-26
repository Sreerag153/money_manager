import 'package:flutter/material.dart';
import 'package:money_manager_app/database/catagorydb.dart';
import 'package:money_manager_app/model/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider() {
    loadDefaults();
  }

  Future<void> loadDefaults() async {
    await CategoryDB.initializeDefaultCategories();
    notifyListeners();
  }

  List<CategoryModel> getCategories(String type) {
    return type == 'income'
        ? CategoryDB.getIncomeCategories()
        : CategoryDB.getExpenseCategories();
  }

  Future<void> addCategory(String name, String type) async {
    final category = CategoryModel(
      name: name,
      type: type,
      isReserved: false,
    );
    await CategoryDB.addCategory(category);
    notifyListeners();
  }

  Future<void> deleteCategory(CategoryModel category) async {
    await CategoryDB.deleteCategory(category);
    notifyListeners();
  }
}