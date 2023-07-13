// ignore_for_file: unnecessary_new
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opt_ga_flutter_apps/models/Attachment.dart';
import 'package:opt_ga_flutter_apps/models/car.dart';
import 'package:opt_ga_flutter_apps/models/Reimburse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../../../constants.dart';
import '../../../../helper-layouts/custom_dropdown.dart';
import '../../../../services/AttachmentOperations.dart';
import '../../../../services/CarOperations.dart';
import '../../../../services/ReimburseOperations.dart';
import 'ListReimburse.dart';

class Reimburse extends StatefulWidget {
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  const Reimburse({super.key, this.user, this.doccumentSnapshot});
  @override
  State<Reimburse> createState() => _ReimburseState();
}

late String routeToGo = '/';
String? payload;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

class _ReimburseState extends State<Reimburse> {
  int _counter = 0;
  late String _textToken =
      'eVvYpBLkQvijNfRrJu5PpH:APA91bG2Gjsm8NhInBMQI5kYat_eNQY2Uq4VQzwaUfb6cg6jlEUfm08Rigm80W41XQMw66rrOk-aiKzfQEgd746HAF643tz7b1jdbkBSd7f7M8jl-Kq-8_guM5QYumP0d5tgGFKxzuKl';
  late String _textTitle = 'Test FCM';
  late String body = 'This message testing notification';
  // Object & get Data User from Firebase
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic getName;
  dynamic getNpk;
  dynamic getIdUser;
  String? mtoken = " ";

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
  String? exp_gas;
  int? qtyGas;
  int? qtyToll;
  int? qtyPark;
  int? qtyOthers;
  String? no_approval;
  TextEditingController amount_toll = TextEditingController();
  TextEditingController amount_park = TextEditingController();
  TextEditingController amount_others = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController images = TextEditingController();
  TextEditingController total = TextEditingController();
  int isDeleted = 0;

  // For Dropdownlist Police No
  CarOperations carOperations = CarOperations();
  ReimburseOperations reimburseOperations = ReimburseOperations();
  AttachmentOperations attachmentOperations = AttachmentOperations();
  Car tempCars = Car();
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

  // Callback DDL Police No
  callback(selectedPoliceNo) {
    setState(() {
      _selectedPoliceNo = selectedPoliceNo;
      print(_selectedPoliceNo?.police_no);
    });
  }

  static const bool _validateDivisi = false;
  int _activeStepIndex = 0;

  // Variables For Image
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
  bool _isbuttonDisabled = false;

