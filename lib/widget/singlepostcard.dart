import 'dart:io';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/services/commentservice.dart';
import 'package:NewApp/services/likeservice.dart';
import 'package:NewApp/widget/reportpost.dart';

class SinglePostCard extends StatefulWidget {
  final String bar;
  final String location;
  final String? username;
  final int rating;
  final String timestamp;
  final String? neighborhood;
  final String? editedAt;
  final String? picLink;
  final String uuid;
  final String? busyness;
  final bool anonymous;
  final String description;
  final List<dynamic> comments;
  final List<dynamic> likes;
  final String currentUser;

  SinglePostCard(
      this.bar,
      this.location,
      this.username,
      this.rating,
      this.timestamp,
      this.neighborhood,
      this.editedAt,
      this.picLink,
      this.uuid,
      this.busyness,
      this.description,
      this.anonymous,
      this.comments,
      this.likes,
      this.currentUser);

  @override
  _SinglePostCardState createState() => _SinglePostCardState();
}

class _SinglePostCardState extends State<SinglePostCard> {
  String newComment = '';
  bool editCommentVar = false;
  String editCommentUuid = '';
  String newEditComment = '';
  bool userLikedVar = false;
  final postService = new PostService();
  final commentService = new CommentService();
  final likeService = new LikeService();

  @override
  void initState() {
    super.initState();
    userLikedVar = userLiked();
  }

