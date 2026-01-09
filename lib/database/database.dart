import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/category_model.dart';
import 'package:money_manager_app/model/eventmodel.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/model/wallet_model.dart';



class Database {
  static Future init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(WalletModelAdapter());
    Hive.registerAdapter(EventModelAdapter());


    await Hive.openBox<TransactionModel>('transactions');
    await Hive.openBox<CategoryModel>('categoryBox');
    await Hive.openBox<WalletModel>('wallet');
    await Hive.openBox<EventModel>('eventsBox');


    if (Hive.box<WalletModel>('wallet').isEmpty) {
      Hive.box<WalletModel>('wallet').add(
        WalletModel(
          cashIncome: 0,
          cashExpense: 0,
          accIncome: 0,
          accExpense: 0,
        ),
      );
    }
  }
}
