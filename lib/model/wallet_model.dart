import 'package:hive_flutter/hive_flutter.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 2)
class WalletModel extends HiveObject {
  @HiveField(0)
  double cashIncome;

  @HiveField(1)
  double cashExpense;

  @HiveField(2)
  double accIncome;

  @HiveField(3)
  double accExpense;

  WalletModel({
    this.cashIncome=0,
    this.cashExpense=0,
    this.accIncome=0,
    this.accExpense=0,
  });

  double get cashBalance => cashIncome - cashExpense;
  double get accBalance => accIncome - accExpense;
  double get totalBalance => cashBalance + accBalance;
}
