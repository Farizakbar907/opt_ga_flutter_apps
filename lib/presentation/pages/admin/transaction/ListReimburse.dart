import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../models/Attachment.dart';
import '../../../../models/Reimburse.dart';
import '../../../../screens/admin/administrator.dart';
import '../../../../screens/driver/driver.dart';
import '../../../../screens/management/management.dart';
import '../../../../screens/verificator/verificator.dart';
import '../../../../services/AttachmentOperations.dart';
import '../../../../services/ReimburseOperations.dart';
import '../approval/UpdateApprovalDriver.dart';
import '../approval/UpdateApprovalManagement.dart';
import 'AddReimburse.dart';

class ListReimburse extends StatefulWidget {
  // List<ReimburseModel> reimburses;
  // List<Attachment> attachments;
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  const ListReimburse({this.user, this.doccumentSnapshot});

  @override
  State<ListReimburse> createState() => _ListReimburseState();
}

class _ListReimburseState extends State<ListReimburse> {
  // Get Current User Login from Firebase
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic name;
  dynamic email;
  dynamic rool;
  ReimburseOperations reimburseOperations = ReimburseOperations();
  AttachmentOperations attachmentOperations = AttachmentOperations();
  List<ReimburseModel> listReimburse = [];
  List<Attachment> listAttachments = [];
  List<Attachment> tempListAttachments = [];
  List<ReimburseModel> tempListReimburses = [];
  ReimburseModel tempReimburse = ReimburseModel();
  Attachment tempAttachment = Attachment();

  // Object for List Reimburse DataTable
  final scrollController = ScrollController();
  late ReimburseModel resReimburse = ReimburseModel();
  late List<Attachment> resAttachments = [];
  late List<Attachment> resultAttachments = [];

