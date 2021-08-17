import 'package:flutter/material.dart';
import 'package:NewApp/models/userlikedargs.dart';
import 'package:NewApp/pages/userlikedtype.dart';
import 'package:NewApp/services/followerservice.dart';
import 'package:NewApp/pages/userfollower.dart';
import 'package:NewApp/pages/userfollowing.dart';
import 'package:NewApp/models/userpagesargs.dart';

class UserProfile extends StatefulWidget {
  UserProfile(this.userInfo, this.myUser, this.numPosts);
  final userInfo;
  final String? myUser;
  final int? numPosts;
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final followerService = new FollowerService();
  bool? follow;
  int? numFollowers;

  createFollow() async {
    try {
      bool succeed = await followerService.createFollowing(
          widget.myUser!, widget.userInfo.username);
      if (succeed) {
        if (mounted) {
          setState(() {
            follow = true;
            numFollowers = numFollowers! + 1;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  deleteFollow() async {
    try {
      bool succeed = await followerService.deleteFollowing(
          widget.myUser!, widget.userInfo.username);
      if (succeed) {
        if (mounted) {
          setState(() {
            follow = false;
            numFollowers = numFollowers! - 1;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _postDialog() {
    return AlertDialog(
      title: Text(
        'Just look down the screen bro',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 23,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _avatar() {
    if (widget.userInfo.picLink != null) {
      return Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.userInfo.picLink),
            radius: MediaQuery.of(context).size.width * .1,
          ),
          _numFollowers(),
          _numFollowing()
        ],
      );
    } else {
      return Column(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * .1,
            child: Icon(Icons.no_photography),
            backgroundColor: Colors.red,
          ),
          _numFollowers(),
          _numFollowing()
        ],
      );
    }
  }

  Widget _numFollowers() {
    return TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            UserFollower.route,
            arguments: UserPages(
                user: widget.userInfo.username, myUser: widget.myUser!),
          );
        },
        child: Column(
          children: [
            Text(
              '$numFollowers',
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
            UserFollowing.route,
            arguments: UserPages(
                user: widget.userInfo.username, myUser: widget.myUser!),
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
                Navigator.pushReplacementNamed(context, UserLikedType.route,
                    arguments:
                        UserLiked(type: 'bar', user: widget.userInfo.username));
              }),
          Text('${widget.userInfo.numBars} bar liked')
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
                Navigator.pushReplacementNamed(context, UserLikedType.route,
                    arguments:
                        UserLiked(type: 'bar', user: widget.userInfo.username));
              }),
          Text('${widget.userInfo.numBars} bars liked')
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
                Navigator.pushReplacementNamed(context, UserLikedType.route,
                    arguments: UserLiked(
                        type: 'brand', user: widget.userInfo.username));
              }),
          Text('${widget.userInfo.numBrands} brand liked'),
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
                Navigator.pushReplacementNamed(context, UserLikedType.route,
                    arguments: UserLiked(
                        type: 'brand', user: widget.userInfo.username));
              }),
          Text('${widget.userInfo.numBrands} brands liked'),
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
                Navigator.pushReplacementNamed(context, UserLikedType.route,
                    arguments: UserLiked(
                        type: 'drink', user: widget.userInfo.username));
              }),
          Text('${widget.userInfo.numDrinks} drink liked')
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
                Navigator.pushReplacementNamed(context, UserLikedType.route,
                    arguments: UserLiked(
                        type: 'drink', user: widget.userInfo.username));
              }),
          Text('${widget.userInfo.numDrinks} drinks liked')
        ],
      );
    }
  }

  Widget _followButton() {
    if (follow == null) {
      return Container();
    } else if (follow!) {
      return ElevatedButton(
        onPressed: () {
          deleteFollow();
        },
        child: Text('Unfollow'),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)))),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          createFollow();
        },
        child: Text('Follow'),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)))),
      );
    }
  }

  Widget _infoOnUser() {
    return Column(
      children: [
        _followButton(),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_postsCreated(), VerticalDivider(), _barsLiked()],
          ),
        ),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_brandsLiked(), VerticalDivider(), _drinksLiked()],
        ))
      ],
    );
  }

  Widget _userFullName() {
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
          Text('${widget.numPosts} post created'),
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
          Text('${widget.numPosts} posts created'),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    follow = widget.userInfo.following;
    numFollowers = widget.userInfo.numFollowers;
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
        _userBio(),
        Divider(
          color: Colors.black,
          thickness: 2,
        )
      ],
    );
  }
}
