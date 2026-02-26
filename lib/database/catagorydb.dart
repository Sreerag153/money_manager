import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/category_model.dart';

class CategoryDB {
  static Box<CategoryModel> get _box =>
      Hive.box<CategoryModel>('categoryBox');

  static Future<void> addCategory(CategoryModel category) async {
    await _box.add(category);
  }

  static List<CategoryModel> getIncomeCategories(
      {bool includeReserved = true}) {
    return _box.values
        .where((c) =>
            c.type == 'income' &&
            (includeReserved || !c.isReserved))
        .toList();
  }

  static List<CategoryModel> getExpenseCategories(
      {bool includeReserved = true}) {
    return _box.values
        .where((c) =>
            c.type == 'expense' &&
            (includeReserved || !c.isReserved))
        .toList();
  }
  static Future<void> deleteCategory(CategoryModel category) async {
  await category.delete();
}

  static Future<void> initializeDefaultCategories() async {
    if (_box.isEmpty) {
      final defaults = [
        CategoryModel(
            name: 'Salary',
            type: 'income',
            isReserved: true),
        CategoryModel(
            name: 'Investment',
            type: 'income',
            isReserved: true),
        CategoryModel(
            name: 'Trip',
            type: 'expense',
            isReserved: true),
        CategoryModel(
            name: 'Food',
            type: 'expense',
            isReserved: true),
        CategoryModel(
            name: 'Groceries',
            type: 'expense',
            isReserved: true),
        CategoryModel(
            name: 'Entertainment',
            type: 'expense',
            isReserved: true),
        CategoryModel(
            name: 'Health',
            type: 'expense',
            isReserved: true),
      ];
      await _box.addAll(defaults);
    }
  }
}