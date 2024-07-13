import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/transaction_data.dart';

class DatabaseHelper {
  static Database? _database;
  final String transactionTable = 'transaction_table';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'transactions.db');

    return await openDatabase(databasePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $transactionTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          description TEXT,
          amount REAL,
          date TEXT
        )
      ''');
    });
  }

  Future<void> insertTransaction(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert(transactionTable, row);
  }

  Future<void> updateTransaction(TransactionData transaction) async {
    final db = await database;
    await db.update(
      transactionTable,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete(
      transactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> queryAllTransactions() async {
    final db = await database;
    return await db.query(transactionTable);
  }
}
