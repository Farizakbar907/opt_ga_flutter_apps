import 'package:opt_ga_flutter_apps/models/signature.dart';
import '../helper-database/database.dart';

class SignatureOperations {
  SignatureOperations? signatureOperations;

  final dbProvider = DatabaseCon();

  createSign(SignatureModel signature) async {
    final db = await dbProvider.database;
    db?.insert('signatures', signature.toMap());
  }

  updateSign(SignatureModel signature) async {
    final db = await dbProvider.database;
    db?.update('signatures', signature.toMap(),
        where: "id=?", whereArgs: [signature.id]);
  }

  deleteSign(SignatureModel signature) async {
    final db = await dbProvider.database;
    await db?.delete('signatures', where: 'id=?', whereArgs: [signature.id]);
  }

  Future<List<SignatureModel>> getAllSignature() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('signatures');
    List<SignatureModel> signs =
        allRows.map((signs) => SignatureModel.fromMap(signs)).toList();
    print('allRowsm: $allRows');
    print('signatures: $signs');
    return signs;
  }
}
