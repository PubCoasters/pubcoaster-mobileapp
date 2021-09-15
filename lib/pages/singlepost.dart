import 'package:flutter/material.dart';
import 'package:NewApp/services/postservice.dart';
import 'package:NewApp/widget/navbarhome.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/widget/singlepostcard.dart';
import 'package:NewApp/widget/bottomnav.dart';

class SinglePost extends StatefulWidget {
  final String uuid;
  final String currentUser;
  SinglePost(this.uuid, this.currentUser);
  static const route = '/singlepost';

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  Future<dynamic>? post;
  final postService = new PostService();

  getSinglePost(String uuid) async {
    var response;
    try {
      response = await postService.getPost(uuid);
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
          content: Text('Error: could retrieve post. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    post = getSinglePost(widget.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        SingleChildScrollView(
          child: Column(
            children: [
              NavBar(),
              FutureBuilder(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var item = snapshot.data as dynamic;
                      return SinglePostCard(
                          item.bar,
                          item.location,
                          item.createdBy,
                          item.rating,
                          item.createdAt,
                          item.neighborhood,
                          item.editedAt,
                          item.picLink,
                          item.uuid,
                          item.busyness,
                          item.description,
                          item.anonymous,
                          item.comments,
                          item.likes,
                          widget.currentUser);
                    } else if (snapshot.hasError) {
                      return Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .1),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text('There was an error getting the post',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30)),
                            ),
                            Expanded(
                                child: Image(
                                    image:
                                        AssetImage('assets/img/city_page.jpg'),
                                    height: MediaQuery.of(context).size.height *
                                        .4)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .14)
                          ],
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  })
            ],
          ),
        ),
      ]),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
