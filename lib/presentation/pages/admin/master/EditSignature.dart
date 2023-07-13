import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:opt_ga_flutter_apps/services/SignatureOperations.dart';

import '../../../../models/signature.dart';
import 'ListSignature.dart';

class EditSignaturePage extends StatefulWidget {
  SignatureModel? signatureModel;
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  EditSignaturePage({this.user, this.doccumentSnapshot, this.signatureModel});

  @override
  // ignore: library_private_types_in_public_api
  _EditSignaturePageState createState() => _EditSignaturePageState();
}

class _EditSignaturePageState extends State<EditSignaturePage> {
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic getName;
  dynamic getNpk;
  SignatureOperations signatureOperations = SignatureOperations();
  List<SignatureModel>? imgs;
  SignatureModel tempSignModel = SignatureModel();
  final ImagePicker picker = ImagePicker();
  List<XFile>? imageFiles;
  late String imgString;
  late String fileNameImage;
  late String pathFile;
  late XFile tempImage;

  String? updatedBy;
  String? updatedAt;
  String? idUser;

  final _npkController = TextEditingController();
  int? npkParse;
  // ignore: unused_field
  late bool _validateNpk = false;
  // QuerySnapshot querySnapshot = QuerySnapshot();

  @override
  void initState() {
    _currentUser = widget.user!;
    _doccumentSnapshot = widget.doccumentSnapshot!;
    String datetime = DateFormat("yyyy-MM-dd:hh:mm:ss").format(DateTime.now());
    updatedAt = datetime;
    // ignore: unused_local_variable
    var resultQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();
    if (_doccumentSnapshot.exists) {
      _doccumentSnapshot.get('name');
      _doccumentSnapshot.get('npk');
      getName = _doccumentSnapshot.get('name');
      updatedBy = getName;
      super.initState();
    }
  }

  void getDataUser() async {
    CollectionReference _collectionReference;
    if (_npkController.text.isNotEmpty) {
      npkParse = int.parse(_npkController.text.toString());
      _collectionReference = FirebaseFirestore.instance.collection('users');
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionReference.get();
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((element) {
          if (element.exists) {
            element.get('npk');
            var getNpk = element.get('npk');
            String npkStr = getNpk;
            if (npkStr == _npkController.text) {
              element.get('uid');
              var getIdUser = element.get('uid');
              idUser = getIdUser;
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _npkController.text = widget.signatureModel!.npk!.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Signature'),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListSignature(
                          user: _currentUser,
                          doccumentSnapshot: _doccumentSnapshot,
                        )));
          },
          child: const Icon(
            Icons.arrow_back, // add custom icons also
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                  controller: _npkController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Npk',
                    labelText: 'Npk',
                    errorText: _validateNpk ? 'Npk Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    _getFromGallery();
                  },
                  child: const Text('Pick From Gallery')),
              const Divider(),
              const Text("Picked Files:"),
              const Divider(),
              imageFiles != null
                  ? Wrap(
                      children: imageFiles!.map((imageone) {
                        return Container(
                            child: Card(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.file(File(imageone.path)),
                          ),
                        ));
                      }).toList(),
                    )
                  : Container(),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          _npkController.text.isEmpty
                              ? _validateNpk = true
                              : _validateNpk = false;
                          if (tempSignModel.locSignature == null &&
                              tempSignModel.signatureFile == null) {                         
                            errorTextConfiguration:
                            'Image Can\'t Be Empty';
                          }
                        });
                        if (_validateNpk == false) {
                          CollectionReference _collectionReference;
                          _collectionReference =
                              FirebaseFirestore.instance.collection('users');
                          getDataUser();
                          var _signature = SignatureModel();
                          QuerySnapshot querySnapshot =
                              await _collectionReference.get();
                          tempSignModel;
                          widget.signatureModel?.npk = npkParse;
                          widget.signatureModel?.locSignature =
                              tempSignModel.locSignature;
                          widget.signatureModel?.signatureFile =
                              tempSignModel.signatureFile;
                          widget.signatureModel?.idUser = idUser;
                          widget.signatureModel?.updatedBy = updatedBy;
                          widget.signatureModel?.updatedAt = updatedAt;
                          var result = await signatureOperations
                              .updateSign(widget.signatureModel!);
                          Navigator.pop(context, result);
                        }
                      },
                      child: const Text('Update')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _npkController.text = '';
                      },
                      child: const Text('Clear'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getFromGallery() async {
    imgs = [];
    var pickedFiles = await picker.pickMultiImage();
    imageFiles = pickedFiles;
    if (imageFiles != null) {
      setState(() {
        imageFiles?.forEach((element) {
          fileNameImage = element.name;
          pathFile = element.path;
          final signs = SignatureModel(
              signatureFile: fileNameImage, locSignature: pathFile);
          // imgs?.add(signs);
          tempSignModel = signs;
        });
      });
    }
  }
}
