import 'package:hive_flutter/hive_flutter.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type; 

  @HiveField(2)
  bool isReserved;
  CategoryModel({required this.name, required this.type,required this.isReserved});
}
