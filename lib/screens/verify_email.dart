import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/components/custom_button.dart';
import 'package:flashchat/components/custom_spinner.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
final _firestore = FirebaseFirestore.instance;

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  static const String id = 'VerifyEmail';
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  final _auth = FirebaseAuth.instance;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified = _auth.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool canResendEmail = false;
  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const ChatScreen()
        : Scaffold(
            backgroundColor: kColor4,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Verify Email',
                style: TextStyle(color: kColor4, fontWeight: FontWeight.w600),
              ),
              backgroundColor: kColor3,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: ModalProgressCustom(
                inAsyncCall: !canResendEmail ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'A Verification email has been sent to your email.',
                      style: TextStyle(
                        color: kColor2,
                      ),
                    ),
                    CustomButton(
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      child: const Text('Resend Email'),
                    ),
                    TextButton(
                        onPressed: () async {
                          await _firestore.collection('user').doc(_auth.currentUser!.email).delete();
                          await _auth.currentUser!.delete();
                        },
                        child: const Text('Cancel'))
                  ],
                ),
              ),
            ),
          );
  }

  void sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      showCustomToast(e.toString());
    }
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }
}
