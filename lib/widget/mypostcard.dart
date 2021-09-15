import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:strings/strings.dart';
import 'package:NewApp/pages/singlepost.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/models/postargs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPostCard extends StatefulWidget {
  final String bar;
  final String location;
  final String? username;
  final String content;
  final int rating;
  final String timestamp;
  final String? neighborhood;
  final int numComments;
  final int numLikes;
  final bool anonymous;
  final String? editedAt;
  final String? picLink;
  final String uuid;
  final String? busyness;

  MyPostCard(
    this.bar,
    this.location,
    this.username,
    this.content,
    this.rating,
    this.timestamp,
    this.neighborhood,
    this.numComments,
    this.numLikes,
    this.anonymous,
    this.editedAt,
    this.picLink,
    this.uuid,
    this.busyness,
  );

  @override
  _MyPostCardState createState() => _MyPostCardState();
}

class _MyPostCardState extends State<MyPostCard> {
  final postService = new PostService();
  bool editMode = false;
  String? newBar;
  String? newContent;
  String? newNbhood;
  int? newRating;

  goToEditMode() {
    if (mounted) {
      setState(() {
        editMode = true;
      });
    }
  }

  cancelEdit() {
    if (mounted) {
      setState(() {
        newBar = null;
        dropdownValue = null;
        newContent = null;
        newNbhood = null;
        newRating = null;
        editMode = false;
      });
    }
  }

