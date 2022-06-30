import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/components/custom_button.dart';
import 'package:flashchat/components/custom_spinner.dart';
import 'package:flashchat/components/heading.dart';
import 'package:flashchat/components/text_field_custom.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/main.dart';
import 'package:flashchat/screens/login.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const String id = 'register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidePassword = true;
  final _auth = FirebaseAuth.instance;
  late String emailID, password, fName, lName;
  bool showSpinner = false;

  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    isLoggedIn = _auth.currentUser != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? const MainPage()
        : Scaffold(
            backgroundColor: kColor4,
            body: ModalProgressCustom(
              inAsyncCall: showSpinner,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Hero(
                              tag: 'logo',
                              child: SizedBox(
                                height: 120,
                                child: Image.asset('images/thunder.png'),
                              ),
                            ),
                            const Heading(text: 'Register'),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 100),
                              child: Divider(
                                color: Colors.black,
                                thickness: 0.1,
                                height: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      onChanged: (x) => fName = x,
                                      textAlign: TextAlign.center,
                                      cursorColor: kColor2,
                                      decoration: kTextBoxDecoration.copyWith(
                                        labelText: 'First Name',
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      onChanged: (x) => lName = x,
                                      textAlign: TextAlign.center,
                                      cursorColor: kColor2,
                                      decoration: kTextBoxDecoration.copyWith(
                                        labelText: 'Last Name',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                onChanged: (x) => emailID = x,
                                cursorColor: kColor2,
                                decoration: kTextBoxDecoration.copyWith(
                                  icon: const Icon(
                                    Icons.email_rounded,
                                    color: kColor2,
                                  ),
                                  labelText: 'Email ID',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                onChanged: (x) => password = x,
                                cursorColor: kColor2,
                                obscureText: hidePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: kTextBoxDecoration.copyWith(
                                  icon: const Icon(
                                    Icons.key_rounded,
                                    color: kColor2,
                                  ),
                                  labelText: 'Password',
                                  suffixIcon: ShowPassword(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: Icon(
                                      hidePassword
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      color: kColor2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Hero(
                              tag: 'button_register',
                              child: CustomButton(
                                onPressed: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    await _auth.createUserWithEmailAndPassword(
                                      email: emailID.trim(),
                                      password: password.trim(),
                                    );
                                    setState(() {
                                      showSpinner = false;
                                      isLoggedIn = _auth.currentUser != null
                                          ? true
                                          : false;
                                    });
                                    final cred = FirebaseFirestore.instance.collection('user');
                                    await cred.doc(_auth.currentUser!.email).set({
                                      'first name': fName,
                                      'last name': lName
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    if (e.code == 'email-already-in-use') {
                                      showCustomToast('Email is already used!');
                                    } else if (e.code == 'invalid-email') {
                                      showCustomToast('Invalid Email ID');
                                    } else if (e.code == 'weak-password') {
                                      showCustomToast('Use Strong Password');
                                    } else {
                                      showCustomToast(
                                          'Check your internet connection');
                                    }
                                  }
                                },
                                child: const Text('Sign up'),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?'),
                                Hero(
                                  tag: 'button_login',
                                  child: CustomTextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, LoginPage.id);
                                    },
                                    child: const Text(
                                      'Sign in',
                                      style: TextStyle(color: kColor2),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
