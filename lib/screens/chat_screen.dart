import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/components/custom_button.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String id = 'chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late String message;
  List<String> messages = [];
  bool isLoggedIn = false;
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      loggedInUser = user!;
    } catch (e) {
      showCustomToast('Login error!');
    }
  }

  void deleteMessage(String prevEmail) {
    final data = _firestore.collection('messages').where('sender', isEqualTo: prevEmail).snapshots();
    data.forEach((element) async {
      for (var e in element.docs) {
        await _firestore.collection('messages').doc(e.id).delete();
    }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    isLoggedIn = _auth.currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    final fieldText = TextEditingController();
    return !isLoggedIn
        ? const WelcomePage()
        : Scaffold(
            backgroundColor: kColor4,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Chat Group',
                style: TextStyle(color: kColor4, fontWeight: FontWeight.w600),
              ),
              backgroundColor: kColor3,
              actions: <Widget>[
                PopupMenuButton<int>(
                  color: kColor2,
                  elevation: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onSelected: (item) {
                    if (item == 1) {
                      show_dialog(context, () async {
                        final prevEmail = _auth.currentUser!.email;
                        deleteMessage(prevEmail!);
                        await _firestore.collection('user').doc(prevEmail).delete();
                        await _auth.currentUser!.delete();
                        setState(() => isLoggedIn = false);
                      },
                          const Text(
                              'Are you sure you want to delete your account?'));
                    } else if (item == 0) {
                      show_dialog(context, () async {
                        await _auth.signOut();
                        setState(() => isLoggedIn = _auth.currentUser != null);
                      }, const Text('Are you sure you want to Logout?'));
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<int>(
                      value: 0,
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          'Logout',
                          style: TextStyle(color: kColor4),
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: SizedBox(
                        child: Text(
                          'Delete Account',
                          style: TextStyle(color: kColor4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: MessagesStream(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: kColor1.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorColor: kColor1,
                              controller: fieldText,
                              onChanged: (x) => message = x,
                              decoration: kTextBoxDecoration.copyWith(
                                  hintText: 'Enter message to send',
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kColor1, width: 2)),
                                  hintStyle: const TextStyle(color: kColor2)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kColor1,
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                enableFeedback: false,
                                splashRadius: 10,
                                onPressed: () async {
                                  fieldText.clear();
                                  final time = DateTime.now();
                                  _firestore
                                      .collection('messages')
                                      .add({
                                    "sender": loggedInUser.email,
                                    "text": message,
                                    "time": time
                                  });
                                },
                                constraints: const BoxConstraints(
                                    minHeight: 55, minWidth: 55),
                                icon: const Icon(
                                  Icons.send,
                                  color: kColor4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.sender,
    required this.text,
    required this.timeStamp,
    required this.isMe,
    required this.sameTime,
    required this.sameEmail,
  }) : super(key: key);

  final String sender;
  final String text;
  final DateTime timeStamp;
  final bool isMe, sameTime, sameEmail;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          sameTime
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      right: isMe ? 8 : 0, left: isMe ? 0 : 8, top: 6),
                  child: Text(
                    daytime(timeStamp), // textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 10, color: kColor3),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 270, minWidth: 70),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: isMe
                        ? [kColor3, kColor2]
                        : [Colors.black, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(isMe || (sameEmail && sameTime) ? 10 : 1),
                  topRight: Radius.circular(
                      isMe && (!sameEmail || !sameTime) ? 1 : 10),
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
              ),
              margin: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sameEmail
                      ? const SizedBox()
                      : Text(
                          sender,
                          style: const TextStyle(
                            fontSize: 10,
                            color: kColor1,
                          ),
                        ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: kColor4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: LinearProgressIndicator(
              color: kColor1,
            ),
          );
        } else {
          Timestamp? prevTime;
          String? prevEmail;
          List<MessageBubble> list = [];
          final messages = snapshots.data?.docs;
          for (var msg in messages!) {
            final text = msg.get('text');
            final email = msg.get('sender');
            final Timestamp time = msg.get('time');
            String? username;
            bool isMe = email == FirebaseAuth.instance.currentUser!.email;
            bool sameTime = prevTime != null && prevTime.toDate().minute == time.toDate().minute && prevTime.toDate().hour == time.toDate().hour;
            bool sameEmail = prevEmail != null || prevEmail == email;
            final name = _firestore.collection('user').doc(email).collection('first name');
            name.forEach((element) {
              username = element.get('first name') + element.get('last name');
              list.add(MessageBubble(sender: username!, text: text, timeStamp: time.toDate(), isMe: isMe, sameTime: sameTime && sameEmail, sameEmail: sameEmail));
            });

            prevTime = time;
            prevEmail = email;
          }
          return Column(
            children: list,
          );
        }
      },
    );
  }
}

String daytime(DateTime timeStamp) {
  late String date;
  String hour =
      timeStamp.hour < 10 ? '0${timeStamp.hour}' : '${timeStamp.hour}';
  String minute =
      timeStamp.minute < 10 ? '0${timeStamp.minute}' : '${timeStamp.minute}';
  if (timeStamp.day == DateTime.now().day) {
    date = 'Today, $hour:$minute';
  } else if (timeStamp.day == DateTime.now().day - 1) {
    date = 'Yesterday, $hour:$minute';
  } else {
    date =
        '${timeStamp.day <= 9 ? '0${timeStamp.day}' : timeStamp.day}/${timeStamp.month <= 9 ? '0${timeStamp.month}' : timeStamp.month}/${timeStamp.year}, $hour:$minute';
  }
  return date;
}

show_dialog(BuildContext context, VoidCallback onPressed, Text text) =>
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Warning'),
        content: text,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Yes');
              onPressed();
            },
            child: const Text('Yes'),
          ),
          TextButtonTheme(
            data: TextButtonThemeData(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0x5aff0000))),
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'No'),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

//           final m = snapshots.data?.docs;
//           List<MessageBubble> widgets = [];
//           DateTime? timeThen;
//           String? emailThen;
//           int idx = 0;
//           for (var message in m!) {
//             final text = message.get('text');
//             final time = message.id;
//             final sender = 'user';
//             final currentUser = loggedInUser.email;
//             final parsedTime = DateTime.parse(time);
//             print(sender);
//             final MessageBubble widget = MessageBubble(
//               sender: sender,
//               text: text,
//               timeStamp: DateTime.parse(time),
//               isMe: currentUser == sender,
//               sameEmail: emailThen != null && emailThen == sender,
//               sameTime: timeThen != null &&
//                   timeThen.minute == parsedTime.minute &&
//                   timeThen.hour == parsedTime.hour,
//             );
//             widgets.add(widget);
//             emailThen = sender;
//             timeThen = parsedTime;
//           }
//           return Column(
//             children: widgets,
//           );