  // Retrieve data user from firebase
  @override
  void initState() {
    _textToken;
    _textTitle;
    body;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
    _isbuttonDisabled = false;
    imgs = [];
    String datetime = DateFormat("yyyy-MM-dd:hh:mm:ss").format(DateTime.now());
    createdAt.text = datetime;
    exp_toll.text = 'Toll';
    exp_parking.text = 'Parking';
    status = 'Waiting Approve Verificator';
    no_approval = 'RBM' + "001";
    exp_gas = dropdownValue;
    _currentUser = widget.user!;
    _doccumentSnapshot = widget.doccumentSnapshot!;
    // ignore: unused_local_variable
    Future<DocumentSnapshot<Map<String, dynamic>>> resultQuery =
        FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser.uid)
            .get();
    if (_doccumentSnapshot.exists) {
      _doccumentSnapshot.get('name');
      _doccumentSnapshot.get('npk');
      getName = _doccumentSnapshot.get('name');
      name.text = getName;
      getNpk = _doccumentSnapshot.get('npk');
      npk.text = getNpk;
      idUser = _doccumentSnapshot.get('uid');
      super.initState();
    }
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doing ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  getData() {
    // setState(() {
    id = Uuid().v4();
    npkParse = int.parse(npk.text.toString());
    if (qty_gas.text.isNotEmpty) {
      qtyGas = int.parse(qty_gas.text.toString());
    } else if (qty_gas.text.isEmpty) {
      qtyGas = 0;
    }
    if (qty_toll.text.isNotEmpty) {
      qtyToll = int.parse(qty_toll.text.toString());
    } else if (qty_toll.text.isEmpty) {
      qtyToll = 0;
    }
    if (qty_park.text.isNotEmpty) {
      qtyPark = int.parse(qty_park.text.toString());
    } else if (qty_park.text.isEmpty) {
      qtyPark = 0;
    }
    if (qty_others.text.isNotEmpty) {
      qtyOthers = int.parse(qty_others.text.toString());
    } else if (qty_others.text.isEmpty) {
      qtyOthers = 0;
    }
    if (amount_gas.text.isNotEmpty) {
      amountGas = double.parse(amount_gas.text.toString());
    } else if (amount_gas.text.isEmpty) {
      amountGas = 0;
    }
    if (amount_toll.text.isNotEmpty) {
      amountToll = double.parse(amount_toll.text.toString());
    } else if (amount_toll.text.isEmpty) {
      amountToll = 0;
    }
    if (amount_park.text.isNotEmpty) {
      amountPark = double.parse(amount_park.text.toString());
    } else if (amount_park.text.isEmpty) {
      amountPark = 0;
    }
    if (amount_others.text.isNotEmpty) {
      amountOthers = double.parse(amount_others.text.toString());
    } else if (amount_others.text.isEmpty) {
      amountOthers = 0;
    }
    totals = amountGas + amountToll + amountPark + amountOthers;

    testAmount = totals.toString();
    total.text = testAmount;
    // });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Form Input Step List
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
                    labelText: 'NPK',
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
                    width: 50,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Division cannot blank';
                      }
                      return null;
                    },
                    controller: divisi,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Div/Dept',
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getFromGallery();
                    },
                    child: const Text('Pick From Gallery'),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _getFromCamera();
                  //   },
                  //   child: const Text('Pick From Camera'),
                  // ),
                  const Divider(),
                  const Text("Picked Files:"),
                  const Divider(),
                  imageFiles != null
                      ? Wrap(
                          children: imageFiles!.map((imageone) {
                            // return Utility.imageFromBase64String(imageone.fileName!);
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
                          value: dropdownValue,
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          enabled: false,
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          enabled: false,
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Others',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: qty_others,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          controller: amount_others,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Total',
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  TextField(
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
              // children: [
              //   Text('Date: ${createdAt.text}'),
              //   Text('Name: ${name.text}'),
              //   Text('NPK: ${npk.text}'),
              //   Text('Police No: ${police_no.text}'),
              //   Text('Divisi: ${divisi.text}'),
              //   Text('Images: ${images.text}'),
              //   // Text('Gasoline: ${exp_gasoline}'),
              //   Text('Exp Toll: ${exp_toll.text}'),
              //   Text('Exp Parking: ${exp_parking.text}'),
              //   Text('Others: ${others.text}'),

              //   // Text(
              //   //     'TotalCal: ${amount_gas.text + amount_toll.text + amount_park.text + amount_others.text}'),

              //   Text('Amount Gas: ${amount_gas.text}'),
              //   Text('Amount Toll: ${amount_toll.text}'),
              //   Text('Amount Park: ${amount_park.text}'),
              //   Text('Amount Others: ${amount_others.text}'),

              //   Text('Qty Gas: ${qty_gas.text}'),
              //   Text('Qty Toll: ${qty_toll.text}'),
              //   Text('Qty Park: ${qty_park.text}'),
              //   Text('Qty Others: ${qty_others.text}'),

              //   Text('Address : ${divisi.text}'),
              //   Text('PinCode : ${police_no.text}'),
              // ],
            )))
      ];

  // Get From Gallery
  _getFromGallery() async {
    imgs = [];
    var pickedFiles = await picker.pickMultiImage();
    imageFiles = pickedFiles;
    // .then((imageFiles) async {
    if (imageFiles != null) {
      setState(() {
        imageFiles?.forEach((element) {
          // imgString = Utility.base64String(await element.readAsBytes());
          fileNameImage = element.name;
          pathFile = element.path;
          final attachmentss = Attachment(
              fileName: fileNameImage,
              location: pathFile,
              createdBy: name.text);
          imgs?.add(attachmentss);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Reimburse'),
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
          // if (isLastStep) {
          //   print('Completed');
          // }
          // setState(() => _activeStepIndex += 1);
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

        // onStepCancel: _activeStepIndex == 0
        //     ? null
        //     : () => setState(() => _activeStepIndex -= 1),

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
                Expanded(child: approveAndNextButton(context, details)),
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

  Widget approveAndNextButton(BuildContext context, ControlsDetails details) {
    Future<bool> pushNotif({
      required String token,
      required String title,
      required String body,
    }) async {
      String dataNotifications = '{ "to" : "$token",'
          ' "notification" : {'
          ' "title":"$title",'
          '"body":"$body"'
          ' }'
          ' }';
      await http.post(
        Uri.parse(Constants.BASE_URL),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key= ${Constants.KEY_SERVER}',
        },
        body: dataNotifications,
      );
      return true;
    }

    final isLastStep = _activeStepIndex == stepList().length - 1;
    if (isLastStep == true &&
        _selectedPoliceNo?.id != null &&
        divisi.text.isNotEmpty &&
        imgs!.isNotEmpty) {
      return new ElevatedButton(
          onPressed: _isbuttonDisabled
              ? null
              : () {
                  getData();
                  final reimburse = ReimburseModel(
                    id: id,
                    no_approval: no_approval,
                    createdAt: createdAt.text,
                    username: name.text,
                    npk: npkParse,
                    policeNo: _selectedPoliceNo!.id,
                    divisi: divisi.text,
                    expGas: dropdownValue,
                    exp_parking: exp_parking.text,
                    exp_toll: exp_toll.text,
                    qtyGas: qtyGas,
                    qtyToll: qtyToll,
                    qtyPark: qtyPark,
                    qtyOthers: qtyOthers,
                    amountGas: amountGas,
                    amountToll: amountToll,
                    amountPark: amountPark,
                    amountOthers: amountOthers,
                    totals: totals,
                    others: others.text,
                    notes: notes.text,
                    status: status,
                    idUser: idUser,
                    createdBy: name.text,
                    isDeleted: isDeleted,
                  );
                  reimburseOperations.createReimburse(reimburse);
                  imgs?.forEach((val) {
                    final List<Attachment> _attachment = [];
                    final Attachment attachment = Attachment();
                    attachment.fileName = val.fileName;
                    attachment.location = val.location;
                    attachment.idReimburse = reimburse.id;
                    attachment.createdBy = name.text;
                    _attachment.add(attachment);
                    attachmentOperations.createAttachment(_attachment);
                  });
                  if (reimburse != null) {
                    pushNotif(token: _textToken, title: _textTitle, body: body);
                    Navigator.pop(context);
                  }
                },
          child: Text(_isbuttonDisabled ? "Hold on" : 'Submit'));
    } else if (isLastStep == true &&
        _selectedPoliceNo?.id == null &&
        divisi.text.isEmpty &&
        imgs!.isEmpty) {
      return new ElevatedButton(
        onPressed: _isbuttonDisabled ? null : getData(),
        child: new Text(_isbuttonDisabled ? "Hold on" : "Submit"),
      );
    } else if (isLastStep == false) {
      return Visibility(
          child: ElevatedButton(
        onPressed: details.onStepContinue,
        child: const Text("Next"),
      ));
    }
    return Container();
  }

  bool check() {
    if (_textTitle.isNotEmpty && body.isNotEmpty) {
      return true;
    }
    return false;
  }
}
