import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opt_ga_flutter_apps/screens/admin/administrator.dart';
import 'package:opt_ga_flutter_apps/screens/driver/driver.dart';
import 'package:opt_ga_flutter_apps/screens/management/management.dart';
import 'package:opt_ga_flutter_apps/screens/verificator/verificator.dart';
import 'register.dart';
import '../../helper-layouts/custom_alert_dialog.dart';

class LoginPage extends StatefulWidget {
  final User? user;
  final DocumentSnapshot? doccumentSnapshot;
  // ignore: use_key_in_widget_constructors
  const LoginPage({this.user, this.doccumentSnapshot});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? _currentUser;
  DocumentSnapshot? _doccumentSnapshot;
  dynamic name;
  dynamic email;
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  void initState() {
    _currentUser = widget.user;
    _doccumentSnapshot = widget.doccumentSnapshot;
    // ignore: unused_local_variable
    var resultQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser?.uid)
        .get();
    if (_doccumentSnapshot != null) {
      _doccumentSnapshot?.get('name');
      _doccumentSnapshot?.get('npk');
      name = _doccumentSnapshot?.get('name');
      email = _doccumentSnapshot?.get('email');
      super.initState();
    }
  }

  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              // color: Color.fromARGB(255, 19, 2, 2),
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * 0.70,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        const Icon(
                          Icons.lock,
                          size: 100,
                        ),
                        const SizedBox(height: 50),
                        // welcome back, you've been missed!
                        Text(
                          'Welcome back you\'ve been missed!',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            enabled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure3
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            enabled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        MaterialButton(
                            onPressed: () {
                              setState(() {
                                visible = true;
                              });
                              signIn(emailController.text,
                                  passwordController.text);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not have an account?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register()
                       ),
                  ),
                  child: const Text(
                  'Register Now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists && user != null) {
        if (documentSnapshot.get('rool') == "Administrator") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Administrator(
                user: user,
                doccumentSnapshot: documentSnapshot,
              ),
            ),
          );
        } else if (documentSnapshot.get('rool') == "Management") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ManagementPage(
                user: user,
                doccumentSnapshot: documentSnapshot,
              ),
            ),
          );
        } else if (documentSnapshot.get('rool') == "Verificator") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerificatorPage(
                user: user,
                doccumentSnapshot: documentSnapshot,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Driver(
                user: user,
                doccumentSnapshot: documentSnapshot,
              ),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // print('No user found for that email.');
          showDialog(
            context: context,
            builder: (context) {
              return const CustomAlertDialog(
                title: "Error",
                description: "Credentials does not match",
              );
            },
          );
        } else if (e.code == 'wrong-password') {
          showDialog(
            context: context,
            builder: (context) {
              return const CustomAlertDialog(
                title: "Error",
                description: "Wrong password",
              );
            },
          );
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: const Text("Error"),
          //         content: const Text("Wrong password"),
          //         actions: <Widget>[
          //           ElevatedButton(
          //               onPressed: (() {
          //                 Navigator.of(context).pop();
          //               }),
          //               child: Container(
          //                 // color: Colors.green,
          //                 padding: const EdgeInsets.all(14),
          //                 child: const Text("Ok"),
          //               ))
          //         ],
          //       );
          //     });
        } else if (e.code == 'too-many-requests') {
          showDialog(
            context: context,
            builder: (context) {
              return const CustomAlertDialog(
                title: "Error",
                description: "Please check your credentials",
              );
            },
          );
        }    
      }
    }
  }
}
