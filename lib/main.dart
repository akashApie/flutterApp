import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'mainPage.dart';
import 'model.dart';

bool shouldUseFirestoreEmulator = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  runApp(const MaterialApp(
      title: 'Login Page', color: Colors.cyan, home: Login()));
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginPage();
}

class LoginPage extends State<Login> {
  final store = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  var selected = false;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Pickup Ninja',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.blue[200],
          leading: const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              )),
        ),
        body: Container(
          height: screenHeight - keyboardHeight,
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 55),
          child: Form(
              key: formKey,
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(width: 2))),
                            validator: (text) {
                              if (text!.isEmpty) {
                                return 'Empty';
                              } else
                                return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: selected?true:false,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selected = !selected;
                                      });
                                    },
                                    icon: selected
                                        ? const Icon(Icons.remove_red_eye)
                                        : const Icon(
                                            Icons.remove_red_eye_outlined)),
                                labelText: 'Password',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            validator: (text) {
                              if (text!.isEmpty) {
                                return 'Empty';
                              } else
                                return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: ElevatedButton(
                        onPressed: () async {
                          auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

                          await store.collection("users").get().then((event) {
                            for (var doc in event.docs) {
                              if (doc.data()['Email'] == emailController.text ) {
                                var data=doc.data();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                           HomePage(data:data)));
                                break;
                              }
                            }
                          });
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: const Text("Don't have an account?"))
                  ],
                ),
              )),
        ));
  }
}
