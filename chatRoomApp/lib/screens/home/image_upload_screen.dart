import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/constants/colorAndDesignConstants.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flash_chat/services/UserDbService.dart';

final _firestore = Firestore.instance;

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  User loggedInUser;
  UserData userData;
  UserDbService _userDbService;
  String courseCode;
  File _imageFile;
  String _imageFileUrl;
  DateTime now = new DateTime.now();
  AuthService _authService = AuthService();

  Future<void> _imagePicker(ImageSource imageSource) async {
    File selected = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      _imageFile = selected;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://flash-chat-483ae.appspot.com');

  void _upload() async {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    String filePath =
        'images-$courseCode/${DateTime.now()}-${loggedInUser.email}';
    try {
      await _storage.ref().child(filePath).putFile(_imageFile).onComplete;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error has occured!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (_imageFile == null) {
      Fluttertoast.showToast(
          msg: "Please upload a file!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      _storage.ref().child(filePath).getDownloadURL().then((fileURL) {
        _imageFileUrl = fileURL;
        _firestore.collection('messages-$courseCode').add({
          'sentOn': now,
          'text': encrypter.encrypt(_imageFileUrl, iv: iv).base64,
          'sender': loggedInUser.email,
          'isImage': true,
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  void getCurrentUserData() async {
    try {
      final user = await _authService.currentUser();
      if (user != null) {
        loggedInUser = user;
        _userDbService = UserDbService(uid: loggedInUser.uid);
        userData = await _userDbService.getUserDataFromUid();
        setState(() {
          courseCode = userData.courseCode;
        });

        print('----------------------------------$courseCode');
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload an Image - $courseCode 🎈',
        ),
        backgroundColor: kPrimaryColourDark,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _authService.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: kPrimaryColour,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "📂",
                  style: TextStyle(fontSize: 30),
                ),
                onPressed: () => _imagePicker(ImageSource.gallery),
              ),
              FlatButton(
                child: Text(
                  "📸",
                  style: TextStyle(fontSize: 30),
                ),
                onPressed: () => _imagePicker(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: chosenImage(_imageFile),
          ),
        ),
      ),
    );
  }

  Widget chosenImage(File image) {
    if (image == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Center(child: Text("Please Choose an Image")),
              width: double.infinity,
              height: 300,
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Container(child: Image.file(_imageFile))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 100.0,
                child: RoundedButton(
                  colour: kPrimaryColourLight,
                  title: "🚫",
                  bold: true,
                  onPressed: () {
                    _clear();
                  },
                ),
              ),
              SizedBox(
                width: 100.0,
                child: RoundedButton(
                  colour: kPrimaryColourLight,
                  title: "📤",
                  bold: true,
                  onPressed: () {
                    _upload();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
