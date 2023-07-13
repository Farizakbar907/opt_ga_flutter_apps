import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:opt_ga_flutter_apps/models/car.dart';
import 'package:opt_ga_flutter_apps/screens/admin/administrator.dart';
import '../../../../services/CarOperations.dart';
import 'AddCar.dart';
import 'EditCar.dart';

class ListCar extends StatefulWidget {
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  const ListCar({this.user, this.doccumentSnapshot});

  @override
  State<ListCar> createState() => _ListCarState();
}

class _ListCarState extends State<ListCar> {
  List<DataRow> _rowsPerPage = [];
  final scrollController = ScrollController();
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic name;
  dynamic email;
  dynamic rool;
  late Car resCarEdit = Car();
  CarOperations carOperations = CarOperations();
  Car tempCars = Car();
  late List<Car> _listCar = [];
  late List<Car> dataList = [];
  // BuildContext context;
  User? usr;

  int? index;

  getAllCarsDetails() async {
    _listCar = await carOperations.getAllCars(tempCars);
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
      getAllCarsDetails();
    });
  }

  void insertDataTemp(Car tempCar) {
    resCarEdit = tempCar;
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, Car resCarEdit) {
    insertDataTemp(resCarEdit);
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
                    resCarEdit;
                    int isDeleted = 1;
                    var _car = Car();
                    _car.createdBy = resCarEdit.createdBy;
                    _car.id = resCarEdit.id;
                    _car.name = resCarEdit.name;
                    _car.police_no = resCarEdit.police_no;
                    _car.updatedBy = resCarEdit.updatedBy;
                    _car.updatedAt = resCarEdit.updatedAt;
                    _car.isDeleted = isDeleted;
                    var result = await carOperations.deleteCar(_car);
                    if (_car != null) {
                      Navigator.pop(context);
                      setState(() {
                        getAllCarsDetails();
                        _showSuccessSnackBar('Car Deleted Success');
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
    return MaterialApp(
      title: "Page Car",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Page Car"),
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
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FutureBuilder(
                    future: getAllCarsDetails(),
                    builder: (context, snapshot) {
                      getAllCarsDetails();
                      return InteractiveViewer(
                          scaleEnabled: false,
                          child: Scrollbar(
                            controller: scrollController,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              // scrollDirection: Axis.vertical,
                              child: PaginatedDataTable(
                                source: dataSource(MyData(
                                    dataList: _listCar,
                                    context: context,
                                    usr: _currentUser,
                                    resCarEdit: resCarEdit,
                                    abc: getAllCarsDetails(),
                                    docSnapshot: _doccumentSnapshot,
                                    widget: showHideButtonApprove(context),
                                    index: index)),
                                rowsPerPage: 5,
                                columnSpacing:
                                    (MediaQuery.of(context).size.width / 10) *
                                        0.67,
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
                                      'Car Name',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Police No',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Prepared By',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Action',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                ],
                                // ),
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
          // height: 20,
          // child: Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // children: <Widget>[
          // child: Expanded(
          // ),
          // children: [
          // child: FutureBuilder(
          //   future: getAllCarsDetails(),
          //     builder: (context, snapshot) {
          //       getAllCarsDetails();
          //   // child: ListView.builder(
          //     // itemCount: _listCar.length,
          //     // shrinkWrap: true,
          //       getAllCarsDetails();
          // // return InteractiveViewer(
          // //   scaleEnabled: false,
          // //   child: Scrollbar(
          // //   controller: scrollController,
          // //   child: SingleChildScrollView(
          //   controller: scrollController,
          //   scrollDirection: Axis.horizontal,
          // child: PaginatedDataTable(
          //   source: dataSource(MyData(dataList: _listCar)),
          //   rowsPerPage: 2,
          //   columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.67,
          //   dataRowHeight: 55,
          //   columns: const [
          //     DataColumn(
          //       label: Text(
          //         'Id',
          //         style: TextStyle(
          //           fontStyle: FontStyle.normal,
          //         ),
          //       ),
          //     ),
          //     DataColumn(
          //       label: Text(
          //         'Car Name',
          //         style: TextStyle(fontStyle: FontStyle.normal),
          //       ),
          //     ),
          //     DataColumn(
          //       label: Text(
          //         'Police No',
          //         style: TextStyle(fontStyle: FontStyle.normal),
          //       ),
          //     ),
          //     DataColumn(
          //       label: Text(
          //         'Prepared By',
          //         style: TextStyle(fontStyle: FontStyle.normal),
          //       ),
          //     ),
          //     DataColumn(
          //       label: Text(
          //         'Action',
          //         style: TextStyle(fontStyle: FontStyle.normal),
          //       ),
          //     ),
          //   ],
          // rows: _listCar
          //     .map(
          //       (e) => DataRow(cells: [
          //         DataCell(
          //           Text(e.id.toString()),
          //         ),
          //         DataCell(
          //           Text(e.name.toString()),
          //         ),
          //         DataCell(
          //           Text(e.police_no.toString()),
          //         ),
          //         DataCell(
          //           Text(e.createdBy.toString()),
          //         ),
          //         DataCell(Row(
          //           children: [
          //             IconButton(
          //               onPressed: () {
          //                 initState();
          //                 insertDataTemp(e);
          //                 Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                             builder: (context) =>
          //                                 EditContactPage(
          //                                   car: resCarEdit,
          //                                   user: _currentUser,
          //                                   doccumentSnapshot:
          //                                       _doccumentSnapshot,
          //                                 )))
          //                     .then((value) => setState(
          //                           () {
          //                             getAllCarsDetails();
          //                           },
          //                         ));
          //               },
          //               icon: const Icon(Icons.edit),
          //             ),
          //             IconButton(
          //               onPressed: () {
          //                 initState();
          //                 insertDataTemp(e);
          //                 _deleteFormDialog(context, resCarEdit);
          //               },
          //               icon: const Icon(Icons.delete),
          //             ),
          //           ],
          //           // icon: const Icon(Icons.edit)
          //         )),
          //       ]),
          //     )
          //     .toList(),
          // ),
          // ),
          //   ),
          // );
          // },
          // ),
          // ),
          //     ],
          //     // ],
          //   ),
          // ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCarPage(
                          user: _currentUser,
                          doccumentSnapshot: _doccumentSnapshot,
                        ))).then((value) => setState(
                  () {
                    getAllCarsDetails();
                  },
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  IconButton showHideButtonApprove(BuildContext context) {
    return IconButton(
        onPressed: () {
          _currentUser;
          var button;
          dataSource(MyData(
              dataList: dataList,
              context: context,
              usr: _currentUser,
              resCarEdit: resCarEdit,
              abc: getAllCarsDetails(),
              docSnapshot: _doccumentSnapshot,
              widget: button,
              index: index));
          getAllData();
          // _listCar[index].id;
          _listCar.where((element) => element.id == index);
          int? ids = _listCar.first.id;
          if (ids != 0) {
            insertDataTemp(tempCars);
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditContactPage(
                        car: resCarEdit,
                        user: _currentUser,
                        doccumentSnapshot: _doccumentSnapshot,
                      ))).then((value) => setState(
                () {
                  getAllCarsDetails();
                },
              ));
        },
        icon: const Icon(Icons.edit));
  }

  void getAllData() {
    Car tempCarData = Car();
    dynamic getDataCars = getAllCarsDetails();
    var getDataUsers = initState();
    var getDataCarEdit = insertDataTemp(tempCarData);
    dataSource(_ListCarState);
  }

  DataTableSource dataSource(_ListCarState) => MyData(
      dataList: _listCar,
      context: context,
      usr: _currentUser,
      resCarEdit: resCarEdit,
      abc: getAllCarsDetails(),
      docSnapshot: _doccumentSnapshot,
      widget: showHideButtonApprove(context),
      index: index);
}

class MyData extends DataTableSource {
  final List<Car> dataList;
  final BuildContext context;
  final User usr;
  Car resCarEdit = Car();
  var abc;
  var docSnapshot;
  final IconButton widget;
  final int? index;

  MyData(
      {required this.dataList,
      required this.context,
      required this.usr,
      required this.resCarEdit,
      required this.abc,
      required this.docSnapshot,
      required this.widget,
      required this.index});

  editDataTemp(int? ids) async {
    dataList.where((element) => element.id == ids);
    resCarEdit = dataList.where((element) => element.id == ids).first;
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => dataList.length;
  @override
  int get selectedRowCount => 0;
  getDataRow() {
    widget;
    getRow(index!);
  }

  @override
  DataRow? getRow(int index) {
    widget;
    if (index != 0 || index != null) {
      index;
    }
    return DataRow(cells: [
      DataCell(Text(dataList[index].id.toString())),
      DataCell(Text(dataList[index].name.toString())),
      DataCell(Text(dataList[index].police_no.toString())),
      DataCell(Text(dataList[index].createdBy.toString())),
      DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
              widget;
            }, 
            icon: const Icon(Icons.edit),
            ),
          // IconButton(
          //   onPressed: () {
          //     widget;
          //     usr;
          //     dataList[index].id;
          //     int? ids = dataList[index].id;
          //     if (ids != 0) {
          //       editDataTemp(ids);
          //     }
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => EditContactPage(
          //                   car: resCarEdit,
          //                   user: usr,
          //                   doccumentSnapshot: docSnapshot,
          //                 ))).then(
          //       (value) =>
          //           // setState(
          //           () {
          //         abc();
          //       },
          //       // )
          //     );
          //   },
          //   icon: const Icon(Icons.edit),
          // ),
          IconButton(
            onPressed: () {
              // initState();
              // insertDataTemp(e);
              // _deleteFormDialog(context, resCarEdit);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      )),
    ]);
  }
}
