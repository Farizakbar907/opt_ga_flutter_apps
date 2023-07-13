class SignatureModel {
  int? id;
  String? idUser;
  int? npk;
  String? signatureFile;
  String? locSignature;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  SignatureModel(
      {this.createdAt,
      this.createdBy,
      this.id,
      this.idUser,
      this.locSignature,
      this.npk,
      this.signatureFile,
      this.updatedAt,
      this.updatedBy,});

  SignatureModel.fromMap(dynamic obj) {
    this.createdAt = obj['createdAt'];
    this.createdBy = obj['createdBy'];
    this.id = obj['id'];
    this.idUser = obj['idUser'];
    this.locSignature = obj['locSignature'];
    this.npk = obj['npk'];
    this.signatureFile = obj['signatureFile'];
    this.updatedAt = obj['updatedAt'];
    this.updatedBy = obj['updatedBy'];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'createdAt': createdAt,
      'createdBy': createdBy,
      'idUser': idUser,
      'locSignature': locSignature,
      'npk': npk,
      'signatureFile': signatureFile,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
    };

    return map;
  }
}
