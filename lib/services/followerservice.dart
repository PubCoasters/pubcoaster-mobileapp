import 'package:NewApp/models/feedpost.dart';
import 'package:NewApp/models/follower.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'config.dart';

List<Follower> parseFollower(dataItems) {
  var response =
      dataItems.map<Follower>((json) => Follower.fromJson(json)).toList();
  return response;
}

List<FeedPost> parseFeedPosts(dataItems) {
  var response =
      dataItems.map<FeedPost>((json) => FeedPost.fromJson(json)).toList();
  return response;
}

class FollowerService {
  Future<bool> createFollowing(String follower, String following) async {
    var endpoint = Uri.https('${Config.followerApiUrl}', '/follower');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var reqBody = {'follower': follower, 'following': following};
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    bool succeed;
    var content;

    try {
      content = await http.post(endpoint,
          headers: headers, body: jsonEncode(reqBody));
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> deleteFollowing(String follower, String following) async {
    var endpoint = Uri.https('${Config.followerApiUrl}', '/follower');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var reqBody = {'follower': follower, 'following': following};
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    bool succeed;
    var content;
    try {
      content = await http.delete(endpoint,
          headers: headers, body: jsonEncode(reqBody));
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<List<Follower>> getFollowers(String user, [int? page]) async {
    var endpoint = Uri.https('${Config.followerApiUrl}', '/allfollowers');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'user': user
    };
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.followerApiUrl}', '/allfollowers', params);
    }
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    return compute(parseFollower, json.decode(response.body));
  }

  Future<List<Follower>> getFollowing(String user, [int? page]) async {
    var endpoint = Uri.https('${Config.followerApiUrl}', '/allfollowing');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'user': user
    };
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.followerApiUrl}', '/allfollowing', params);
    }
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    return compute(parseFollower, json.decode(response.body));
  }

  Future<List<Follower>> getUserFollowers(String user, String myUser,
      [int? page]) async {
    String path = 'userfollowers/$user';
    var endpoint = Uri.https('${Config.followerApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'user': myUser
    };
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.followerApiUrl}', path, params);
    }
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    return compute(parseFollower, json.decode(response.body));
  }

  Future<List<Follower>> getUserFollowing(String user, String myUser,
      [int? page]) async {
    String path = 'userfollowing/$user';
    var endpoint = Uri.https('${Config.followerApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'user': myUser
    };
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.followerApiUrl}', path, params);
    }
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    return compute(parseFollower, json.decode(response.body));
  }

  Future<List<dynamic>> getFeedPosts(String user, [int? page]) async {
    var endpoint = Uri.https('${Config.followerApiUrl}', '/followingposts');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'user': user
    };
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint =
          Uri.https('${Config.followerApiUrl}', '/followingposts', params);
    }
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var responseBody = json.decode(response.body);
    return [
      responseBody['totalCount'],
      compute(parseFeedPosts, responseBody['posts'])
    ];
  }
}
