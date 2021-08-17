import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:NewApp/services/userservice.dart';
import 'package:NewApp/pages/myuserlikedtype.dart';
import 'package:NewApp/models/userlikedargs.dart';
import 'package:NewApp/pages/myfollower.dart';
import 'package:NewApp/pages/myfollowing.dart';

class MyUserProfile extends StatefulWidget {
  MyUserProfile(this.userInfo, this.numPosts);
  final userInfo;
  final numPosts;
  @override
  _MyUserProfileState createState() => _MyUserProfileState();
}

class _MyUserProfileState extends State<MyUserProfile> {
  bool editName = false;
  bool editBio = false;
  String? newFirstName;
  String? newLastName;
  String? newBio;
  File? _image;
  final userService = new UserService();
  final picker = ImagePicker();

  Widget _postDialog() {
    return AlertDialog(
      title: Text(
        'Just look down the screen bro',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 23),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.white,
    );
  }

  _updatePicture(File? image) async {
    if (image != null) {
      try {
        final firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('prof_pics/${_image!.path.split("/").last}');
        firebase_storage.UploadTask task = storageRef.putFile(_image!);
        await task.whenComplete(() async {
          storageRef.getDownloadURL().then((url) async {
            var body = {
              'firstName': null,
              'email': null,
              'bio': null,
              'lastName': null,
              'fullName': null,
              'picLink': url
            };
            bool succeed =
                await userService.updateUser(body, widget.userInfo.username);
            if (!succeed) {
              final snackBar = SnackBar(
                  content: Text(
                      'Error: could not update picture. Check network connection.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 20)),
                  backgroundColor: Colors.red);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            try {
              await FirebaseAuth.instance.currentUser!.updateProfile(
                  displayName: widget.userInfo.username, photoURL: url);
              Navigator.pushReplacementNamed(context, '/mypost');
            } catch (e) {
              print(e);
              final snackBar = SnackBar(
                  content: Text(
                      'Error updating picture! Check network connection.',
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
      } catch (e) {
        print(e);
        final snackBar = SnackBar(
            content: Text('Error updating picture! Check network connection.',
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

  _deleteAccount() async {
    try {
      bool succeed = await userService.deleteUser(widget.userInfo.username);
      if (succeed) {
        await FirebaseAuth.instance.currentUser!.delete();
        Navigator.pushReplacementNamed(context, '/signin');
        final snackBar = SnackBar(
            content: Text('Deleted. Okay, bye',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
          content: Text(
              'Error deleting the user. Check your network connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _deleteDialog() {
    return AlertDialog(
        title: Text(
          'Confirm deleting your account',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 23),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        content:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FloatingActionButton(
            child: Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Cancel',
            backgroundColor: Colors.red,
          ),
          FloatingActionButton(
            child: Icon(Icons.check),
            tooltip: 'Confirm',
            onPressed: () => _deleteAccount(),
            backgroundColor: Colors.red,
          )
        ]));
  }

  Widget _pictureDialog() {
    return AlertDialog(
        title: Text(
          'Choose an upload method',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 23),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        content:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
  }

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
        } else {
          print('No image selected.');
        }
      });
    }
    await _updatePicture(_image);
    Navigator.of(context).pop();
  }

  updateUserName(String? firstName, String? lastName) async {
    if (firstName != null || lastName != null) {
      try {
        var body = {};
        if (firstName != null && lastName != null) {
          body = {
            'firstName': firstName,
            'email': null,
            'bio': null,
            'lastName': lastName,
            'fullName': '$firstName $lastName',
            'picLink': null
          };
        } else if (firstName != null && lastName == null) {
          body = {
            'firstName': firstName,
            'email': null,
            'bio': null,
            'lastName': widget.userInfo.lastName,
            'fullName': '$firstName ${widget.userInfo.lastName}',
            'picLink': null
          };
        } else if (lastName != null && firstName == null) {
          body = {
            'firstName': widget.userInfo.firstName,
            'email': null,
            'bio': null,
            'lastName': lastName,
            'fullName': '${widget.userInfo.firstName} $lastName',
            'picLink': null
          };
        }

        bool succeed =
            await userService.updateUser(body, widget.userInfo.username);
        if (succeed) {
          Navigator.pushReplacementNamed(context, '/mypost');
        }
      } catch (e) {
        print(e);
        final snackBar = SnackBar(
            content: Text('Error submitting update. Check network connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Error make sure to fill out first or last name',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  updateBio(String? bio) async {
    if (bio != null) {
      try {
        var body = {
          'firstName': null,
          'email': null,
          'bio': bio,
          'lastName': null,
          'fullName': null,
          'picLink': null
        };
        bool succeed =
            await userService.updateUser(body, widget.userInfo.username);
        if (succeed) {
          Navigator.pushReplacementNamed(context, '/mypost');
        }
      } catch (e) {
        print(e);
        final snackBar = SnackBar(
            content: Text('Error submitting update. Check network connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Error make sure bio is filled out',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _avatar() {
    if (widget.userInfo.picLink != null) {
      return Column(
        children: [
          GestureDetector(
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.userInfo.picLink),
              radius: MediaQuery.of(context).size.width * .1,
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext content) {
                    return _pictureDialog();
                  });
            },
          ),
          _numFollowers(),
          _numFollowing()
        ],
      );
    } else {
      return Column(
        children: [
          GestureDetector(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * .1,
              child: Icon(Icons.add_a_photo),
              backgroundColor: Colors.red,
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext content) {
                    return _pictureDialog();
                  });
            },
          ),
          _numFollowers(),
          _numFollowing()
        ],
      );
    }
  }

  Widget _postsCreated() {
    if (widget.numPosts == 1) {
      return Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.my_library_books,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext content) {
                      return _postDialog();
                    });
              }),
          Text(
            '${widget.numPosts} post created',
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.my_library_books,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext content) {
                      return _postDialog();
                    });
              }),
          Text(
            '${widget.numPosts} posts created',
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }
  }

  Widget _barsLiked() {
    if (widget.userInfo.numBars == 1) {
      return Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.sports_bar,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyUserLikedType.route,
                    arguments:
                        UserLiked(type: 'bar', user: widget.userInfo.username));
              }),
          Text(
            '${widget.userInfo.numBars} bar liked',
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    } else {
      return Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.sports_bar,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyUserLikedType.route,
                    arguments:
                        UserLiked(type: 'bar', user: widget.userInfo.username));
              }),
          Text(
            '${widget.userInfo.numBars} bars liked',
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    }
  }

  Widget _brandsLiked() {
    if (widget.userInfo.numBrands == 1) {
      return Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.local_bar,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyUserLikedType.route,
                    arguments: UserLiked(
                        type: 'brand', user: widget.userInfo.username));
              }),
          Text(
            '${widget.userInfo.numBrands} brand liked',
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.local_bar,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyUserLikedType.route,
                    arguments: UserLiked(
                        type: 'brand', user: widget.userInfo.username));
              }),
          Text(
            '${widget.userInfo.numBrands} brands liked',
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }
  }

  Widget _drinksLiked() {
    if (widget.userInfo.numDrinks == 1) {
      return Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.local_drink,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyUserLikedType.route,
                    arguments: UserLiked(
                        type: 'drink', user: widget.userInfo.username));
              }),
          Text(
            '${widget.userInfo.numDrinks} drink liked',
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    } else {
      return Column(
        children: [
          IconButton(
              icon: Icon(
                Icons.local_drink,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyUserLikedType.route,
                    arguments: UserLiked(
                        type: 'drink', user: widget.userInfo.username));
              }),
          Text(
            '${widget.userInfo.numDrinks} drinks liked',
            overflow: TextOverflow.ellipsis,
          )
        ],
      );
    }
  }

  Widget _numFollowers() {
    return TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            MyFollower.route,
            arguments: widget.userInfo.username,
          );
        },
        child: Column(
          children: [
            Text(
              '${widget.userInfo.numFollowers}',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'Followers',
              style: TextStyle(color: Colors.black),
            )
          ],
        ));
  }

  Widget _numFollowing() {
    return TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            MyFollowing.route,
            arguments: widget.userInfo.username,
          );
        },
        child: Column(
          children: [
            Text(
              '${widget.userInfo.numFollowing}',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'Following',
              style: TextStyle(color: Colors.black),
            )
          ],
        ));
  }

  Widget _infoOnUser() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext content) {
                return _deleteDialog();
              },
            );
          },
          child: Text('Delete Account'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)))),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _postsCreated(),
              VerticalDivider(),
              _barsLiked(),
            ],
          ),
        ),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _brandsLiked(),
            VerticalDivider(),
            _drinksLiked(),
          ],
        ))
      ],
    );
  }

  Widget _userFullName() {
    if (editName) {
      return Row(
        children: [
          VerticalDivider(),
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                  ),
                  //border: OutlineInputBorder(),
                  labelText: 'First Name',
                  labelStyle: TextStyle(
                      color: Colors.black, fontFamily: 'Merriweather-Bold')),
              onChanged: (String value) {
                newFirstName = value;
              },
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Merriweather-Bold'),
            ),
          ),
          VerticalDivider(),
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                  ),
                  //border: OutlineInputBorder(),
                  labelText: 'Last Name',
                  labelStyle: TextStyle(
                      color: Colors.black, fontFamily: 'Merriweather-Bold')),
              onChanged: (String value) {
                newLastName = value;
              },
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Merriweather-Bold'),
            ),
          ),
          IconButton(
            onPressed: () {
              if (mounted) {
                setState(() {
                  editName = false;
                  newFirstName = null;
                  newLastName = null;
                });
              }
            },
            icon: Icon(Icons.cancel),
            tooltip: 'Cancel Edit',
            color: Colors.red,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              updateUserName(newFirstName, newLastName);
            },
            color: Colors.red,
            tooltip: 'Save',
          ),
        ],
      );
    } else
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${widget.userInfo.fullName}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Merriweather-Bold',
                fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (mounted) {
                setState(() {
                  editName = true;
                });
              }
            },
            color: Colors.red,
            tooltip: 'Edit Name',
          ),
        ],
      );
  }

  Widget _userBio() {
    if (widget.userInfo.bio != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${widget.userInfo.bio}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Merriweather-Bold',
                fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (mounted) {
                setState(() {
                  editBio = true;
                });
              }
            },
            color: Colors.red,
            tooltip: 'Edit Bio',
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No bio yet',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Merriweather-Bold',
                fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (mounted) {
                setState(() {
                  editBio = true;
                });
              }
            },
            color: Colors.red,
            tooltip: 'Edit Bio',
          ),
        ],
      );
    }
  }

  Widget _editUserBio() {
    if (editBio) {
      return Row(
        children: [
          VerticalDivider(),
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                  ),
                  //border: OutlineInputBorder(),
                  labelText: 'Bio',
                  labelStyle: TextStyle(
                      color: Colors.black, fontFamily: 'Merriweather-Bold')),
              onChanged: (String value) {
                newBio = value;
              },
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Merriweather-Bold'),
            ),
          ),
          IconButton(
            onPressed: () {
              if (mounted) {
                setState(() {
                  editBio = false;
                  newBio = null;
                });
              }
            },
            icon: Icon(Icons.cancel),
            tooltip: 'Cancel Edit',
            color: Colors.red,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              updateBio(newBio);
            },
            color: Colors.red,
            tooltip: 'Save',
          ),
        ],
      );
    } else {
      return _userBio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatar(),
            _infoOnUser(),
          ],
        ),
        Divider(
          color: Colors.black,
          thickness: 2,
        ),
        _userFullName(),
        Divider(
          color: Colors.black,
          thickness: 2,
        ),
        _editUserBio(),
        Divider(
          color: Colors.black,
          thickness: 2,
        )
      ],
    );
  }
}
