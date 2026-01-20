import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/model/wallet_model.dart';

class TransactionDB {
  static Box<TransactionModel> get box =>
      Hive.box<TransactionModel>('transactions');

  static Box<WalletModel> get walletBox =>
      Hive.box<WalletModel>('wallet');

  static void add(TransactionModel tx) {
    box.add(tx);
    _updateWallet(tx, true);
  }

  static void delete(dynamic key) {
    final tx = box.get(key);
    if (tx != null) {
      _updateWallet(tx, false);
      box.delete(key);
    }
  }

  static void _updateWallet(TransactionModel tx, bool add) {
    final wallet = walletBox.getAt(0)!;
    final f = add ? 1 : -1;

    if (tx.type == 'expense') {
      if (tx.account == 'Cash') {
        wallet.cashExpense += f * tx.amount;
      } else {
        wallet.accExpense += f * tx.amount;
      }
    } else {
      if (tx.account == 'Cash') {
        wallet.cashIncome += f * tx.amount;
      } else {
        wallet.accIncome += f * tx.amount;
      }
    }

    wallet.save();
  }
}            



