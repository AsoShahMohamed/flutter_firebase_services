import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    //no need for future builder to return the user from firebase auth since its not a future
    //  return FutureBuilder(future: FirebaseAuth.instance.currentUser(), .....

    final double deviceWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('/chatroom')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (_, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = asyncSnapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemBuilder: (_, count) {
              return MessageBubble(
                  dWidth: deviceWidth,
                  message: docs[count]['text'],
                  isMe: FirebaseAuth.instance.currentUser!.uid ==
                      docs[count]['userId'],
                  key: ValueKey(docs[count].id),
                  userName: docs[count]['userName'],
                  userImage: docs[count]['userImg']);
            },
            itemCount: docs.length,
          );
        });
  }
}
