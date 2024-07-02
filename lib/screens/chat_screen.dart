import '../widgets/new_message.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {



void setupPushNotification() async{

  await  FirebaseMessaging.instance.requestPermission();
  
  // final String?  token =await FirebaseMessaging.instance.getToken();
// print(token);

FirebaseMessaging.instance.subscribeToTopic('chat');

}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  
  setupPushNotification();
  }


  void _signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your messages'),
        actions: <Widget>[
          DropdownButton(
              padding: EdgeInsets.all(2.5),
              icon: Icon(Icons.more_vert),
              items: <DropdownMenuItem>[
                DropdownMenuItem(
                    value: 'signout',
                    child: Container(
                      child: Row(children: [
                        Text('signout'),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.exit_to_app)
                      ]),
                    ))
              ],
              onChanged: (onChanged) {
                if (onChanged == 'signout') {
                  _signUserOut();
                }
                return;
              })
        ],
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Expanded(child: Messages()), NewMessage()],
      )),
//       floatingActionButton: FloatingActionButton(
//         tooltip: 'press to reload',
//         onPressed: () async {
//           // final result =  .listen((event) { event.docs.forEach((element) { print(element.data());
//           //   });
//           // });

//           final doc = await FirebaseFirestore.instance
//               .collection('/chatroom')
//               .add({'text': 'manuall entry'});

// // result.forEach((element) { element.docs.forEach((element) {print(element.data()); });});
//         }

//         // .snapshots().listen((data) {print(data.); });
//         ,
//         child: Text('load chats'),
//       ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



// StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('/chatroom/anotheruser/chats/')
//             .snapshots(),
//         builder: (_, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final docs = snapshot.data!.docs;
//           return ListView.builder(
//               itemCount: docs.length,
//               itemBuilder: (_, count) {
//                 return Container(
//                     padding: EdgeInsets.all(10),
//                     child: Text(docs[count]['text']));
//               });
//         },
//       )