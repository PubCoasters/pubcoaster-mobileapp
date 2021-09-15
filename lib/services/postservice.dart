import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:NewApp/models/feedpost.dart';
import 'package:NewApp/models/singlepost.dart';
import 'package:NewApp/models/mypost.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

List<FeedPost> parseFeedPosts(dataItems) {
  var response =
      dataItems.map<FeedPost>((json) => FeedPost.fromJson(json)).toList();
  return response;
}

SinglePost parseSinglePost(dataItem) {
  var response = SinglePost.fromJson(dataItem);
  return response;
}

List<MyPost> parseMyPosts(dataItems) {
  var response =
      dataItems.map<MyPost>((json) => MyPost.fromJson(json)).toList();
  return response;
}

class PostService {
  Future<bool> addPost(item) async {
    var endpoint = Uri.https('${Config.postApiUrl}', '/post');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var reqBody = {
      'username': item['username'],
      'anonymous': item['anonymous'],
      'location': item['location'],
      'bar': item['bar'],
      'rating': item['rating'],
      'neighborhood': item['nbhood'],
      'description': item['description'],
      'picLink': item['picLink'],
      'busyness': item['busyness'],
    };

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

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> updatePost(String uuid, item) async {
    var endpoint = Uri.https('${Config.postApiUrl}', '/post/$uuid');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var reqBody = {
      'picLink': '',
      'neighborhood': item['nbhood'],
      'rating': item['rating'],
      'bar': item['bar'],
      'description': item['description']
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    bool succeed;
    var content;

    try {
      content = await http.patch(endpoint,
          headers: headers, body: jsonEncode(reqBody));
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> deletePost(String uuid) async {
    var endpoint = Uri.https('${Config.postApiUrl}', '/post/$uuid');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    bool succeed;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var content;

    try {
      content = await http.delete(endpoint, headers: headers);
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<SinglePost> getPost(String uuid) async {
    var endpoint = Uri.https('${Config.postApiUrl}', '/post/$uuid');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    return compute(parseSinglePost, json.decode(response.body));
  }

  Future<List<FeedPost>> getLocationPosts(String location, [int? page]) async {
    String path = '/post/location/$location';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
    }
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    return compute(parseFeedPosts, json.decode(response.body));
  }

  Future<List<FeedPost>> getLocBarPosts(String location, String bar,
      [int? page]) async {
    String path = '/post/locbar/$location/$bar';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
    }
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    return compute(parseFeedPosts, json.decode(response.body));
  }

  Future<List<FeedPost>> getLocNbhoodPosts(String location, String nbhood,
      [int? page]) async {
    String path = '/post/locnbhood/$location/$nbhood';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
    }
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    return compute(parseFeedPosts, json.decode(response.body));
  }

  Future<List<dynamic>> getLocUserPosts(String location, String user,
      [int? page]) async {
    String path = '/post/locuser/$location/$user';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
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

  Future<List<dynamic>> getMyPosts([int? page]) async {
    String path = '/mypost/user';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String user = FirebaseAuth.instance.currentUser!.displayName!;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'username': user
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
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
      compute(parseMyPosts, responseBody['post'])
    ];
  }

  Future<List<dynamic>> getUserPosts(String user, [int? page]) async {
    String path = '/post/user/$user';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
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
      compute(parseFeedPosts, responseBody['post'])
    ];
  }

  Future<List<dynamic>> getUserLocationPosts(String user, String location,
      [int? page]) async {
    String path = '/post/userloc/$user/$location';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
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
      compute(parseFeedPosts, responseBody['post'])
    ];
  }

  Future<List<dynamic>> getUserBarPosts(String user, String bar,
      [int? page]) async {
    String path = '/post/userbar/$user/$bar';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
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
      compute(parseFeedPosts, responseBody['post'])
    ];
  }

  Future<List<dynamic>> getUserNbhoodPosts(String user, String nbhood,
      [int? page]) async {
    String path = '/post/usernbhood/$user/$nbhood';
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var endpoint;
    endpoint = Uri.https('${Config.postApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.postApiUrl}', path, params);
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
      compute(parseFeedPosts, responseBody['post'])
    ];
  }
}
