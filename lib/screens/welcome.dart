import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/components/custom_button.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/login.dart';
import 'package:flashchat/screens/register.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static const String id = 'welcome';
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    animation = ColorTween(begin: kColor1, end: kColor3).animate(controller);
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColor4,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 70,
                    child: Image.asset('images/thunder.png'),
                  ),
                ),
                SizedBox(
                  width: 250.0,
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: animation.value,
                      fontWeight: FontWeight.w600,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Flash Chat',
                            speed: const Duration(milliseconds: 100)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Divider(
                color: Colors.black,
                thickness: 0.1,
                height: 80,
              ),
            ),
            Hero(
              tag: 'button_register',
              child: CustomButton(
                onPressed: () {
                  Navigator.restorablePushReplacementNamed(
                      context, RegisterPage.id);
                },
                child: const Text('Register'),
              ),
            ),
            Hero(
              tag: 'button_login',
              child: CustomButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginPage.id);
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
