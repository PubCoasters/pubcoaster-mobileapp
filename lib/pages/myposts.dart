import 'package:flutter/material.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/widget/navbarhome.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/mypostcard.dart';
import 'package:NewApp/services/userservice.dart';
import 'package:NewApp/widget/myuserprofile.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  Future<dynamic>? posts;
  Future<dynamic>? userInfo;
  final postService = new PostService();
  final userService = new UserService();

  getUserInfo() async {
    var response;
    try {
      response = await userService.getMyUser();
      return response;
    } catch (e) {
      print(e);
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
    }
  }

  getMyPosts([int? offset]) async {
    var response;
    if (offset != null) {
      try {
        response = await postService.getMyPosts(offset);
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
    } else {
      try {
        response = await postService.getMyPosts();
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

  Widget myPosts() {
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
                    MyUserProfile(userInfo, totalPosts),
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    Text(
                      'You have not made a post yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * .035,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .1)
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
                          var newPosts = getMyPosts(offset);
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
                              MyUserProfile(userInfo, totalPosts),
                              MyPostCard(
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
                          return MyPostCard(
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
                      },
                    ),
                    onRefresh: () {
                      return getMyPosts();
                    },
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Expanded(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                        'There was an error getting the posts and user information or the database is turned off',
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
    posts = getMyPosts();
    userInfo = getUserInfo();
  }

  int offset = 1;
  int? totalPosts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [NavBar(), myPosts()],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
