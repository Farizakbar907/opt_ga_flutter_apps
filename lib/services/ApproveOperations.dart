import '../models/Approve.dart';
import '../models/Reimburse.dart';
import '../helper-database/database.dart';

class ApproveOperations {
  ApproveOperations? approveOperations;

  final dbProvider = DatabaseCon();

  createApprove(Approve approve) async {
    final db = await dbProvider.database;
    db?.insert('approve', approve.toMap());
  }

  updateApprove(Approve approve) async {
    final db = await dbProvider.database;
    db?.update('approve', approve.toMap(),
        where: "id=?", whereArgs: [approve.id]);
  }

  Future<List<Approve>> getAllApprovers(ReimburseModel reimburse) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('approve', 
    where: 'FK_approve_reimburse=?', whereArgs: [reimburse.id]);
    List<Approve> attachments =
        allRows.map((approver) => Approve.fromMap(approver)).toList();
    return attachments;
  }
  
}
