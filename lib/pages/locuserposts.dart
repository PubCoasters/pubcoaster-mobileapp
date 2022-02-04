import 'package:NewApp/pages/searchbusybar.dart';
import 'package:flutter/material.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/navbarlocation.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/widget/filterDrawer.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/widget/feedpostcard.dart';

class LocUserPosts extends StatefulWidget {
  LocUserPosts(this.locuser);
  final String locuser;
  static const route = '/locuserposts';

  @override
  _LocUserPostsState createState() => _LocUserPostsState();
}

class _LocUserPostsState extends State<LocUserPosts> {
  String location = '';
  String user = '';
  Future<dynamic>? posts;
  final postService = new PostService();

  getLocUserPosts(String loc, String user, [int? offset]) async {
    var response;
    if (offset != null) {
      try {
        response = await postService.getLocUserPosts(location, user, offset);
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
        response = await postService.getLocUserPosts(location, user);
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
    Navigator.pushReplacementNamed(context, SearchBusyBar.route,
        arguments: location);
  }

  @override
  void initState() {
    super.initState();
    location = widget.locuser.split('-')[0];
    user = widget.locuser.split('-')[1];
    posts = getLocUserPosts(location, user);
  }

  int offset = 1;
  int? totalPosts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FilterDrawer(location),
      body: Column(
        children: [
          NavBarLoc(),
          FutureBuilder(
              future: posts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var items = snapshot.data as List<dynamic>;
                  if (items.length == 0) {
                    return Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                    'No posts for $user in $location yet',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        decoration: TextDecoration.underline)),
                              ),
                              IconButton(
                                onPressed: () {
                                  goToSearchBusyBar();
                                },
                                icon: Icon(Icons.bar_chart_rounded),
                                iconSize:
                                    MediaQuery.of(context).size.height * .075,
                                tooltip: 'See how busy bars in $location are',
                                color: Colors.red,
                              )
                            ],
                          ),
                          Expanded(
                              child: Image(
                                  image: AssetImage('assets/img/city_page.jpg'),
                                  height:
                                      MediaQuery.of(context).size.height * .4)),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .14)
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '$user in $location',
                                  style: TextStyle(
                                      fontSize: 25,
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
                              iconSize:
                                  MediaQuery.of(context).size.height * .075,
                              tooltip: 'See how busy bars in $location are',
                              color: Colors.red,
                            )
                          ],
                        ),
                        Expanded(
                          child: Scrollbar(
                              child: RefreshIndicator(
                            child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: items.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == items.length &&
                                      index < totalPosts!) {
                                    offset++;
                                    var newPosts =
                                        getLocUserPosts(location, user, offset);
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
                                }),
                            onRefresh: () {
                              return getLocUserPosts(location, user);
                            },
                          )),
                        )
                      ],
                    ));
                  }
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .1),
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
                                height:
                                    MediaQuery.of(context).size.height * .4)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .14)
                      ],
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data == null &&
                    snapshot.error == null) {
                  return Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .1),
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
                                height:
                                    MediaQuery.of(context).size.height * .4)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .14)
                      ],
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              })
        ],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
