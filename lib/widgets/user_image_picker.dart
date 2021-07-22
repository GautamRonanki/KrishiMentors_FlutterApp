import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import '../constants.dart';
import './custom_text.dart';
import '../providers/auth.dart';
import '../models/common_functions.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  final picker = ImagePicker();
  var _isLoading = false;

  void _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<void> _submitImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).userImageUpload(_image);

      CommonFunctions.showSuccessToast('Image uploaded Successfully');
    } on HttpException catch (error) {
      print(error);
      var errorMsg = 'Upload failed.';

      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      print(error);
      const errorMsg = 'Upload failed.';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false).user;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Customtext(
              text: 'Update Display Picture',
              colors: kTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CircleAvatar(
          radius: 50,
          backgroundImage:
              _image != null ? FileImage(_image) : NetworkImage(user.image),
        ),
        RaisedButton.icon(
          onPressed: _pickImage,
          color: kDarkButtonBg,
          icon: Icon(
            Icons.camera_alt,
            color: Colors.grey,
          ),
          label: Customtext(
            text: 'Choose Image',
            fontSize: 14,
            colors: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
            // side: BorderSide(color: kBlueColor),
          ),
        ),
        if (_image != null)
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RaisedButton.icon(
                  onPressed: _submitImage,
                  color: kBlueColor,
                  icon: Icon(
                    Icons.file_upload,
                    color: Colors.grey,
                  ),
                  label: Customtext(
                    text: 'Upload Image',
                    fontSize: 14,
                    colors: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    // side: BorderSide(color: kBlueColor),
                  ),
                )
      ],
    );
  }
}
