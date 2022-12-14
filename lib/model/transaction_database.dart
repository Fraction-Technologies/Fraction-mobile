import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Tdbase {
  static const db = 'transactions.db';
  static const version = 1;
// 0 = intraday , 1 = swing , 2 = delivery

  // The table for
  static const transactionTable = 'transactions';
  static const date = 'date';
  static const amount = 'amount';
  static const id = 'id';
  static const type = 'type'; // 1 = deposit  , 0 = withdraw

// make the class a singleton class
  Tdbase._privateConstructor();
  static final Tdbase instance = Tdbase._privateConstructor();

  Database _database;
  Future get database async {
    // ignore: unnecessary_null_comparison
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDB();
      return _database;
    }
  }

// Init the db if it doesn't already exist in the device
  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, db);
    return await openDatabase(path, version: version, onCreate: _populateDB);
  }

  Future _populateDB(Database db, int version) async {
    // Creating a database for the main notes
    return await db.execute('''

      CREATE TABLE IF NOT EXISTS $transactionTable (
        $id  INTEGER PRIMARY KEY  AUTOINCREMENT ,
        $amount DOUBLE,
        $date TEXT NOT NULL,
        $type INTEGER 
      )
      ''');
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(transactionTable, row);
  }

  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT * FROM $transactionTable
    ''');
  }

  Future<int> updateTransactions(Map<String, dynamic> row, int id) async {
    Database db = await database;
    return await db
        .update(transactionTable, row, where: '$id = ?', whereArgs: [row[id]]);
  }

  Future<int> deleteTransaction(int tid) async {
    Database db = await database;
    return await db
        .rawDelete('DELETE FROM $transactionTable WHERE $id = $tid ');
  }

  Future<dynamic> getTotalDeposit() async {
    Database db = await database;
    List tdep = await db.rawQuery('''
    SELECT SUM($amount) FROM $transactionTable
    WHERE $type = 1 or $type = '1';
    ''');
    return tdep[0]['SUM(amount)'];
  }

  Future<dynamic> getTotalWithdrawal() async {
    Database db = await database;
    List twith = await db.rawQuery('''
    SELECT SUM($amount) FROM $transactionTable
    WHERE $type = 0 or $type = '0';
    ''');
    return twith[0]['SUM(amount)'];
  }
}
