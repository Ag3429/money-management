import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_managment/models/transactions/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDBFunctions {
  Future<List<TransactionModel>> getTransaction();
  Future<void> addTransaction(TransactionModel obj);
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDBFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionsNotifier =
      ValueNotifier([]);
  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.put(obj.id, obj);
    refreshTransactions();
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.delete(id);
    refreshTransactions();
  }

  Future<void> refreshTransactions() async {
    final getAllTransaction = await getTransaction();
    getAllTransaction
        .sort((first, second) => second.date.compareTo(first.date));
    transactionsNotifier.value.clear();
    transactionsNotifier.value.addAll(getAllTransaction);

    transactionsNotifier.notifyListeners();
  }
}
