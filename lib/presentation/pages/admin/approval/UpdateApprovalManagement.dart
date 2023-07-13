import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:opt_ga_flutter_apps/models/car.dart';
import 'package:opt_ga_flutter_apps/models/signature.dart';
import 'package:uuid/uuid.dart';
import '../../../../helper-layouts/custom_dropdown.dart';
import '../../../../models/Approve.dart';
import '../../../../models/Attachment.dart';
import '../../../../models/Reimburse.dart';
import '../../../../services/ApproveOperations.dart';
import '../../../../services/CarOperations.dart';
import '../../../../services/ReimburseOperations.dart';
import '../../../../services/SignatureOperations.dart';
import '../transaction/ListReimburse.dart';

class ViewDetailReimbursePage extends StatefulWidget {
  ReimburseModel? reimburseModel;
  List<Attachment>? attachmentModel = [];
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  ViewDetailReimbursePage(
      {this.user,
      this.doccumentSnapshot,
      this.reimburseModel,
      this.attachmentModel});

  @override
  // ignore: library_private_types_in_public_api
  _ViewDetailReimbursePageState createState() =>
      _ViewDetailReimbursePageState();
}

class _ViewDetailReimbursePageState extends State<ViewDetailReimbursePage> {
  int _activeStepIndex = 0;

  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic getName;
  dynamic email;
  ApproveOperations approveOperations = ApproveOperations();
  ReimburseOperations reimburseOperations = ReimburseOperations();
  String? approvedBy;
  String? approvedAt;
  String? createdAtParse;
  String? username;
  CarOperations carOperations = CarOperations();
  SignatureOperations signatureOperations = SignatureOperations();
  Car tempCars = Car();
  ReimburseModel tempReimburse = ReimburseModel();
  List<Attachment> tempAttachment = [];
  List<SignatureModel> listSign = [];

  // Inputan text
  String id = Uuid().v4();
  TextEditingController divisi = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController npk = TextEditingController();
  late int npkParse;
  TextEditingController police_no = TextEditingController();
  TextEditingController createdAt = TextEditingController();
  TextEditingController exp_toll = TextEditingController();
  TextEditingController exp_parking = TextEditingController();
  TextEditingController others = TextEditingController();
  TextEditingController qty_gas = TextEditingController();
  TextEditingController qty_toll = TextEditingController();
  TextEditingController qty_park = TextEditingController();
  TextEditingController qty_others = TextEditingController();
  TextEditingController amount_gas = TextEditingController();
  late double amountGas;
  late double amountToll;
  late double amountPark;
  late double amountOthers;
  late double totals;
  late String status;
  late String idUser;
  int? idSignature;
  String? exp_gas;
  int? qtyGas;
  int? qtyToll;
  int? qtyPark;
  int? qtyOthers;
  TextEditingController amount_toll = TextEditingController();
  TextEditingController amount_park = TextEditingController();
  TextEditingController amount_others = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController images = TextEditingController();
  TextEditingController total = TextEditingController();

  // For Dropdownlist Police No
  Car? _selectedPoliceNo;
  late String testAmount;

  // For Dropdownlist Gasoline
  String dropdownValue = 'Solar';
  var items = [
    'Solar',
    'Premium',
    'Pertalite',
    'Pertamax',
  ];

  late ControlsDetails details;

  // Callback DDL Police No
  callback(selectedPoliceNo) {
    setState(() {
      _selectedPoliceNo = selectedPoliceNo;
      print(_selectedPoliceNo?.police_no);
    });
  }

  File? imageFile;
  final ImagePicker picker = ImagePicker();
  List<XFile>? imageFiles;

  // Object for save image file one to one
  Future<File>? imagesFiles;
  Image? image;
  List<Attachment>? imgs;
  late String imgString;
  late String fileNameImage;
  late String pathFile;
  late XFile tempImage;

  @override
  void initState() {
    setState(() {});
    _currentUser = widget.user!;
    _doccumentSnapshot = widget.doccumentSnapshot!;
    createdAtParse = widget.reimburseModel!.createdAt;
    username = widget.reimburseModel!.createdBy;
    npkParse = widget.reimburseModel!.npk!;
    String datetime = DateFormat("yyyy-MM-dd:hh:mm:ss").format(DateTime.now());
    approvedAt = datetime;
    createdAt.text = createdAtParse!;
    name.text = username!;
    divisi.text = widget.reimburseModel!.divisi!;
    npk.text = npkParse.toString();
    exp_gas = widget.reimburseModel!.expGas;
    qty_gas.text = widget.reimburseModel!.qtyGas.toString();
    amount_gas.text = widget.reimburseModel!.amountGas.toString();
    exp_toll.text = widget.reimburseModel!.exp_toll!;
    qty_toll.text = widget.reimburseModel!.qtyToll.toString();
    amount_toll.text = widget.reimburseModel!.amountToll.toString();
    exp_parking.text = widget.reimburseModel!.exp_parking!;
    qty_park.text = widget.reimburseModel!.qtyPark.toString();
    amount_park.text = widget.reimburseModel!.amountPark.toString();
    others.text = widget.reimburseModel!.others!;
    qty_others.text = widget.reimburseModel!.qtyOthers.toString();
    amount_others.text = widget.reimburseModel!.amountOthers.toString();
    total.text = widget.reimburseModel!.totals.toString();
    notes.text = widget.reimburseModel!.notes!;
    // ignore: unused_local_variable
    var resultQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();
    if (_doccumentSnapshot.exists) {
      _doccumentSnapshot.get('name');
      _doccumentSnapshot.get('npk');
      getName = _doccumentSnapshot.get('name');
      approvedBy = getName;
      email = _doccumentSnapshot.get('email');
      super.initState();
    }
  }

