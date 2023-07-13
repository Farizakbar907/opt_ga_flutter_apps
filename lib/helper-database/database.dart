import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseCon {
  static final DatabaseCon _instance = new DatabaseCon.internal();
  factory DatabaseCon() => _instance;

  final _databaseName = 'DEV_OPT_GA.db';
  final _databaseVersion = 1;

  static Database? _database;
  static final DatabaseCon _databaseCon = DatabaseCon();
  DatabaseCon.internal();

  // Cek apakah db ada ?
  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    final databasePath = await getDatabasesPath();
    // Directory documentsDirectory = Directory('C:\\Database');
    String path = join(databasePath, _databaseName);
    // String path = join(documentsDirectory, _databaseName);
    print('dbPath: $databasePath');
    print('path: $path');
    // print('pathDir : $documentsDirectory.path');
    print('dbName: $_databaseName');
    return await openDatabase(path,
        version: _databaseVersion, onOpen: (db) {}, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE cars (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            name STRING NOT NULL, 
            police_no STRING NOT NULL,
            createdBy STRING NULL,
            createdAt TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
            updatedBy STRING NULL,
            updatedAt TIMESTAMP NULL,
            isDeleted BOOLEAN NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE reimburses (
            id STRING PRIMARY KEY NOT NULL,
            no_approval STRING NULL,
            divisi STRING NOT NULL,
            username STRING NULL,
            NPK STRING NULL,
            FK_reimburse_car INT NOT NULL,
            exp_gasoline STRING NULL,
            exp_toll STRING NULL, 
            exp_parking STRING NULL,
            others STRING NULL,
            qty_gas INT NULL,
            qty_toll INT NULL,
            qty_park INT NULL,
            qty_others INT NULL, 
            amount_gas double NULL,
            amount_toll double NULL,
            amount_park double NULL,
            amount_others double NULL,
            total double NULL,
            notes STRING NULL,
            status STRING NULL,
            idUser STRING NULL,
            createdBy STRING NULL,
            createdAt TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
            updatedBy STRING NULL,
            updatedAt TIMESTAMP NULL,
            isDeleted BOOLEAN NULL,
            FOREIGN KEY (FK_reimburse_car) REFERENCES cars (id)
          )
          ''');

    await db.execute('''
          CREATE TABLE attachments (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            FK_attachment_reimburse STRING NULL,
            fileName STRING NULL,
            location STRING NULL, 
            createdBy STRING NULL,
            createdAt TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
            updatedBy STRING NULL,
            updatedAt TIMESTAMP NULL,
            FOREIGN KEY (FK_attachment_reimburse) REFERENCES reimburses (id)
          )
          ''');

    await db.execute('''
          CREATE TABLE approve (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            FK_approve_reimburse STRING NULL,
            idSignature INT NULL,
            status STRING NULL,
            approveBy STRING NULL,
            approveAt TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (FK_approve_reimburse) REFERENCES reimburses (id),
            FOREIGN KEY (idSignature) REFERENCES signatures (id)
          )
          ''');

    await db.execute('''
          CREATE TABLE signatures (
            createdAt STRING NULL,
            createdBy STRING NULL,
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idUser STRING NULL,
            locSignature STRING NULL,
            npk INT NULL,
            signatureFile STRING NULL,
            updatedAt STRING NULL, 
            updatedBy STRING NULL
          )
          ''');
  }
}
