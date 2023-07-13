class Attachment {
  int? id;
  String? idReimburse;
  String? fileName;
  String? location;
  String? createdBy;
  String? updatedBy;
  String? updatedAt;
  // int? isDeleted;

  Attachment(
      {this.id,
      this.idReimburse,
      this.fileName,
      this.location,
      this.createdBy,
      this.updatedBy,
      this.updatedAt});

  Attachment.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.idReimburse = obj['FK_attachment_reimburse'];
    this.fileName = obj['fileName'];
    this.location = obj['location'];
    this.createdBy = obj['createdBy'];
    this.updatedBy = obj['updatedBy'];
    this.updatedAt = obj['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'fileName': fileName,
      'FK_attachment_reimburse': idReimburse,
      'location': location,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt
    };

    return map;
  }
}
