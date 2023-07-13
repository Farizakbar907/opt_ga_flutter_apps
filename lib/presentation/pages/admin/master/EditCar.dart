import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opt_ga_flutter_apps/models/car.dart';
import 'package:opt_ga_flutter_apps/presentation/pages/admin/master/ListCar.dart';
import '../../../../services/CarOperations.dart';

class EditContactPage extends StatefulWidget {
  Car? car;
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  EditContactPage({this.user, this.doccumentSnapshot, this.car});

  @override
  // ignore: library_private_types_in_public_api
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic getName;
  dynamic email;
  CarOperations carOperations = CarOperations();
  String? updatedBy;
  String? updatedAt;
  late int isDeleted;

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  // ignore: unused_field
  late bool _validateName = false;
  // ignore: unused_field
  bool _validatePoliceNo = false;

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
      email = _doccumentSnapshot.get('email');
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.car!.name!;
    _surnameController.text = widget.car!.police_no!;
    isDeleted = widget.car!.isDeleted!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Page Car'),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListCar(
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Car Name',
                    labelText: 'Name',
                    errorText:
                        _validateName ? 'Name Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: TextField(
              //     controller: _nameController,
              //     decoration: const InputDecoration(
              //         border: OutlineInputBorder(), labelText: 'Name'),
              //   ),
              // ),
              TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Police No',
                    labelText: 'Police No',
                    errorText: _validatePoliceNo
                        ? 'Police No Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
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
                          _nameController.text.isEmpty
                              ? _validateName = true
                              : _validateName = false;
                          _surnameController.text.isEmpty
                              ? _validatePoliceNo = true
                              : _validatePoliceNo = false;
                        });
                        if (_validateName == false &&
                            _validatePoliceNo == false) {
                          var _car = Car();
                          // _car.id = widget.contact?.id;
                          widget.car?.name = _nameController.text;
                          widget.car?.police_no = _surnameController.text;
                          widget.car?.updatedBy = updatedBy;
                          widget.car?.updatedAt = updatedAt;
                          widget.car?.isDeleted = isDeleted;
                          var result =
                              await carOperations.updateCar(widget.car!);
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
                        _nameController.text = '';
                        _surnameController.text = '';
                      },
                      child: const Text('Clear'))
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: TextField(
              //     controller: _surnameController,
              //     decoration: const InputDecoration(
              //         border: OutlineInputBorder(), labelText: 'Surname'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.edit),
      //   onPressed: () {
      //     widget.contact?.name = _nameController.text;
      //     widget.contact?.police_no = _surnameController.text;
      //     widget.contact?.updatedBy = updatedBy;
      //     widget.contact?.updatedAt = updatedAt;

      //     carOperations.updateCar(widget.contact!);
      //   },
      // ),
    );
  }
}
