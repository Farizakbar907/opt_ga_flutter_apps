import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:opt_ga_flutter_apps/models/car.dart';
import '../../../../services/CarOperations.dart';
import 'ListCar.dart';

class AddCarPage extends StatefulWidget {
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  const AddCarPage({this.user, this.doccumentSnapshot});

  @override
  // ignore: library_private_types_in_public_api
  _AddCarPagePageState createState() => _AddCarPagePageState();
}

class _AddCarPagePageState extends State<AddCarPage> {
  // Get Current User Login from Firebase
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic getName;
  dynamic email;
  CarOperations carOperations = CarOperations();
  String? createdBy;
  int isDeleted = 0;

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
      getName = _doccumentSnapshot.get('name');
      createdBy = getName;
      email = _doccumentSnapshot.get('email');
      super.initState();
    }
  }

  final _nameController = TextEditingController();
  final _policeNoController = TextEditingController();
  bool _validateName = false;
  bool _validatePoliceNo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Car'),
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
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Car',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
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
              TextField(
                  controller: _policeNoController,
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
                      onPressed: () {
                        setState(() {
                          _nameController.text.isEmpty
                              ? _validateName = true
                              : _validateName = false;
                          _policeNoController.text.isEmpty
                              ? _validatePoliceNo = true
                              : _validatePoliceNo = false;
                        });
                        if (_validateName == false &&
                            _validatePoliceNo == false) {
                          print('validasi name: $_validateName');
                          print('validasi Police: $_validatePoliceNo');
                          final Car _car = Car();
                          _car.createdBy = createdBy;
                          _car.name = _nameController.text;
                          _car.police_no = _policeNoController.text;
                          _car.isDeleted = isDeleted;
                          var result = carOperations.createCar(_car);
                          print('result: $result');
                          if (result != null) {
                            setState(() {
                              Navigator.pop(context, result);
                            });
                          }
                        }
                      },
                      child: const Text('Save')),
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
                        _policeNoController.text = '';
                      },
                      child: const Text('Clear'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
