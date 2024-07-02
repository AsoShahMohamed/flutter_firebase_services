import 'package:flutter/material.dart';
import '../widgets/image_display.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  const AuthForm(this.subForm, this._isloading);
  final bool _isloading;
  final void Function(File pickedImage,String username, String pass, String email, bool isLogged,
      BuildContext cntx) subForm;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Map<String, dynamic> credentials = {
    'username': '',
    'password': '',
    'email': ''
  };

  bool _isLogged = true;
  File? _pickedUserImage;

  void _setUserImage(File image) {
    _pickedUserImage = image;
  }

  void _validateandsave() {
    final bool result = _formkey.currentState!.validate();
    //effect in action required ..
    FocusScope.of(context).unfocus();

    if (!_isLogged && _pickedUserImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('take an image to complete the signup'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }

    if (result) {
      _formkey.currentState!.save();
      widget.subForm(_pickedUserImage!,(credentials['username'] as String).trim(),
          credentials['password'], credentials['email'], _isLogged, context);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                if (!_isLogged) PickedImage(_setUserImage),
                TextFormField(
                  key: ValueKey('email'),
                  onSaved: (data) {
                    credentials['email'] = data;
                  },
                  validator: (data) {
                    if (data!.isEmpty || !data!.contains('@')) {
                      return 'enter a valid emaila dress ..';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(label: Text('enter email')),
                ),
                if (!_isLogged)
                  TextFormField(
                    key: ValueKey('username'),
                    onSaved: (data) {
                      credentials['username'] = data;
                    },
                    validator: (data) {
                      if (data!.isEmpty || data.length < 4) {
                        return 'enter a a username more than 4 characters..';
                      }
                      return null;
                    },
                    decoration: InputDecoration(label: Text('enter username')),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  onSaved: (data) {
                    credentials['password'] = data;
                  },
                  validator: (data) {
                    if (data!.isEmpty || data.length < 7) {
                      return 'enter a a username more than 7 characters..';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text('enter password'),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget._isloading) CircularProgressIndicator(),
                if (!widget._isloading)
                  ElevatedButton(
                    child: Text(_isLogged ? 'Login' : 'Register'),
                    onPressed: _validateandsave,
                  ),
                SizedBox(
                  height: 5,
                ),
                if (!widget._isloading)
                  ElevatedButton(
                    child: Text(
                        _isLogged ? 'create new account' : 'login Instead'),
                    onPressed: () {
                      setState(() {
                        _isLogged = !_isLogged;
                      });
                    },
                  )
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
        ),
      ),
    );
  }
}
