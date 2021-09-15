import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:NewApp/services/followerservice.dart';
import 'package:NewApp/widget/navbarhome.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/feedpostcard.dart';
import 'package:NewApp/pages/searchbusybarfromfeed.dart';

class FeedPostPage extends StatefulWidget {
  FeedPostPage(this.user);
  final String user;
  static const route = '/feedpostpage';
  @override
  _FeedPostPageState createState() => _FeedPostPageState();
}

class _FeedPostPageState extends State<FeedPostPage> {
  Future<dynamic>? posts;
  final followerService = new FollowerService();
  getFeedPosts([int? offset]) async {
    var response;
    if (offset != null) {
      try {
        response = await followerService.getFeedPosts(widget.user, offset);
        totalPosts = response[0];
      } catch (e) {
        print(e);
        final snackBar = SnackBar(
            content: Text(
                'Error: could retrieve posts. Check network connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      try {
        response = await followerService.getFeedPosts(widget.user);
        totalPosts = response[0];
      } catch (e) {
        print(e);
        final snackBar = SnackBar(
            content: Text(
                'Error: could retrieve posts. Check network connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    return response[1];
  }

  goToSearchBusyBar() {
    Navigator.pushReplacementNamed(context, SearchBusyBarFromFeed.route);
  }

  Widget _displayPosts() {
    return FutureBuilder(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var items = snapshot.data as List<dynamic>;
          if (items.length == 0) {
            return _noPosts();
          } else {
            return Expanded(
              child: Column(
                children: [
                  _pageTitle(),
                  Expanded(
                    child: Scrollbar(
                      child: RefreshIndicator(
                        child: _feed(items),
                        onRefresh: () {
                          return getFeedPosts();
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          return _error();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _feed(items) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length && index < totalPosts!) {
          offset++;
          var newPosts = getFeedPosts(offset);
          newPosts.then((posts) {
            if (posts != null) {
              if (mounted) {
                setState(() {
                  items.addAll(posts);
                });
              }
            }
          });
          return IntrinsicWidth(
            child: CircularProgressIndicator(),
          );
        } else if (index == totalPosts!) {
          return Container();
        }
        return FeedPostCard(
          items[index].bar,
          items[index].location,
          items[index].createdBy,
          items[index].description,
          items[index].rating,
          items[index].createdAt,
          items[index].neighborhood,
          items[index].numComments,
          items[index].numLikes,
          items[index].anonymous,
          items[index].editedAt,
          items[index].picLink,
          items[index].uuid,
          items[index].busyness,
        );
      },
    );
  }

  Widget _pageTitle() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Your Feed',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontFamily: 'Oxygen-Bold'),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            goToSearchBusyBar();
          },
          icon: Icon(Icons.bar_chart_rounded),
          iconSize: MediaQuery.of(context).size.height * .075,
          tooltip: 'See how busy bars in different areas are',
          color: Colors.red,
        )
      ],
    );
  }

  Widget _noPosts() {
    return Expanded(
        child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * .1),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text('No posts on your feed yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        decoration: TextDecoration.underline)),
              ),
            ),
            IconButton(
              onPressed: () {
                goToSearchBusyBar();
              },
              icon: Icon(Icons.bar_chart_rounded),
              iconSize: MediaQuery.of(context).size.height * .075,
              tooltip: 'See how busy bars in different areas are',
              color: Colors.red,
            )
          ],
        ),
        Expanded(
            child: Image(
                image: AssetImage('assets/img/city_page.jpg'),
                height: MediaQuery.of(context).size.height * .4)),
        SizedBox(height: MediaQuery.of(context).size.height * .14)
      ],
    ));
  }

  Widget _error() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .1),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text('There was an error getting the posts',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    decoration: TextDecoration.underline)),
          ),
          Expanded(
              child: Image(
                  image: AssetImage('assets/img/city_page.jpg'),
                  height: MediaQuery.of(context).size.height * .4)),
          SizedBox(height: MediaQuery.of(context).size.height * .14)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    posts = getFeedPosts();
  }

  int offset = 1;
  int? totalPosts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavBar(),
          _displayPosts(),
        ],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
