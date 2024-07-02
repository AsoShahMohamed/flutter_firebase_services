import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PickedImage extends StatefulWidget {
  const PickedImage(this._setUserImage);

  final void Function(File image) _setUserImage;

  @override
  State<PickedImage> createState() => _PickedImageState();
}

class _PickedImageState extends State<PickedImage> {
  File? _pickedImage;




  Future<void> _pickAnImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera,imageQuality:50,  maxWidth: 150 );
    final fileImage = File(pickedImage!.path);

    setState(() {
      _pickedImage = fileImage;
    });

    widget._setUserImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      if (_pickedImage == null)
        CircleAvatar(radius: 30,
          backgroundColor: Colors.grey,
        ),
      if (_pickedImage != null)
        CircleAvatar(radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage:
              FileImage(_pickedImage!)
        ),
      ElevatedButton.icon(
          onPressed: _pickAnImage,
          icon: Icon(Icons.camera),
          label: Text('pick image')),
    ]);
  }
}