  likePost() async {
    var item = {'username': widget.currentUser, 'uuid': widget.uuid};
    var like = {'username': widget.currentUser, 'like': true};
    bool succeed = await likeService.addLike(item);
    if (succeed) {
      if (mounted) {
        setState(() {
          userLikedVar = true;
          widget.likes.add(like);
        });
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Error liking post. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  unLikePost() async {
    var item = {'username': widget.currentUser, 'uuid': widget.uuid};
    bool succeed = await likeService.deleteLike(item);
    if (succeed) {
      if (mounted) {
        setState(() {
          widget.likes.removeWhere((like) =>
              like['username'] == widget.currentUser && like['like'] == true);
          userLikedVar = false;
        });
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Error unliking post. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  sendComment() async {
    var item = {
      'text': newComment,
      'uuid': widget.uuid,
      'createdBy': widget.currentUser
    };
    var commentResponse = await commentService.addComment(item);
    var comment = {
      'createdAt': commentResponse['createdAt'],
      'text': newComment,
      'createdBy': widget.currentUser,
      'uuid': commentResponse['uuid']
    };
    if (commentResponse != null) {
      setState(() {
        newComment = "";
        widget.comments.insert(0, comment);
      });
    } else {
      final snackBar = SnackBar(
          content: Text(
              'Error with creating comment. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  editComment(uuid) async {
    if (mounted) {
      setState(() {
        editCommentUuid = uuid;
        editCommentVar = true;
      });
    }
  }

  deleteComment(index, uuid) async {
    bool succeed = await commentService.deleteComment(uuid);
    if (succeed) {
      if (mounted) {
        setState(() {
          widget.comments.removeWhere((comment) => comment['uuid'] == uuid);
        });
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Error with deleting comment. Check network connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  saveComment(uuid) async {
    var item = {
      'text': newEditComment,
    };
    bool succeed = await commentService.updateComment(uuid, item);
    if (succeed) {
      var comment = widget.comments.firstWhere(
        (comment) => comment['uuid'] == uuid,
        orElse: () => '',
      );
      if (mounted && comment != '') {
        setState(() {
          comment['text'] = newEditComment;
          editCommentVar = false;
          editCommentUuid = "";
          newEditComment = "";
        });
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Error udpating comment. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  cancelComment() {
    if (mounted) {
      setState(() {
        editCommentVar = false;
        editCommentUuid = "";
        newEditComment = "";
      });
    }
  }

  bool userLiked() {
    bool liked = false;
    var found = widget.likes.firstWhere(
      (like) => like['username'] == widget.currentUser,
      orElse: () => '',
    );
    if (found != '') {
      liked = true;
    }
    return liked;
  }

  Widget likesIcon() {
    return IconButton(
      icon: Icon(Icons.favorite, color: Colors.red),
      onPressed: () {
        unLikePost();
      },
    );
  }

  Widget notlikedIcon() {
    return IconButton(
      icon: Icon(Icons.favorite_border, color: Colors.white),
      onPressed: () {
        likePost();
      },
    );
  }

  Widget picture() {
    if (widget.picLink != '' && widget.picLink != null) {
      return Column(children: [
        Image(
            image: NetworkImage('${widget.picLink}'),
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width * .8),
        const Divider(
          thickness: 1,
          color: Colors.white,
        )
      ]);
    } else {
      return Container();
    }
  }

  Widget user() {
    if (widget.username != null) {
      return Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(
          '${widget.username}',
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'Merriweather-Regular'),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget heartIcon() {
    if (userLikedVar) {
      return likesIcon();
    } else {
      return notlikedIcon();
    }
  }

  Widget likes() {
    if (widget.likes.length == 0) {
      return Row(
        children: [
          Padding(
              padding: EdgeInsets.only(right: 2),
              child: Text(
                'No Likes Yet',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular'),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: heartIcon(),
          )
        ],
      );
    } else if (widget.likes.length == 1) {
      return Row(
        children: [
          Padding(
              padding: EdgeInsets.only(right: 2),
              child: Text(
                '${widget.likes.length} like',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular'),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: heartIcon(),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Padding(
              padding: EdgeInsets.only(right: 4),
              child: Text(
                '${widget.likes.length} likes',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular'),
              )),
          heartIcon()
        ],
      );
    }
  }

  Widget neighborhood() {
    if (widget.neighborhood != null) {
      return Padding(
          padding: EdgeInsets.only(right: 6),
          child: Text(
            '${capitalize(widget.neighborhood!)}, ${widget.location}',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Merriweather-Regular',
                fontSize: 18),
            softWrap: true,
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(right: 6),
          child: Text(
            '${widget.location}',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Merriweather-Regular'),
            softWrap: true,
          ));
    }
  }

  Widget comments() {
    if (widget.comments.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No comments yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 18),
              )
            ]),
      );
    } else {
      return ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.all(1),
          itemCount: widget.comments.length,
          itemBuilder: (BuildContext context, int index) {
            var newDate = HttpDate.parse(widget.comments[index]['createdAt']);
            if (editCommentVar == false ||
                editCommentUuid != widget.comments[index]['uuid']) {
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "${widget.comments[index]['createdBy']}: ${widget.comments[index]['text']}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Merriweather-Bold'),
                      ),
                    ),
                    (() {
                      if (widget.currentUser ==
                              widget.comments[index]['createdBy'] &&
                          editCommentVar == false) {
                        //not going to let a user edit multiple comments at once
                        return Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Text(
                                  "   ${Jiffy(newDate).fromNow()}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: 'Merriweather-Regular'),
                                )),
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                ),
                                tooltip: 'Edit Comment',
                                onPressed: () {
                                  editComment(widget.comments[index]['uuid']);
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                tooltip: 'Delete Comment',
                                onPressed: () {
                                  deleteComment(
                                      index, widget.comments[index]['uuid']);
                                }),
                          ],
                        );
                      } else {
                        return Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              "   ${Jiffy(newDate).fromNow()}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Merriweather-Regular'),
                            ));
                      }
                    }()),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TODO: change
                    Flexible(
                      child: Text(
                        "${widget.comments[index]['createdBy']}: ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Merriweather-Bold'),
                      ),
                    ),
                    Row(mainAxisSize: MainAxisSize.max, children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .42,
                        child: TextField(
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              labelText: 'New Comment Text',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                              isDense: true,
                              //contentPadding: EdgeInsets.all(8),
                            ),
                            onChanged: (String value) {
                              newEditComment = value;
                            }),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.save,
                            color: Colors.red,
                          ),
                          tooltip: 'Save new comment',
                          onPressed: () {
                            saveComment(widget.comments[index]['uuid']);
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          tooltip: 'Cancel new comment',
                          onPressed: () {
                            cancelComment();
                          })
                    ])
                  ],
                ),
              );
            }
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: Colors.blueGrey));
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

  @override
  Widget build(BuildContext context) {
    var newDate = HttpDate.parse(widget.timestamp);
    var _controller = TextEditingController();
    return Card(
      color: Colors.black,
      child: Column(
        children: [
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          // ListTile(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  capitalize(widget.bar),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Merriweather-Bold',
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ReportPost(widget.uuid),
                    Text(
                      'User Rating: ${widget.rating}/10',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 15),
                    ),
                  ],
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          // ),
          const Divider(
            thickness: 1,
            color: Colors.white,
          ),
          picture(),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Text(
              widget.description,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Merriweather-Regular',
                  fontSize: 25),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
          busynessLevel(),
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),
          Row(
            children: [user(), likes()],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          const Divider(
            color: Colors.black,
            thickness: .5,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    Jiffy(newDate).fromNow(),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Merriweather-Italic',
                        fontSize: 18),
                    softWrap: true,
                  ),
                ),
                neighborhood()
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),
          comments(),
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Container(
                  width: MediaQuery.of(context).size.width * .82,
                  child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Create Comment',
                        labelStyle: TextStyle(
                            color: Colors.white, fontStyle: FontStyle.italic),
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      onChanged: (String value) {
                        newComment = value;
                      }),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  tooltip: 'Send comment',
                  onPressed: () {
                    sendComment();
                    _controller.clear();
                  })
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          )
        ],
      ),
    );
  }
}
