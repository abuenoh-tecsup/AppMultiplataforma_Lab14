import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:savemoney/models/transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('savemoney.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${TransactionFields.tableName} (
        ${TransactionFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TransactionFields.type} TEXT NOT NULL,
        ${TransactionFields.category} TEXT NOT NULL,
        ${TransactionFields.amount} REAL NOT NULL,
        ${TransactionFields.description} TEXT,
        ${TransactionFields.paymentMethod} TEXT,
        ${TransactionFields.isFavorite} INTEGER NOT NULL,
        ${TransactionFields.createdAt} TEXT NOT NULL
      )
    ''');
  }

  Future<TransactionModel> create(TransactionModel trx) async {
    final db = await instance.database;
    final id =
        await db.insert(TransactionFields.tableName, trx.toJson());
    return trx.copy(id: id);
  }

  Future<List<TransactionModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query(
      TransactionFields.tableName,
      orderBy: '${TransactionFields.createdAt} DESC',
    );
    return result.map((json) => TransactionModel.fromJson(json)).toList();
  }

  Future<int> update(TransactionModel trx) async {
    final db = await instance.database;
    return db.update(
      TransactionFields.tableName,
      trx.toJson(),
      where: '${TransactionFields.id} = ?',
      whereArgs: [trx.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      TransactionFields.tableName,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
