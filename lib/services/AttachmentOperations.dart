import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Attachment.dart';
import '../models/reimburse.dart';
import '../helper-database/database.dart';
import 'ReimburseOperations.dart';

class AttachmentOperations {
  AttachmentOperations? attachmentOperations;
  ReimburseOperations reimburseOperations = ReimburseOperations();

  final dbProvider = DatabaseCon();

  createAttachment(List<Attachment> attachment) async {
    final db = await dbProvider.database;
    attachment.forEach((element) {
      List<Attachment> _attachment = [];
      Attachment attachmentModel = Attachment();
      attachmentModel.idReimburse = element.idReimburse;
      attachmentModel.fileName = element.fileName;
      attachmentModel.location = element.location;
      attachmentModel.createdBy = element.createdBy;
      db?.insert('attachments', attachmentModel.toMap());
    });
  }

  updateAttachment(Attachment attachment) async {
    final db = await dbProvider.database;
    db?.update('attachments', attachment.toMap(),
        where: "id=?", whereArgs: [attachment.id]);
  }

  deleteAttachment(Attachment attachment) async {
    final db = await dbProvider.database;
    await db?.delete('attachments', where: 'id=?', whereArgs: [attachment.id]);
  }

  Future<List<Attachment>> getAllAttachments() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('attachments');
    List<Attachment> attachments =
        allRows.map((attachment) => Attachment.fromMap(attachment)).toList();
    return attachments;
  }
}
