import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';

import 'model.dart';

void main() {
  runApp(MaterialApp(
    home: Register(),
  ));
}

class Register extends StatelessWidget {
  Register({super.key});

  final store = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();

  void addUser(Users u) async {
    final ref = store.collection('users');
    Map<String, dynamic> data = <String, dynamic>{
      "Name": u.name,
      "Phone": u.phone,
      "Email": u.email,
      "Password": u.password,
      "Id": ref.doc()
    };

    await ref.add(data).then((value) => print("User Added")).catchError(
        (error) => {print(40), print("Failed to add user: $error")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
          title: const Text("Pickup Ninja"),
          leading: const Icon(Icons.menu),
          centerTitle: true,
          backgroundColor: Colors.blue[200]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const Text(
              "Register",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 700,
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                            label: Text("Name"),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty';
                          } else if (RegExp(r'(\d+)').hasMatch(value)) {
                            return 'Wrong Format';
                          } else if (value.length > 20) {
                            return 'Limit Exceed >20';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Phone"),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty';
                          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Wrong Format';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text("Email"),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty';
                          } else if (!RegExp(
                                  r'^[A-Za-z]+@{1}[a-z]+.{1}[a-z]{2,7}$')
                              .hasMatch(value)) {
                            return 'Wrong Format';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: password,
                        decoration: const InputDecoration(
                            label: Text("Password"),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: confirmPassword,
                        decoration: const InputDecoration(
                            label: Text("Confirm Password"),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (password.text == confirmPassword.text) {
                                Users u = Users(name.text, phone.text,
                                    email.text, password.text);
                                auth
                                    .createUserWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text)
                                    .then((value) => {addUser(u)});
                                var snackBar =
                                    const SnackBar(content: Text("User Added"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              }
                            }
                          },
                          child: const Text("Submit")),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Text("Already have an account?"))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
