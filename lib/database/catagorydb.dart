import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/category_model.dart';




class CategoryDB {
  static final Box<CategoryModel> _box = Hive.box<CategoryModel>('categoryBox');

  static Future<void> addCategory(CategoryModel category) async {
    await _box.add(category);
  }

  static List<CategoryModel> getIncomeCategories({bool includeReserved = false}) {
    return _box.values
        .where((c) => c.type == 'income' && (includeReserved || !c.isReserved))
        .toList();
  }

  static List<CategoryModel> getExpenseCategories({bool includeReserved = false}) {
    return _box.values
        .where((c) => c.type == 'expense' && (includeReserved || !c.isReserved))
        .toList();
  }

  static Future<void> deleteCategory(int index) async {
    await _box.deleteAt(index);
  }


  static Future<void> initializeDefaultCategories() async {
    if (_box.isEmpty) {
      await _box.add(CategoryModel(name: 'Salary', type: 'income', isReserved: true));
      await _box.add(CategoryModel(name: 'Investment', type: 'income', isReserved: true));

      await _box.add(CategoryModel(name: 'Trip', type: 'expense', isReserved: true));
      await _box.add(CategoryModel(name: 'Food', type: 'expense', isReserved: true));
      await _box.add(CategoryModel(name: 'Groceries', type: 'expense', isReserved: true));
      await _box.add(CategoryModel(name: 'Entertainment', type: 'expense', isReserved: true));
      await _box.add(CategoryModel(name: 'Health', type: 'expense', isReserved: true));
    }
  }
}
