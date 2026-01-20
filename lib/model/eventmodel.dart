import 'package:hive_flutter/hive_flutter.dart';

part 'eventmodel.g.dart';

@HiveType(typeId: 6)
class EventModel extends HiveObject {

  @HiveField(0)
  String name;

  @HiveField(1)
  int members;

  @HiveField(2)
  double totalAmount;

  @HiveField(3)
  String status;

  @HiveField(4)
  String? category; 

  @HiveField(5)
  double? splitAmount;

  @HiveField(6)
  String? attachmentPath;

  @HiveField(7)
  String paymentType;
  
  @HiveField(8)
  bool? expenceAdd;

  EventModel({
    required this.name,
    required this.members,
    required this.totalAmount,
    required this.status,
    required this.category,
    required this.splitAmount,
    this.attachmentPath,
    required this. paymentType,
    this.expenceAdd,
  }) ;
}
