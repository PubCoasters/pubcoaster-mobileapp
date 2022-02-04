import 'package:NewApp/pages/searchbusybar.dart';
import 'package:flutter/material.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/navbarlocation.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/widget/filterDrawer.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/widget/feedpostcard.dart';
import 'package:strings/strings.dart';

class LocNbhoodPosts extends StatefulWidget {
  LocNbhoodPosts(this.locnbhood);
  final String locnbhood;
  static const route = '/locnbhoodposts';

  @override
  _LocNbhoodPostsState createState() => _LocNbhoodPostsState();
}

class _LocNbhoodPostsState extends State<LocNbhoodPosts> {
  String location = '';
  String nbhood = '';
  Future<dynamic>? posts;
  final postService = new PostService();

  getLocNbhoodPosts(String loc, String nbhood, [int? offset]) async {
    var response;
    if (offset != null) {
      try {
        response =
            await postService.getLocNbhoodPosts(location, nbhood, offset);
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
        response = await postService.getLocNbhoodPosts(location, nbhood);
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
    return response;
  }

  goToSearchBusyBar() {
    Navigator.pushReplacementNamed(context, SearchBusyBar.route,
        arguments: location);
  }

  @override
  void initState() {
    super.initState();
    location = widget.locnbhood.split('-')[0];
    nbhood = widget.locnbhood.split('-')[1];
    posts = getLocNbhoodPosts(location, nbhood);
  }

  int offset = 1;
  int itemsLength = 3;
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
                                    'No posts for ${capitalize(nbhood)} in $location yet',
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
                                tooltip: 'See how busy bars in ${location} are',
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
                                  '${capitalize(nbhood)} in $location',
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
                                      items.length < itemsLength) {
                                    return Container();
                                  } else if (index == items.length &&
                                      items.length >= itemsLength) {
                                    offset++;
                                    itemsLength += 3;
                                    var newPosts = getLocNbhoodPosts(
                                        location, nbhood, offset);
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
                              return getLocNbhoodPosts(location, nbhood);
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
