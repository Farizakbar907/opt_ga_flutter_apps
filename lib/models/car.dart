class Car {
  int? id;
  String? name;
  String? police_no;
  String? createdBy;
  String? updatedBy;
  // String? createdAt;
  String? updatedAt;
  int? isDeleted;

  Car(
      {this.id,
      this.name,
      this.police_no,
      this.createdBy,
      this.updatedBy,
      this.updatedAt,
      this.isDeleted});

  Car.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.police_no = obj['police_no'];
    this.createdBy = obj['createdBy'];
    this.updatedBy = obj['updatedBy'];
    this.updatedAt = obj['updatedAt'];
    this.isDeleted = obj['isDeleted'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      // 'id': id,
      'name': name,
      'police_no': police_no,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isDeleted': isDeleted
    };

    return map;
  }
}
