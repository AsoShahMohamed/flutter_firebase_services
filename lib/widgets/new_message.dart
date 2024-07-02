import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();

  String msg = '';
  void _sendMessage() async {
    //setback is each message has the iamgeurl and the user name associated with them, 
    //if user data changes so should every single chat with its data
    FocusScope.of(context).unfocus();
    final firestore = FirebaseFirestore.instance.collection('/chatroom');
    final userName = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    
//no need to wait for future user returns anymore.
    firestore.add({
      'text': msg,
      'created_at': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid
      ,'userName': userName['username'],
      'userImg': userName['imageUrl']
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        child: Row(children: <Widget>[
          Expanded(
              child: TextField(
            controller: _controller,
            onChanged: (value) {
              setState(() {
                msg = value;
              });
            },
            decoration:
                InputDecoration(label: const Text('send a new message...')),
          )),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: msg.trim().isEmpty
                ? null
                : () {
                    _sendMessage();
                  },
          )
        ]));
  }
}
