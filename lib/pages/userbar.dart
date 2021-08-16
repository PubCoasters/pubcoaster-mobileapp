import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/navbarlocation.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/services/userservice.dart';
import 'package:NewApp/widget/userprofile.dart';
import 'package:NewApp/widget/feedpostcard.dart';
import 'package:NewApp/widget/userfilter.dart';

class UserBar extends StatefulWidget {
  UserBar(this.userbar, this.myUser);
  final String userbar;
  final String myUser;
  static String route = '/userbar';
  @override
  _UserBarState createState() => _UserBarState();
}

class _UserBarState extends State<UserBar> {
  String user = '';
  String bar = '';
  Future<dynamic>? posts;
  final postService = new PostService();
  Future<dynamic>? userInfo;
  final userService = new UserService();

  getUserBarPosts(String user, String bar, [int? offset]) async {
    var response;
    if (offset != null) {
      try {
        response = await postService.getUserBarPosts(user, bar, offset);
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
        response = await postService.getUserBarPosts(user, bar);
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
            var userInfo = snapshot.data![1];
            var items = snapshot.data![0];
            if (items.length == 0) {
              return Expanded(
                child: Column(
                  children: [
                    UserProfile(userInfo, widget.myUser, totalPosts),
                    Text(
                      '$user has no posts at ${capitalize(bar)}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Oxygen-Bold'),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Expanded(
                        child: Image(
                            image: AssetImage('assets/img/city_page.jpg'),
                            height: MediaQuery.of(context).size.height * .4)),
                    SizedBox(height: MediaQuery.of(context).size.height * .14)
                  ],
                ),
              );
            } else {
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
                            var newPosts = getUserBarPosts(user, bar, offset);
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
                                Text(
                                  '$user\'s posts at ${capitalize(bar)}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Oxygen-Bold'),
                                ),
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
                                    items[index].uuid)
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
                                items[index].uuid);
                          }
                        }),
                    onRefresh: () {
                      return getUserBarPosts(user, bar);
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
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null &&
              snapshot.error == null) {
            return Expanded(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                        'The database does not seem to be turned on, try again when it is',
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
    user = widget.userbar.split('-')[0];
    bar = widget.userbar.split('-')[1];
    posts = getUserBarPosts(user, bar);
    userInfo = getUserInfo(user);
  }

  int offset = 1;
  int? totalPosts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserFilter(user),
      body: Column(
        children: [
          NavBarLoc(),
          userPosts(),
        ],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
