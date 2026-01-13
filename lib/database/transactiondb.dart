import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/model/wallet_model.dart';



class TransactionDB {
  static Box<TransactionModel> get box => Hive.box<TransactionModel>('transactions');
  static Box<WalletModel> get walletBox => Hive.box<WalletModel>('wallet');

  static void add(TransactionModel tx) {
    _updateWallet(tx, true);
  }

  static void delete(int index) {
    final tx = box.getAt(index);
    if (tx != null) {
      _updateWallet(tx, false);
      box.deleteAt(index);
    }
  }

  static void _updateWallet(TransactionModel tx, bool isAdd) {
    final wallet = walletBox.getAt(0)!;
    final factor = isAdd ? 1 : -1;

    if (tx.type == 'income') {
      if (tx.account == 'Cash') {
        wallet.cashIncome += factor * tx.amount;
      } else {
        wallet.accIncome += factor * tx.amount;
      }
    } else {
      if (tx.account == 'Cash') {
        wallet.cashExpense += factor * tx.amount;
      } else {
        wallet.accExpense += factor * tx.amount;
      }
    }

    wallet.save();
  }
}
