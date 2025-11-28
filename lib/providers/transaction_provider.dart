import 'package:flutter/foundation.dart';
import 'package:savemoney/db/database_helper.dart';
import 'package:savemoney/models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final db = DatabaseHelper.instance;

  List<TransactionModel> transactions = [];

  Future<void> loadTransactions() async {
    transactions = await db.readAll();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel t) async {
    await db.create(t);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await db.delete(id);
    await loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel t) async {
    await db.update(t);
    await loadTransactions();
  }
}