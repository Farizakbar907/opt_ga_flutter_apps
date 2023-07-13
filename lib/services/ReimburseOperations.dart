import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Reimburse.dart';
import '../helper-database/database.dart';

class ReimburseOperations {
  ReimburseOperations? reimburseOperations;

  final dbProvider = DatabaseCon();

  createReimburse(ReimburseModel reimburse) async {
    final db = await dbProvider.database;
    db?.insert('reimburses', reimburse.toMap());
  }

  updateReimburse(ReimburseModel reimburse) async {
    final db = await dbProvider.database;
    db?.update('reimburses', reimburse.toMap(),
        where: "id=?", whereArgs: [reimburse.id]);
  }

  deleteCar(ReimburseModel reimburse) async {
    final db = await dbProvider.database;
    await db?.delete('reimburses', where: 'id=?', whereArgs: [reimburse.id]);
  }

  Future<List<ReimburseModel>> getAllReimburse(
      ReimburseModel reimburseModel) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('reimburses',
        where: 'isDeleted=?', whereArgs: [reimburseModel.isDeleted = 0]);
    List<ReimburseModel> reimburses =
        allRows.map((reimburse) => ReimburseModel.fromMap(reimburse)).toList();
    return reimburses;
  }

  Future<List<ReimburseModel>> getData(User user) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> list =
        await db!.query('reimburses', where: 'idUser=?', whereArgs: [user.uid]);
    List<ReimburseModel> reimburses =
        list.map((reimburse) => ReimburseModel.fromMap(reimburse)).toList();
    return reimburses;
  }

  Future<List<ReimburseModel>> getDataVerificator(
      ReimburseModel reimburseModel) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> list = await db!.query('reimburses',
        where: 'status=?',
        whereArgs: [reimburseModel.status = 'Waiting Approve Verificator']);
    List<ReimburseModel> reimburses =
        list.map((reimburse) => ReimburseModel.fromMap(reimburse)).toList();
    return reimburses;
  }

  Future<List<ReimburseModel>> getDataManagement(
      ReimburseModel reimburseModel) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> list = await db!.query('reimburses',
        where: 'status=?',
        whereArgs: [reimburseModel.status = 'Waiting Approve Management']);
    List<ReimburseModel> reimburses =
        list.map((reimburse) => ReimburseModel.fromMap(reimburse)).toList();
    return reimburses;
  }
}