  editPost() async {
    bool succeed;
    var item = {
      'nbhood': newNbhood,
      'rating': newRating,
      'bar': newBar,
      'description': newContent
    };
    succeed = await postService.updatePost(widget.uuid, item);
    if (succeed) {
      Navigator.pushReplacementNamed(context, '/mypost');
    } else {
      final snackBar = SnackBar(
          content: Text('Error with editing post. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  deletePost() async {
    bool succeed;
    succeed = await postService.deletePost(widget.uuid);
    if (succeed) {
      Navigator.pushReplacementNamed(context, '/mypost');
    } else {
      final snackBar = SnackBar(
          content: Text('Error with deleting post. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  goToSinglePost() async {
    String user = FirebaseAuth.instance.currentUser!.displayName!;
    Navigator.pushReplacementNamed(
      context,
      SinglePost.route,
      arguments: PostArgs(uuid: widget.uuid, currentUser: user),
    );
  }

  Widget picture() {
    if (widget.picLink != '' && widget.picLink != null) {
      return Column(children: [
        Image(
            image: NetworkImage('${widget.picLink}'),
            height: MediaQuery.of(context).size.height * .4),
        const Divider(color: Colors.white, thickness: 1.0)
      ]);
    } else {
      return Container();
    }
  }

  Widget user() {
    if (widget.username != null) {
      return Padding(
        padding: EdgeInsets.only(left: 8),
        child: Text(
          '${widget.username}',
          style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Merriweather-Regular'),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget likes() {
    if (widget.numLikes == 0) {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            'No Likes Yet',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Merriweather-Regular'),
          ));
    } else if (widget.numLikes == 1) {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            '${widget.numLikes} like',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Merriweather-Regular'),
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            '${widget.numLikes} likes',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Merriweather-Regular'),
          ));
    }
  }

  Widget neighborhood() {
    if (widget.neighborhood != null) {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            '${capitalize(widget.neighborhood!)}, ${widget.location}',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Merriweather-Regular',
                fontSize: 16),
            softWrap: true,
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            '${widget.location}',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Merriweather-Regular',
                fontSize: 16),
            softWrap: true,
          ));
    }
  }

  Widget comments() {
    if (widget.numComments == 0) {
      return Text(
        'No comments yet',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather-Regular',
            fontSize: 18),
      );
    } else if (widget.numComments == 1) {
      return Text(
        '${widget.numComments} comment',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather-Regular',
            fontSize: 18),
      );
    } else {
      return Text(
        '${widget.numComments} comments',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather-Regular',
            fontSize: 18),
      );
    }
  }

  Widget busynessLevel() {
    if (widget.busyness != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(
          'Busyness level: ${widget.busyness}',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Merriweather-Regular',
              fontSize: 15),
        ),
      );
    } else {
      return Container();
    }
  }

  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    var newDate = HttpDate.parse(widget.timestamp);
    if (!editMode) {
      return GestureDetector(
        child: Card(
          color: Colors.black,
          child: Column(
            children: [
              // ListTile(
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: Text(
                      capitalize(widget.bar),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Merriweather-Bold',
                          fontSize: 20),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      goToEditMode();
                    },
                    tooltip: 'Edit Post',
                    icon: Icon(Icons.edit, size: 26),
                    color: Colors.red,
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 8, top: 8),
                      child: Text(
                        'User Rating: ${widget.rating}/10',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold',
                            fontSize: 16),
                      ))
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              // ),
              const Divider(color: Colors.white, thickness: 1.0),
              picture(),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Text(
                  widget.content,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Merriweather-Regular',
                      fontSize: 20),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
              busynessLevel(),
              const Divider(color: Colors.white, thickness: 1.0),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  children: [user(), likes()],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              const Divider(color: Colors.black, thickness: 1.0),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        Jiffy(newDate).fromNow(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Italic',
                            fontSize: 14),
                        softWrap: true,
                      ),
                    ),
                    neighborhood()
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              const Divider(color: Colors.white, thickness: 1.0),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [comments()],
                ),
              ),
              const Divider(color: Colors.black, thickness: 1.0),
            ],
          ),
        ),
        onTap: () {
          goToSinglePost();
        },
      );
    } else {
      return Card(
        color: Colors.black,
        child: Column(
          children: [
            // ListTile(
            Row(
              children: [
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.only(top: 8, left: 8),
                      child: TextField(
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            //border: OutlineInputBorder(),
                            labelText: 'Name of bar',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Merriweather-Bold')),
                        onChanged: (String value) {
                          newBar = value;
                        },
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold'),
                      )),
                ),
                IconButton(
                  onPressed: () {
                    cancelEdit();
                  },
                  icon: Icon(Icons.cancel, size: 25),
                  tooltip: 'Cancel Edit',
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text('Rating: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 0),
                    child: DropdownButton(
                      value: dropdownValue == null
                          ? widget.rating.toString()
                          : dropdownValue,
                      dropdownColor: Colors.black,
                      items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                          .map((String value) {
                        return DropdownMenuItem(
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontFamily: 'Merriweather-Regular',
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                            value: value);
                      }).toList(),
                      onChanged: (String? value) {
                        if (mounted) {
                          setState(() {
                            dropdownValue = value;
                            newRating = int.parse(value!);
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: Text('/10',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 16)),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            // ),
            const Divider(color: Colors.white, thickness: 1.0),
            picture(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    //border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.white, fontFamily: 'Merriweather-Bold'),
                    labelText: 'Post description'),
                onChanged: (String value) {
                  newContent = value;
                },
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Bold',
                    fontSize: 18),
              ),
            ),
            const Divider(color: Colors.white, thickness: 1.0),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete, size: 26),
                  onPressed: () {
                    deletePost();
                  },
                  color: Colors.red,
                  tooltip: 'Delete Post',
                ),
                IconButton(
                  icon: Icon(Icons.save, size: 26),
                  onPressed: () {
                    editPost();
                  },
                  color: Colors.red,
                  tooltip: 'Edit Post',
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4, right: 4),
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          //border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather-Bold'),
                          labelText: 'Neighborhood'),
                      onChanged: (String value) {
                        newNbhood = value;
                      },
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Merriweather-Bold'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: Text(
                    ', ${widget.location}',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Merriweather-Bold',
                        fontSize: 16),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            const Divider(color: Colors.black, thickness: 1.0),
          ],
        ),
      );
    }
  }
}
