import 'package:NewApp/models/userlikedargs.dart';
import 'package:flutter/material.dart';
import 'package:NewApp/pages/home.dart';
import 'package:NewApp/pages/splashscreen.dart';
import 'package:NewApp/pages/createpost.dart';
import 'package:NewApp/pages/myposts.dart';
import 'package:NewApp/pages/signup.dart';
import 'package:NewApp/pages/signin.dart';
import 'package:NewApp/pages/forgotpassword.dart';
import 'package:NewApp/pages/locationposts.dart';
import 'package:NewApp/pages/locbarposts.dart';
import 'package:NewApp/pages/locnbhoodposts.dart';
import 'package:NewApp/pages/locuserposts.dart';
import 'package:NewApp/pages/singlepost.dart';
import 'package:NewApp/pages/verifyemail.dart';
import 'package:NewApp/pages/adduserinfo.dart';
import 'package:NewApp/pages/userposts.dart';
import 'package:NewApp/models/postargs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:NewApp/pages/landpage.dart';
import 'package:NewApp/pages/userbar.dart';
import 'package:NewApp/pages/userlocation.dart';
import 'package:NewApp/pages/usernbhood.dart';
import 'package:NewApp/pages/userlikedtype.dart';
import 'package:NewApp/pages/myuserlikedtype.dart';
import 'package:NewApp/pages/createuserliked.dart';
import 'package:NewApp/pages/allusertypes.dart';
import 'package:NewApp/pages/typebyname.dart';
import 'package:NewApp/pages/feedpostpage.dart';
import 'package:NewApp/pages/myfollower.dart';
import 'package:NewApp/pages/myfollowing.dart';
import 'package:NewApp/pages/userfollower.dart';
import 'package:NewApp/pages/userfollowing.dart';
import 'package:NewApp/pages/searchbusybar.dart';
import 'package:NewApp/pages/searchbusybarfromfeed.dart';
import 'package:NewApp/pages/feedback.dart';
import 'package:NewApp/models/feedbackargs.dart';
import 'package:NewApp/models/userpagesargs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return LandPage('error');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'PubCoasters',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                fontFamily: 'CrimsonText-Bold',
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: '/',
              routes: {
                '/': (context) => SplashScreen(),
                '/createpost': (context) => CreatePost(),
                '/signup': (context) => SignUp(),
                '/forgot': (context) => ForgotPassword(),
                '/signin': (context) => SignIn(),
                '/verifyemail': (context) => VerifyEmail(),
                '/adduserinfo': (context) => AddUserInfo(),
                '/home': (context) => Home(),
                '/mypost': (context) => MyPosts(),
                SearchBusyBarFromFeed.route: (context) =>
                    SearchBusyBarFromFeed(),
              },
              onGenerateRoute: (RouteSettings settings) {
                //single post scenario
                if (settings.name == SinglePost.route) {
                  final PostArgs args = settings.arguments as PostArgs;
                  return MaterialPageRoute(builder: (context) {
                    return SinglePost(args.uuid, args.currentUser);
                  });
                } else if (settings.name == UserLikedType.route) {
                  final UserLiked args = settings.arguments as UserLiked;
                  return MaterialPageRoute(builder: (context) {
                    return UserLikedType(args.type, args.user);
                  });
                } else if (settings.name == MyUserLikedType.route) {
                  final UserLiked args = settings.arguments as UserLiked;
                  return MaterialPageRoute(builder: (context) {
                    return MyUserLikedType(args.type, args.user);
                  });
                } else if (settings.name == CreateUserLiked.route) {
                  final UserLiked args = settings.arguments as UserLiked;
                  return MaterialPageRoute(builder: (context) {
                    return CreateUserLiked(args.type, args.user);
                  });
                } else if (settings.name == AllUserTypes.route) {
                  final UserLiked args = settings.arguments as UserLiked;
                  return MaterialPageRoute(builder: (context) {
                    return AllUserTypes(args.type, args.user);
                  });
                } else if (settings.name == TypeByName.route) {
                  final UserLiked args = settings.arguments as UserLiked;
                  return MaterialPageRoute(builder: (context) {
                    return TypeByName(args.type, args.user, args.search!);
                  });
                } else if (settings.name == UserPosts.route) {
                  final UserPages args = settings.arguments as UserPages;
                  return MaterialPageRoute(builder: (context) {
                    return UserPosts(args.user, args.myUser);
                  });
                } else if (settings.name == UserLocation.route) {
                  final UserPages args = settings.arguments as UserPages;
                  return MaterialPageRoute(builder: (context) {
                    return UserLocation(args.user, args.myUser);
                  });
                } else if (settings.name == UserBar.route) {
                  final UserPages args = settings.arguments as UserPages;
                  return MaterialPageRoute(builder: (context) {
                    return UserBar(args.user, args.myUser);
                  });
                } else if (settings.name == UserNbhood.route) {
                  final UserPages args = settings.arguments as UserPages;
                  return MaterialPageRoute(builder: (context) {
                    return UserNbhood(args.user, args.myUser);
                  });
                } else if (settings.name == UserFollower.route) {
                  final UserPages args = settings.arguments as UserPages;
                  return MaterialPageRoute(builder: (context) {
                    return UserFollower(args.user, args.myUser);
                  });
                } else if (settings.name == UserFollowing.route) {
                  final UserPages args = settings.arguments as UserPages;
                  return MaterialPageRoute(builder: (context) {
                    return UserFollowing(args.user, args.myUser);
                  });
                } else if (settings.name == FeedBack.route) {
                  return MaterialPageRoute(builder: (context) {
                    final FeedBackArgs args =
                        settings.arguments as FeedBackArgs;
                    return FeedBack(args.location, args.bar, args.neighborhood);
                  });
                }
                var routes = <String, WidgetBuilder>{
                  LocationPosts.route: (context) =>
                      LocationPosts(settings.arguments as String),
                  LocBarPosts.route: (context) =>
                      LocBarPosts(settings.arguments as String),
                  LocNbhoodPosts.route: (context) =>
                      LocNbhoodPosts(settings.arguments as String),
                  LocUserPosts.route: (context) =>
                      LocUserPosts(settings.arguments as String),
                  FeedPostPage.route: (context) =>
                      FeedPostPage(settings.arguments as String),
                  MyFollower.route: (context) =>
                      MyFollower(settings.arguments as String),
                  MyFollowing.route: (context) =>
                      MyFollowing(settings.arguments as String),
                  SearchBusyBar.route: (context) =>
                      SearchBusyBar(settings.arguments as String),
                };
                WidgetBuilder builder = routes[settings.name]!;
                return MaterialPageRoute(
                    builder: (context) => builder(context));
              },
            );
          }
          return LandPage('loading');
        });
  }
}
