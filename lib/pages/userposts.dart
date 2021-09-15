import 'package:flutter/material.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/widget/navbarlocation.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/feedpostcard.dart';
import 'package:NewApp/services/userservice.dart';
import 'package:NewApp/widget/userprofile.dart';
import 'package:NewApp/widget/userfilter.dart';

class UserPosts extends StatefulWidget {
  UserPosts(this.user, this.myUser);
  final String user;
  final String myUser;
  static const route = '/userposts';

  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  Future<dynamic>? posts;
  final postService = new PostService();
  Future<dynamic>? userInfo;
  final userService = new UserService();

  getUserPosts(String user, [int? offset]) async {
    var response;
    if (offset != null) {
      try {
        response = await postService.getUserPosts(user, offset);
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
        response = await postService.getUserPosts(user);
        totalPosts = response[0];
      } catch (e) {
        print(e);
        final snackBar = SnackBar(
            content: Text(
                'Error: could not retrieve posts. Check network connection.',
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

  getUserInfo(String user) async {
    try {
      var response;
      response = await userService.getUser(user, widget.myUser);
      return response;
    } catch (e) {
      final snackBar = SnackBar(
          content: Text(
              'Error: could not retrieve user info. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e);
    }
  }

  Widget userPosts() {
    Iterable<Future<dynamic>> futures = [posts!, userInfo!];
    return FutureBuilder(
        future: Future.wait(futures),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var items = snapshot.data![0];
            if (snapshot.data![1] == null) {
              return Expanded(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    Text(
                      'This user does not exist',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * .035,
                          decoration: TextDecoration.underline),
                    ),
                    Expanded(
                        child: Image(
                            image: AssetImage('assets/img/city_page.jpg'),
                            height: MediaQuery.of(context).size.height * .4)),
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                  ],
                ),
              );
            } else if (items.length == 0) {
              var userInfo = snapshot.data![1];
              return Expanded(
                child: Column(
                  children: [
                    UserProfile(userInfo, widget.myUser, totalPosts),
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    Text(
                      'This user has not made a post yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * .035,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .1)
                  ],
                ),
              );
            } else {
              var userInfo = snapshot.data![1];
              return Expanded(
                child: Scrollbar(
                  child: RefreshIndicator(
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: items.length + 1,
                        itemBuilder: (context, index) {
                          if (index == items.length && index < totalPosts!) {
                            offset++;
                            var newPosts = getUserPosts(widget.user, offset);
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
                          } else if (index == totalPosts) {
                            return Container();
                          }
                          if (index == 0) {
                            return Column(
                              children: [
                                UserProfile(
                                    userInfo, widget.myUser, totalPosts),
                                FeedPostCard(
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
                                )
                              ],
                            );
                          } else {
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
                          }
                        }),
                    onRefresh: () {
                      return getUserPosts(widget.user);
                    },
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Expanded(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                        'There was an error getting the posts or the database is turned off',
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
          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  void initState() {
    super.initState();
    posts = getUserPosts(widget.user);
    userInfo = getUserInfo(widget.user);
  }

  int offset = 1;
  int? totalPosts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserFilter(widget.user),
      body: Column(
        children: [NavBarLoc(), userPosts()],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
