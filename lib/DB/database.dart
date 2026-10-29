import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/model.dart';


class ExpenseDatabase {
  static final ExpenseDatabase instance = ExpenseDatabase._init();

  static Database? _database;

  ExpenseDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('expenzia.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            type TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return db.insert('expenses', expense.toMap());
  }

  // READ
  Future<List<Expense>> getExpenses() async {
    final db = await database;

    final result = await db.query(
      'expenses',
      orderBy: 'id DESC',
    );

    return result.map((map) => Expense.fromMap(map)).toList();
  }

  // UPDATE
  Future<int> updateExpense(Expense expense) async {
    if (expense.id == null) {
      throw ArgumentError('Expense ID is required for updating.');
    }

    final db = await database;

    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // DELETE
  Future<int> deleteExpense(int id) async {
    final db = await database;

    return db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }
}