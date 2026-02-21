import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final Box<CategoryModel> _box = Hive.box<CategoryModel>('categoryBox');

  List<CategoryModel> getCategories(String type) {
    return _box.values.where((c) => c.type == type).toList();
  }

  Future<void> addCategory(String name, String type) async {
    final category = CategoryModel(
      name: name,
      type: type,
      isReserved: false,
    );
    await _box.add(category);
    notifyListeners();
  }

  Future<void> deleteCategory(CategoryModel category) async {
    if (!category.isReserved) {
      await category.delete();
      notifyListeners();
    }
  }
}