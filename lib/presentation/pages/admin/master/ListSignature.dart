import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:opt_ga_flutter_apps/services/SignatureOperations.dart';
import '../../../../models/signature.dart';
import '../../../../screens/admin/administrator.dart';
import 'AddSignature.dart';
import 'EditSignature.dart';


class ListSignature extends StatefulWidget {
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  const ListSignature({this.user, this.doccumentSnapshot});

  @override
  State<ListSignature> createState() => _ListSignatureState();
}

class _ListSignatureState extends State<ListSignature> {
  final scrollController = ScrollController();
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic name;
  dynamic email;
  dynamic rool;
  late SignatureModel resSignatureEdit = SignatureModel();
  SignatureOperations signatureOperations = SignatureOperations();
  SignatureModel tempSignature = SignatureModel();
  late List<SignatureModel> _listSignature = [];

  getAllSignature() async {
    _listSignature = await signatureOperations.getAllSignature();
  }

  @override
  void initState() {
    _currentUser = widget.user!;
    _doccumentSnapshot = widget.doccumentSnapshot!;
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
      getAllSignature();
    });
  }

  void insertDataTemp(SignatureModel tempSignature) {
    resSignatureEdit = tempSignature;
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, SignatureModel resSignatureEdit) {
    insertDataTemp(resSignatureEdit);
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    resSignatureEdit;
                    int isDeleted = 1;
                    var _signature = SignatureModel();
                    _signature.createdBy = resSignatureEdit.createdAt;
                    _signature.createdBy = resSignatureEdit.createdBy;
                    _signature.id = resSignatureEdit.id;
                    _signature.idUser = resSignatureEdit.idUser;
                    _signature.locSignature = resSignatureEdit.locSignature;
                    _signature.npk = resSignatureEdit.npk;
                    _signature.signatureFile = resSignatureEdit.signatureFile;
                    _signature.updatedAt = resSignatureEdit.updatedAt;
                    _signature.updatedBy = resSignatureEdit.updatedBy;
                    var result =
                        await signatureOperations.deleteSign(_signature);
                    if (_signature != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      setState(() {
                        getAllSignature();
                        _showSuccessSnackBar('Signature Deleted Success');
                      });
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page Signature"),
        centerTitle: true,
        backgroundColor: Colors.black,
         leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Administrator(
                          user: _currentUser,
                          doccumentSnapshot: _doccumentSnapshot,
                        )));
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
                future: getAllSignature(),
                builder: (context, snapshot) {
                  getAllSignature();
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
                                'Id',
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Nama File',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Npk',
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
                          rows: _listSignature
                              .map(
                                (e) => DataRow(cells: [
                                  DataCell(
                                    Text(e.id.toString()),
                                  ),
                                  DataCell(
                                    Text(e.signatureFile.toString()),
                                  ),
                                  DataCell(
                                    Text(e.npk.toString()),
                                  ),                                 
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          initState();
                                          insertDataTemp(e);
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditSignaturePage(
                                                            signatureModel: resSignatureEdit,
                                                            user: _currentUser,
                                                            doccumentSnapshot:
                                                                _doccumentSnapshot,
                                                          )))
                                              .then((value) => setState(
                                                    () {
                                                      getAllSignature();
                                                    },
                                                  ));
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          initState();
                                          insertDataTemp(e);
                                          _deleteFormDialog(
                                              context, resSignatureEdit);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                    // icon: const Icon(Icons.edit)
                                  )),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Signature(
                        user: _currentUser,
                        doccumentSnapshot: _doccumentSnapshot,
                      ))).then((value) => setState(
                () {
                  getAllSignature();
                },
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