  void updateStatus() async {
    // setState(() {});
    if (_doccumentSnapshot.get('rool') == 'Verificator') {
      status = 'Waiting Approve Management';
      widget.reimburseModel!.status = status;
      widget.reimburseModel!.notes = notes.text;
      if (listSign.isEmpty) {
        listSign = await signatureOperations.getAllSignature();
      }
      var idUserLogin = _currentUser.uid;
      listSign.forEach((element) {
        SignatureModel signTemp = SignatureModel();
        if (element.idUser == idUserLogin) {
          idSignature = element.id!;
        }
        // else {
        //   print('signature tidak ditemukan');
        // }
      });
    } else if (_doccumentSnapshot.get('rool') == 'Management') {
      status = 'Fully Approved';
      widget.reimburseModel!.status = status;
      widget.reimburseModel!.notes = notes.text;
      if (listSign.isEmpty) {
        listSign = await signatureOperations.getAllSignature();
      }
      var idUserLogin = _currentUser.uid;
      listSign.forEach((element) {
        SignatureModel signTemp = SignatureModel();
        if (element.idUser == idUserLogin) {
          idSignature = element.id!;
        }
      });
    }
  }

  List<Step> stepList() => [
        // Step 1 Information User
        Step(
          state: _activeStepIndex > 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Information User'),
          // ignore: avoid_unnecessary_containers
          content: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 6,
                ),
                TextField(
                  readOnly: true,
                  controller: createdAt,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date',
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  readOnly: true,
                  controller: name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  readOnly: true,
                  controller: npk,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Npk',
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
        // Step 2 Information Details
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text('Information Details'),
            // ignore: avoid_unnecessary_containers
            content: Container(
              child: Column(
                children: <Widget>[
                  FutureBuilder<List<Car>>(
                    future: carOperations.getAllCars(tempCars),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? PoliceNoDropDown(snapshot.data, callback)
                          : const Text('Nothing Police No');
                    },
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  TextField(
                    readOnly: true,
                    controller: divisi,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Divisi',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const Text("List Files:"),
                  const Divider(),
                          widget.attachmentModel!.isNotEmpty
                      ? Wrap(
                          children: widget.attachmentModel!.map((imageone) {
                            // return Utility.imageFromBase64String(imageone.fileName!);
                            return Container(
                                child: Card(
                              child: Container(
                                height: 160,
                                width: 100,
                                child: Image.file(File(imageone.location!)),
                              ),
                            ));
                          }).toList(),
                        )
                      : Container(),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            )),
        // Step 3 Expense
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text('Expense'),
            content: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                          hint: const Text('Gasoline'),
                          value: exp_gas,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              exp_gas = newValue;
                              dropdownValue = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: qty_gas,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Qty',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: amount_gas,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Amount',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: exp_toll,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Toll',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: qty_toll,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Qty',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: amount_toll,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Amount',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: exp_parking,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Parking',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: qty_park,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Qty',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: amount_park,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Amount',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: others,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Others',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: qty_others,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Qty',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: amount_others,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Amount',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            )),
        // Step 4 Total
        Step(
            state:
                _activeStepIndex <= 3 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 3,
            title: const Text('Total'),
            content: Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  TextField(
                    readOnly: true,
                    controller: total,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Total',
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  TextField(
                    readOnly: false,
                    controller: notes,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Notes',
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                ],
              ),
            )),
        // Step 5 Confirm
        Step(
            state: StepState.complete,
            isActive: _activeStepIndex >= 4,
            title: const Text('Confirm'),
            content: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            )))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Detail Reimburse'),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListReimburse(
                          user: _currentUser,
                          doccumentSnapshot: _doccumentSnapshot,
                        )));
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Stepper(
        type: StepperType.vertical,
        steps: stepList(),
        currentStep: _activeStepIndex,
        onStepContinue: () {
          // ignore: unused_local_variable
          final isLastStep = _activeStepIndex == stepList().length - 1;
          if (_activeStepIndex < (stepList().length - 1)) {
            setState(() {
              _activeStepIndex += 1;
            });
          } else {
            print('Submited');
          }
        },
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }

          setState(() {
            _activeStepIndex -= 1;
          });
        },
        onStepTapped: (int index) {
          setState(() {
            _activeStepIndex = index;
          });
        },
        controlsBuilder: (context, details) {
          final isLastStep = _activeStepIndex == stepList().length - 1;
          // ignore: avoid_unnecessary_containers
          return Container(
            child: Row(
              children: <Widget>[
                Expanded(child: showHideButtonApprove(context, details)),
                const SizedBox(
                  width: 10,
                ),
                if (_activeStepIndex > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget showHideButtonApprove(BuildContext context, ControlsDetails details) {
    final isLastStep = _activeStepIndex == stepList().length - 1;
    if (isLastStep == true) {
      return Visibility(
          child: ElevatedButton(
              onPressed: () async{
                updateStatus();
                reimburseOperations.updateReimburse(widget.reimburseModel!);
                if (listSign.isEmpty) {
                  listSign = await signatureOperations.getAllSignature();
                  final approved = Approve(
                      idReimburse: widget.reimburseModel!.id,
                      idSignature: idSignature,
                      status: status,
                      approveBy: approvedBy,
                      approveAt: approvedAt);
                  approveOperations.createApprove(approved);
                  if (approved != null && approved.idSignature == idSignature) {
                    Navigator.pop(context);
                  }
                  // else {
                  //   print('Signature tidak ditemukan');
                  // }
                }
              },
              child: const Text('Approve')));
    } else {
      return Visibility(
          child: ElevatedButton(
              onPressed: details.onStepContinue, child: const Text('Next')));
    }
  }
}
