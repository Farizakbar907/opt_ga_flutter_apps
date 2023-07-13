import 'package:uuid/uuid.dart';

class ReimburseModel {
  String? id = Uuid().v4();
  // String? uuid = Uuid().v4();
  String? no_approval;
  String? divisi;
  String? username;
  int? npk;
  int? policeNo;
  String? expGas;
  String? exp_toll;
  String? exp_parking;
  String? others;
  int? qtyGas;
  int? qtyToll;
  int? qtyPark;
  int? qtyOthers;
  double? amountGas;
  double? amountToll;
  double? amountPark;
  double? amountOthers;
  double? totals;
  String? notes;
  String? status;
  String? idUser;
  String? createdAt;
  String? createdBy;
  String? updatedBy;
  String? updatedAt;
  int? isDeleted;

  ReimburseModel(
      {this.id,
      this.no_approval,
      this.divisi,
      this.username,
      this.npk,
      this.policeNo,
      this.expGas,
      this.exp_parking,
      this.exp_toll,
      this.others,
      this.qtyGas,
      this.qtyToll,
      this.qtyPark,
      this.qtyOthers,
      this.amountGas,
      this.amountToll,
      this.amountPark,
      this.amountOthers,
      this.totals,
      this.notes,
      this.status,
      this.idUser,
      this.createdAt,
      this.createdBy,
      this.updatedBy,
      this.updatedAt,
      this.isDeleted});

  ReimburseModel.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.no_approval = obj['no_approval'];
    this.divisi = obj['divisi'];
    this.username = obj['username'];
    this.npk = obj['NPK'];
    this.policeNo = obj['FK_reimburse_car'];
    this.expGas = obj['exp_gasoline'];
    this.exp_toll = obj['exp_toll'];
    this.exp_parking = obj['exp_parking'];
    this.others = obj['others'];
    this.qtyGas = obj['qty_gas'];
    this.qtyToll = obj['qty_toll'];
    this.qtyPark = obj['qty_park'];
    this.qtyOthers = obj['qty_others'];
    this.amountGas = obj['amount_gas'];
    this.amountToll = obj['amount_toll'];
    this.amountPark = obj['amount_park'];
    this.amountOthers = obj['amount_others'];
    this.totals = obj['total'];
    this.notes = obj['notes'];
    this.status = obj['status'];
    this.idUser = obj['idUser'];
    this.createdAt = obj['createdAt'];
    this.createdBy = obj['createdBy'];
    this.updatedBy = obj['updatedBy'];
    this.updatedAt = obj['updatedAt'];
    this.isDeleted = obj['isDeleted'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'no_approval': no_approval,
      'divisi': divisi,
      'username': username,
      'NPK': npk,
      'FK_reimburse_car': policeNo,
      'exp_gasoline': expGas,
      'exp_toll': exp_toll,
      'exp_parking': exp_parking,
      'others': others,
      'qty_gas': qtyGas,
      'qty_toll': qtyToll,
      'qty_park': qtyPark,
      'qty_others': qtyOthers,
      'amount_gas': amountGas,
      'amount_toll': amountToll,
      'amount_park': amountPark,
      'amount_others': amountOthers,
      'total': totals,
      'notes': notes,
      'status': status,
      'idUser': idUser,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isDeleted': isDeleted
    };
    return map;
  }
}
