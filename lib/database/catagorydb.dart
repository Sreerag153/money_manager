import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/category_model.dart';




class CategoryDB {
  static final Box<CategoryModel> _box =
      Hive.box<CategoryModel>('categoryBox');

  static Future<void> addCategory(CategoryModel category) async {
    await _box.add(category);
  }

  static List<CategoryModel> getIncomeCategories() {
    return _box.values.where((c) => c.type == 'income').toList();
  }

  static List<CategoryModel> getExpenseCategories() {
    return _box.values.where((c) => c.type == 'expense').toList();
  }

  static Future<void> deleteCategory(int index) async {
    await _box.deleteAt(index);
  }

  static List<CategoryModel> getAllCategories() {
    return _box.values.toList();
  }
}
