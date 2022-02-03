import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:strings/strings.dart';
import 'package:NewApp/pages/singlepost.dart';
import 'package:NewApp/models/postargs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:NewApp/widget/reportpost.dart';

class FeedPostCard extends StatelessWidget {
  final String bar;
  final String location;
  final String? username;
  final String content;
  final int rating;
  final String timestamp;
  final String? neighborhood;
  final int numComments;
  final int numLikes;
  final bool? anonymous;
  final String? editedAt;
  final String? picLink;
  final String uuid;
  final String? busyness;

  FeedPostCard(
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

  goToSinglePost(context) async {
    String user = FirebaseAuth.instance.currentUser!.displayName!;
    Navigator.pushReplacementNamed(
      context,
      SinglePost.route,
      arguments: PostArgs(uuid: uuid, currentUser: user),
    );
  }

  Widget user(username) {
    if (username != null) {
      return Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(
          '$username',
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

  Widget likes(numLikes) {
    if (numLikes == 0) {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            'No Likes Yet',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Merriweather-Regular'),
          ));
    } else if (numLikes == 1) {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            '$numLikes like',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Merriweather-Regular'),
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            '$numLikes likes',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Merriweather-Regular'),
          ));
    }
  }

  Widget picture(picLink, context) {
    if (picLink != '' && picLink != null) {
      return Column(children: [
        Image(
            image: NetworkImage('$picLink'),
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width * .92),
        const Divider(color: Colors.white, thickness: 1.0)
      ]);
    } else {
      return Container();
    }
  }

  Widget nbhood(neighborhood, location) {
    if (neighborhood != null) {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            '${capitalize(neighborhood)}, $location',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Merriweather-Regular',
                fontSize: 18),
            softWrap: true,
          ));
    } else {
      return Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            '$location',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Merriweather-Regular',
                fontSize: 16),
            softWrap: true,
          ));
    }
  }

  Widget comments(numComments) {
    if (numComments == 0) {
      return Text(
        'No comments yet',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather-Regular',
            fontSize: 18),
      );
    } else if (numComments == 1) {
      return Text(
        '$numComments comment',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather-Regular',
            fontSize: 18),
      );
    } else {
      return Text(
        '$numComments comments',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather-Regular',
            fontSize: 18),
      );
    }
  }

  Widget busynessLevel() {
    if (busyness != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(
          'Busyness level: $busyness',
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
    var newDate = HttpDate.parse(timestamp);
    return GestureDetector(
      child: Card(
        color: Colors.black,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Text(
                    capitalize(bar),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Merriweather-Bold',
                        fontSize: 20),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 8, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ReportPost(this.uuid),
                        Text(
                          'User Rating: $rating/10',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather-Bold',
                              fontSize: 16),
                        ),
                      ],
                    ))
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            // ),
            const Divider(color: Colors.white, thickness: 1.0),
            picture(picLink, context),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                content,
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
                children: [user(username), likes(numLikes)],
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
                  nbhood(neighborhood, location)
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
                children: [comments(numComments)],
              ),
            ),
            const Divider(color: Colors.black, thickness: 1.0),
          ],
        ),
      ),
      onTap: () {
        goToSinglePost(context);
      },
    );
  }
}