  getDataReimburse() async {
    if (_doccumentSnapshot.exists) {
      if (_doccumentSnapshot.get('rool') == 'Administrator') {
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Reimburse(
                          user: _currentUser,
                          doccumentSnapshot: _doccumentSnapshot,
                        )));
          },
          child: const Icon(Icons.playlist_add_rounded),
        );
        listReimburse =
            await reimburseOperations.getAllReimburse(tempReimburse);
        listAttachments = await attachmentOperations.getAllAttachments();
      } else if (_doccumentSnapshot.get('rool') == 'Driver') {
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Reimburse(
                          user: _currentUser,
                          doccumentSnapshot: _doccumentSnapshot,
                        )));
          },
          child: const Icon(Icons.playlist_add_rounded),
        );
        listReimburse = await reimburseOperations.getData(_currentUser);
        listAttachments = await attachmentOperations.getAllAttachments();
      } else if (_doccumentSnapshot.get('rool') == 'Management') {
        Visibility(
          visible: false,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Reimburse(
                            user: _currentUser,
                            doccumentSnapshot: _doccumentSnapshot,
                          )));
            },
            child: const Icon(Icons.playlist_add_rounded),
          ),
        );
        listReimburse =
            await reimburseOperations.getDataManagement(tempReimburse);
        listAttachments = await attachmentOperations.getAllAttachments();
      } else {
        Visibility(
          visible: false,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Reimburse(
                            user: _currentUser,
                            doccumentSnapshot: _doccumentSnapshot,
                          )));
            },
            child: const Icon(Icons.playlist_add_rounded),
          ),
        );
        listAttachments = await attachmentOperations.getAllAttachments();
        listReimburse =
            await reimburseOperations.getDataVerificator(tempReimburse);
      }
    }
  }

  @override
  void initState() {
    _currentUser = widget.user!;
    _doccumentSnapshot = widget.doccumentSnapshot!;
    // tempListAttachments = widget.attachments;
    // tempListReimburses = widget.reimburses;
    // ignore: unused_local_variable
    var resultQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();
    if (_doccumentSnapshot.exists) {
      _doccumentSnapshot.get('name');
      _doccumentSnapshot.get('npk');
      _doccumentSnapshot.get('rool');
      name = _doccumentSnapshot.get('name');
      email = _doccumentSnapshot.get('email');
      rool = _doccumentSnapshot.get('rool');
    }
    // super.initState();
    setState(() {
      getDataReimburse();
    });
  }

  void insertDataTemp(ReimburseModel tempReimburse) {
    resReimburse = tempReimburse;
    resAttachments = listAttachments;
    resAttachments.forEach((element) {
      resAttachments.where((element) => element.idReimburse == resReimburse.id);
      Attachment attachmentModels = Attachment();
      attachmentModels.idReimburse = resReimburse.id;
      if (element.idReimburse == resReimburse.id) {
        resultAttachments.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Reimburse'),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            if (rool == "Administrator") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Administrator(
                            user: _currentUser,
                            doccumentSnapshot: _doccumentSnapshot,
                          )));
            } else if (rool == "Driver") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Driver(
                            user: _currentUser,
                            doccumentSnapshot: _doccumentSnapshot,
                          )));
            } else if (rool == "Management") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManagementPage(
                            user: _currentUser,
                            doccumentSnapshot: _doccumentSnapshot,
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerificatorPage(
                            user: _currentUser,
                            doccumentSnapshot: _doccumentSnapshot,
                          )));
            }
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FutureBuilder(
                future: getDataReimburse(),
                builder: (context, snapshot) {
                  getDataReimburse();
                  return InteractiveViewer(
                    scaleEnabled: false,
                    child: Scrollbar(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing:
                              (MediaQuery.of(context).size.width / 10) * 0.67,
                          dataRowHeight: 55,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Divisi',
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Prepared By',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'NPK',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Exp Gasoline',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Exp Toll',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Exp Parking',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Qty Gas',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Qty Toll',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Qty Parking',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Amount Gas',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Amount Toll',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Amount Parking',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Action',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                          ],
                          rows: listReimburse
                              .map(
                                (e) => DataRow(cells: [
                                  DataCell(
                                    Text(e.divisi.toString()),
                                  ),
                                  DataCell(
                                    Text(e.createdBy.toString()),
                                  ),
                                  DataCell(
                                    Text(e.npk.toString()),
                                  ),
                                  DataCell(
                                    Text(e.expGas.toString()),
                                  ),
                                  DataCell(
                                    Text(e.exp_toll.toString()),
                                  ),
                                  DataCell(
                                    Text(e.exp_parking.toString()),
                                  ),
                                  DataCell(
                                    Text(e.qtyGas.toString()),
                                  ),
                                  DataCell(
                                    Text(e.qtyToll.toString()),
                                  ),
                                  DataCell(
                                    Text(e.qtyPark.toString()),
                                  ),
                                  DataCell(
                                    Text(e.amountGas.toString()),
                                  ),
                                  DataCell(
                                    Text(e.amountToll.toString()),
                                  ),
                                  DataCell(
                                    Text(e.amountPark.toString()),
                                  ),
                                  DataCell(
                                    Text(e.status.toString()),
                                  ),
                                  DataCell(
                                    Text(e.totals.toString()),
                                  ),
                                  DataCell(IconButton(
                                      onPressed: () {
                                        initState();
                                        insertDataTemp(e);
                                        if (_doccumentSnapshot.get('rool') !=
                                            'Driver') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewDetailReimbursePage(
                                                        reimburseModel:
                                                            resReimburse,
                                                        attachmentModel:
                                                            resultAttachments,
                                                        user: _currentUser,
                                                        doccumentSnapshot:
                                                            _doccumentSnapshot,
                                                      ))).then(
                                              (value) => setState(
                                                    () {
                                                      getDataReimburse();
                                                    },
                                                  ));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewDetailReimbursePageDriver(
                                                        reimburseModel:
                                                            resReimburse,
                                                        attachmentModel:
                                                            resultAttachments,
                                                        user: _currentUser,
                                                        doccumentSnapshot:
                                                            _doccumentSnapshot,
                                                      ))).then(
                                              (value) => setState(
                                                    () {
                                                      getDataReimburse();
                                                    },
                                                  ));
                                        }
                                      },
                                      icon: const Icon(Icons.remove_red_eye))),
                                ]),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: addButton(),
    );
  }

  Widget? addButton() {
    if (_doccumentSnapshot.get('rool') == "Driver" ||
        _doccumentSnapshot.get('rool') == "Administrator") {
      return Visibility(
          child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Reimburse(
                        user: _currentUser,
                        doccumentSnapshot: _doccumentSnapshot,
                      ))).then((value) => setState(
                () {
                  getDataReimburse();
                },
              ));
        },
        child: const Icon(Icons.playlist_add_rounded),
      ));
    } else {
      return Visibility(
          visible: false,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Reimburse(
                            user: _currentUser,
                            doccumentSnapshot: _doccumentSnapshot,
                          ))).then((value) => setState(
                    () {
                      getDataReimburse();
                    },
                  ));
            },
            child: const Icon(Icons.playlist_add_rounded),
          ));
    }
  }
}
