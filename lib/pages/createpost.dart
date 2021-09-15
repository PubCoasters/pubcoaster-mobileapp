import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/navbarhome.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/pages/locationposts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String? location;
  String? bar;
  String? neighborhood;
  int? rating;
  String? content;
  bool anonymous = false;
  String? picLink;
  File? _image;
  String? locationType;
  String? busyness;
  bool filePicked = false;
  final postService = new PostService();

  // File _image = '' as File;
  final picker = ImagePicker();

  Future getImage(bool gallery) async {
    final pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    if (mounted) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          filePicked = true;
          Navigator.of(context).pop();
        } else {
          print('No image selected.');
        }
      });
    }
  }

  Widget alertText() {
    if (!filePicked) {
      return Text('Choose an upload method',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      return Text(_image.toString(),
          style: TextStyle(
              fontStyle: FontStyle.italic, color: Colors.black, fontSize: 16));
    }
  }

  Widget pictureButton() {
    if (!filePicked) {
      return FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext content) {
              //getImage()
              return AlertDialog(
                  title: Text(
                    'Choose an upload method',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 23),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.white,
                  content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          child: Icon(Icons.file_upload),
                          onPressed: () => getImage(true),
                          tooltip: 'Upload from storage',
                          backgroundColor: Colors.red,
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.camera),
                          tooltip: 'Upload from camera',
                          onPressed: () => getImage(false),
                          backgroundColor: Colors.red,
                        )
                      ]));
            }),
        tooltip: 'Picture (Optional)',
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.red,
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('File Successfully Picked!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20)),
          ),
          FloatingActionButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext content) {
                  //getImage()
                  return AlertDialog(
                      title: Text(
                        'Choose an upload method',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.white,
                      content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FloatingActionButton(
                              child: Icon(Icons.file_upload),
                              onPressed: () => getImage(true),
                              tooltip: 'Upload from storage',
                              backgroundColor: Colors.red,
                            ),
                            FloatingActionButton(
                              child: Icon(Icons.camera),
                              tooltip: 'Upload from camera',
                              onPressed: () => getImage(false),
                              backgroundColor: Colors.red,
                            )
                          ]));
                }),
            tooltip: 'Picture (Optional)',
            child: Icon(Icons.add_a_photo),
            backgroundColor: Colors.red,
          ),
        ],
      );
    }
  }

  showLoadingDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext content) {
          //getImage()
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.height * .2,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        strokeWidth: 10,
                      ))));
        });
  }

  submitPost(String? loc, String? bar, String? nbhood, int? rating,
      String? descrip, bool anon) async {
    String user = FirebaseAuth.instance.currentUser!.displayName!;
    if (bar == null ||
        bar == "" ||
        descrip == null ||
        descrip == "" ||
        rating == null ||
        loc == null ||
        loc == "" ||
        busyness == null ||
        busyness == "") {
      final snackBar = SnackBar(
          content: Text(
              'Please fill out all required info before trying to create a post!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (descrip.length > 128) {
      //description is too long
      final snackBar = SnackBar(
          content: Text(
              'Description is too long. Please fit your content within 128 characters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      showLoadingDialog();
      if (filePicked) {
        try {
          final firebase_storage.Reference storageRef = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('post_pics/${_image!.path.split("/").last}');
          firebase_storage.UploadTask task = storageRef.putFile(_image!);
          await task.whenComplete(() async {
            storageRef.getDownloadURL().then((url) async {
              var reqBody = {
                'username': user,
                'anonymous': anon,
                'bar': bar,
                'description': descrip,
                'rating': rating,
                'location': loc,
                'nbhood': nbhood,
                'picLink': url,
                'busyness': busyness,
              };
              bool succeed = await postService.addPost(reqBody);
              if (succeed) {
                Navigator.of(context).pop();
                final snackBar = SnackBar(
                    content: Text('Successfully created post!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                    backgroundColor: Colors.green);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pushReplacementNamed(context, LocationPosts.route,
                    arguments: location);
              } else {
                Navigator.of(context).pop();
                final snackBar = SnackBar(
                    content: Text(
                        'Error: could not create post. Check connection',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20)),
                    backgroundColor: Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            });
          });
        } on firebase_core.FirebaseException catch (e) {
          print(e);
          Navigator.of(context).pop();
          final snackBar = SnackBar(
              content: Text(
                  'Unable to upload file. Please check your network connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20)),
              backgroundColor: Colors.red);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        var reqBody = {
          'username': user,
          'anonymous': anon,
          'bar': bar,
          'description': descrip,
          'rating': rating,
          'location': loc,
          'nbhood': nbhood,
          'busyness': busyness,
          'picLink': ''
        };
        bool succeed = await postService.addPost(reqBody);
        if (succeed) {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
              content: Text('Successfully created post!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20)),
              backgroundColor: Colors.green);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushReplacementNamed(context, LocationPosts.route,
              arguments: location);
        } else {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
              content: Text('Error: could not create post. Check connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20)),
              backgroundColor: Colors.red);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  goBack() {
    Navigator.pushReplacementNamed(context, '/mypost');
  }

  Widget _locationDropdown() {
    if (locationType == 'City') {
      return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
        child: DropdownButtonFormField(
            items: [
              'Columbus',
              'Chicago',
              'New York',
              'Denver',
              'Washington DC',
              'San Francisco',
              'Orlando',
              'Phoenix',
              'Boston',
              'Los Angeles'
            ]
                .map((String value) => DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    ))
                .toList(),
            onChanged: (String? value) {
              if (mounted) {
                setState(() {
                  location = value!;
                });
              }
            },
            hint: Text('City*'),
            decoration: InputDecoration(focusColor: Colors.black)),
      );
    } else if (locationType == 'College') {
      return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
        child: DropdownButtonFormField(
            items: [
              'Ohio State',
              'University of Michigan',
              'Michigan State',
              'Penn State',
              'University of Illinois',
              'University of Wisconsin'
            ]
                .map((String value) => DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    ))
                .toList(),
            onChanged: (String? value) {
              if (mounted) {
                setState(() {
                  location = value!;
                });
              }
            },
            hint: Text('College*'),
            decoration: InputDecoration(focusColor: Colors.black)),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
        child: DropdownButtonFormField(
            items: [],
            hint: Text('Location*'),
            decoration: InputDecoration(focusColor: Colors.black)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          NavBar(),
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 4, top: 6),
            child: Container(
              decoration: BoxDecoration(border: Border.all(width: 4)),
              padding: const EdgeInsets.only(right: 4, left: 4, top: 10),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 0),
                        child: Center(
                          child: Text(
                            'Create a New Post',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 1.5,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 6, right: 6, top: 4),
                        child: DropdownButtonFormField(
                          items: ['City', 'College']
                              .map((String value) => DropdownMenuItem<String>(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            if (mounted) {
                              setState(() {
                                locationType = value!;
                              });
                            }
                          },
                          hint: Text('Location Type*'),
                          decoration: InputDecoration(focusColor: Colors.black),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: .5,
                      ),
                      _locationDropdown(),
                      const Divider(
                        color: Colors.white,
                        thickness: .5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Bar*'),
                          onChanged: (value) => {
                            if (mounted)
                              {
                                setState(() => {bar = value})
                              }
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: DropdownButtonFormField(
                          items: [
                            'Dead AF',
                            'Some Crowd',
                            'Lively Enough',
                            'There Are Lines',
                            'Can’t Move'
                          ]
                              .map((String value) => DropdownMenuItem<String>(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            if (mounted) {
                              setState(() {
                                busyness = value;
                              });
                            }
                          },
                          hint: Text('How Busy Would You Say It Is?*'),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.75,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Neighborhood'),
                          onChanged: (value) => {
                            if (mounted)
                              {
                                setState(() => {neighborhood = value})
                              }
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: DropdownButtonFormField(
                          items: [
                            '1',
                            '2',
                            '3',
                            '4',
                            '5',
                            '6',
                            '7',
                            '8',
                            '9',
                            '10'
                          ]
                              .map((String value) => DropdownMenuItem<String>(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            if (mounted) {
                              setState(() {
                                rating = int.parse(value!);
                              });
                            }
                          },
                          hint: Text('Experience Rating*'),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.75,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  'What\'s good?* (character limit: 128)'),
                          onChanged: (value) => {
                            if (mounted)
                              {
                                setState(() => {content = value})
                              }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: CheckboxListTile(
                            value: anonymous,
                            title: Text('Make post anonymous?',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            onChanged: (bool? value) {
                              if (mounted) {
                                setState(() {
                                  anonymous = value!;
                                });
                              }
                            },
                            secondary: Icon(Icons.security, size: 30)),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: pictureButton()),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: const Divider(
                          color: Colors.white,
                          thickness: .5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                goBack();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.red)))),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                submitPost(location, bar, neighborhood, rating,
                                    content, anonymous);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.red)))),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
