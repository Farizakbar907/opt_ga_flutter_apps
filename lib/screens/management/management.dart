// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opt_ga_flutter_apps/models/Reimburse.dart';
import 'package:opt_ga_flutter_apps/screens/auth/login.dart';
import '../../helper-layouts/drawer_item.dart';
import '../../presentation/pages/admin/transaction/ListReimburse.dart';
import '../../services/ReimburseOperations.dart';

class ManagementPage extends StatefulWidget {
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  const ManagementPage({this.user, this.doccumentSnapshot});
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  late User _currentUser;
  late DocumentSnapshot _doccumentSnapshot;
  dynamic name;
  dynamic email;
  ReimburseOperations reimburseOperations = ReimburseOperations();
  List<ReimburseModel> _list = [];
  int? countReimburse;
  ReimburseModel reimburseModel = ReimburseModel();

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
      name = _doccumentSnapshot.get('name');
      email = _doccumentSnapshot.get('email');
      super.initState();
    }
  }

  Widget headerWidget() {
    return Row(
      children: [
        CircleAvatar(
            radius: 35,
            child: ClipOval(
            child: Image.asset('assets/user.png'),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${name}',
                style: const TextStyle(fontSize: 14, color: Colors.white)),
            const SizedBox(
              height: 10,
            ),
            Text('${email}',
                style: const TextStyle(fontSize: 14, color: Colors.white))
          ],
        )
      ],
    );
  }

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);
    CircularProgressIndicator();
    FirebaseAuth.instance.signOut();

    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListReimburse(
                      user: _currentUser,
                      doccumentSnapshot: _doccumentSnapshot,
                    )));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
    }
  }

  getDataReimburse() async {
    _list = await reimburseOperations.getDataManagement(reimburseModel);
    countReimburse = _list.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Management'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: getDataReimburse(),
        builder: (context, snapshot) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(5.0),
              children: [
                makeDashboardItem("Form Reimburse", CupertinoIcons.table,
                    () => onItemPressed(context, index: 0), Colors.teal),
                makeCardItem(
                    "Count Reimburse", countReimburse, Colors.greenAccent),
              ],
            ),
          );
        },
      ),
      drawer: Drawer(
        child: Material(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
            child: Column(
              children: [
                headerWidget(),
                const SizedBox(
                  height: 40,
                ),
                const Divider(
                  thickness: 1,
                  height: 10,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 40,
                ),
                DrawerItem(
                  name: 'Approval List',
                  icon: Icons.document_scanner,
                  onPressed: () => onItemPressed(context, index: 0),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  thickness: 1,
                  height: 10,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 30,
                ),
                DrawerItem(
                    name: 'Log out',
                    icon: Icons.logout,
                    onPressed: () => onItemPressed(context, index: 1)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  makeDashboardItem(String title, IconData image, Function() onPressed,
          Color background) =>
      Card(
        elevation: 1.0,
        margin: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(253, 253, 253, 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 5),
                      color: Theme.of(context).primaryColor.withOpacity(.3),
                      spreadRadius: 3,
                      blurRadius: 5)
                ]),
            child: new InkWell(
              onTap: onPressed,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: [
                  const SizedBox(height: 40.0),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: background, shape: BoxShape.circle),
                    child: Center(
                        child: Icon(
                      image,
                      // width: 75.0,
                      // height: 65.0,
                      size: 40.0,
                      color: Colors.white,
                    )),
                  ),
                  const SizedBox(height: 15.0),
                  new Center(
                    child: new Text(title,
                        style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600))),
                  )
                ],
              ),
            )),
      );

  makeCardItem(String title, int? countReim, Color background) => Card(
        elevation: 1.0,
        margin: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(253, 253, 253, 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 5),
                      color: Theme.of(context).primaryColor.withOpacity(.3),
                      spreadRadius: 3,
                      blurRadius: 5)
                ]),
            child: new InkWell(
              // onTap: onPressed,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: [
                  const SizedBox(height: 40.0),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: background, shape: BoxShape.circle),
                    child: Center(
                        child: new Text(countReim.toString(),
                            style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 29,
                                    fontWeight: FontWeight.w600)))),
                  ),
                  const SizedBox(height: 15.0),
                  new Center(
                    child: new Text(title,
                        style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600))),
                  )
                ],
              ),
            )),
      );
}

Future<void> logout(BuildContext context) async {
  const CircularProgressIndicator();
  await FirebaseAuth.instance.signOut();
  // ignore: use_build_context_synchronously
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
}
