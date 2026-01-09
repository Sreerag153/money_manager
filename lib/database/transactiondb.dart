import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/model/transaction_model.dart';
import 'package:money_manager_app/model/wallet_model.dart';



class TransactionDB {
  static final txBox = Hive.box<TransactionModel>('transactions');
  static final walletBox = Hive.box<WalletModel>('wallet');

  static void add(TransactionModel tx) {
    txBox.add(tx);
    _updateWallet(tx, add: true);
  }

  static void delete(int index) {
    final tx = txBox.getAt(index);
    if (tx == null) return;

    _updateWallet(tx, add: false);
    txBox.deleteAt(index);
  }

  static void _updateWallet(TransactionModel tx, {required bool add}) {
    final wallet = walletBox.getAt(0)!;
    final factor = add ? 1 : -1;

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
