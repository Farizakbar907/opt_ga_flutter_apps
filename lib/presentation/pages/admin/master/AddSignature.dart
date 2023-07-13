import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:opt_ga_flutter_apps/services/SignatureOperations.dart';
import '../../../../models/signature.dart';
import '../../../../screens/admin/administrator.dart';

class Signature extends StatefulWidget {
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  const Signature({super.key, this.user, this.doccumentSnapshot});
  @override
  State<Signature> createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic getName;
  dynamic getNpk;
  dynamic getIdUser;
  late String idUser;
  int? npk;
  late String createdBy;
  late String CreatedAt;

  SignatureOperations signatureOperations = SignatureOperations();

  // Variables For Image
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  List<XFile>? imageFiles;

  // Object for save image file one to one
  Future<File>? imagesFiles;
  Image? image;
  List<SignatureModel>? imgs;
  late String imgString;
  late String fileNameImage;
  late String pathFile;
  late XFile tempImage;
  late CollectionReference _collectionReference;
  late DocumentSnapshot snapshot;
  String? documentId;

  void getDataUser() async {
    //use a Async-await function to get the data
    if (_npkController.text.isNotEmpty || npk != null) {
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
      // get data from docs
      // final allData = querySnapshot.docs.map((e) => e.data()).toList();
    }
  }

  // Retrieve data user
  @override
  void initState() {
    if (_npkController.text.isNotEmpty) {
      npk = int.parse(_npkController.text.toString());
    }
    String datetime = DateFormat("yyyy-MM-dd:hh:mm:ss").format(DateTime.now());
    CreatedAt = datetime;
    _currentUser = widget.user!;
    _doccumentSnapshot = widget.doccumentSnapshot!;
    var resultQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();
    if (_doccumentSnapshot.exists) {
      _doccumentSnapshot.get('name');
      _doccumentSnapshot.get('npk');
      getName = _doccumentSnapshot.get('name');
      createdBy = getName;
    }
    // createdBy = _currentUser.displayName!;
  }

  final _npkController = TextEditingController();
  bool _validateName = false;

  @override
  Widget build(BuildContext context) {
    getDataUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Signature'),
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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                  controller: _npkController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Npk',
                    labelText: 'Npk',
                    errorText: _validateName ? 'Npk Can\'t Be Empty' : null,
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
              ElevatedButton(
                  onPressed: () {
                    initState();
                    getDataUser();
                    imgs?.forEach((val) {
                      final List<SignatureModel> _signature = [];
                      final SignatureModel signature = SignatureModel();
                      signature.idUser = idUser;
                      signature.npk = npk;
                      signature.signatureFile = val.signatureFile;
                      signature.locSignature = val.locSignature;
                      signature.createdBy = createdBy;
                      signature.createdAt = CreatedAt;
                      _signature.add(signature);
                      signatureOperations.createSign(signature);
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
                  },
                  child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }

  // Get From Gallery
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
              // idUser: idUser,
              // username: username,
              signatureFile: fileNameImage,
              locSignature: pathFile,
              createdAt: CreatedAt);
          imgs?.add(signs);
        });
      });
    }
  }
}
