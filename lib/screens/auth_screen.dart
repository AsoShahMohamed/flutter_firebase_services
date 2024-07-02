import 'dart:io';
import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitAuthForm(File pickedImage, String name, String pass, String email,
      bool isLogged, BuildContext cnt) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential authResult;
      if (isLogged) {
        authResult =
            await auth.signInWithEmailAndPassword(email: email, password: pass);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: pass);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user!.uid + '.jpg');
        ref
            .putFile(pickedImage, SettableMetadata(contentType: 'jpg'))
            .then((p0) async {
          final imageUrl = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid as String)
              .set({'username': name, 'email': email, 'imageUrl': imageUrl});
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      var msg = 'an error occured on platform side..';

      if (!error.message!.isEmpty) {
        msg = error.message!;
      }

      ScaffoldMessenger.of(cnt).showSnackBar(SnackBar(content: Text(msg)));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('something went wrong..');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
