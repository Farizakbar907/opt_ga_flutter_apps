class Approve {
  int? id;
  String? idReimburse;
  int? idSignature;
  String? status;
  String? approveBy;
  String? approveAt;

  Approve(
      {this.id,
      this.idReimburse,
      this.idSignature,
      this.status,
      this.approveBy,
      this.approveAt});

  Approve.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.idReimburse = obj['FK_approve_reimburse'];
    this.idSignature = obj['idSignature'];
    this.status = obj['status'];
    this.approveBy = obj['approveBy'];
    this.approveAt = obj['approveAt'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'FK_approve_reimburse': idReimburse,
      'idSignature': idSignature,
      'status': status,
      'approveBy': approveBy,
      'approveAt': approveAt
    };

    return map;
  }
}
