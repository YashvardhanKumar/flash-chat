import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/components/custom_button.dart';
import 'package:flashchat/components/custom_spinner.dart';
import 'package:flashchat/components/heading.dart';
import 'package:flashchat/components/text_field_custom.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flashchat/screens/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String id = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true, showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String emailID, password;
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    isLoggedIn = _auth.currentUser != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? const ChatScreen()
        : Scaffold(
            resizeToAvoidBottomInset: true,
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
                            const Heading(text: 'Login'),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 100),
                              child: Divider(
                                color: Colors.black,
                                thickness: 0.1,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                initialValue: '',
                                autocorrect: true,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: kColor2,
                                decoration: kTextBoxDecoration.copyWith(
                                  icon: const Icon(
                                    Icons.email_rounded,
                                    color: kColor2,
                                  ),
                                  labelText: 'Email ID',
                                ),
                                onChanged: (x) => emailID = x,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                cursorColor: kColor2,
                                obscureText: hidePassword,
                                onChanged: (x) => password = x,
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
                              tag: 'button_login',
                              child: CustomButton(
                                onPressed: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    await _auth.signInWithEmailAndPassword(
                                      email: emailID,
                                      password: password,
                                    );
                                    setState(() {
                                      showSpinner = false;
                                      isLoggedIn = _auth.currentUser != null
                                          ? true
                                          : false;
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    if (e.code == 'user-not-found') {
                                      showCustomToast('User not found');
                                    } else if (e.code == 'wrong-password') {
                                      showCustomToast('Wrong Password');
                                    } else {
                                      showCustomToast(
                                          'Check your Internet and try again!');
                                    }
                                  }
                                },
                                child: const Text('Sign in'),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t have an account?'),
                                Hero(
                                  tag: 'button_register',
                                  child: CustomTextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, RegisterPage.id);
                                    },
                                    child: const Text(
                                      'Sign up',
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
