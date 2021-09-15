import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:async';
import 'package:NewApp/models/user.dart';
import 'package:NewApp/models/userbar.dart';
import 'package:NewApp/models/userbrand.dart';
import 'package:NewApp/models/userdrink.dart';
import 'package:flutter/foundation.dart';

ProfUser parseUser(dataItem) {
  var response = ProfUser.fromJson(dataItem);
  return response;
}

List<UserBar> parseUserBar(dataItems) {
  var response =
      dataItems.map<UserBar>((json) => UserBar.fromJson(json)).toList();
  return response;
}

List<UserBrand> parseUserBrand(dataItems) {
  var response =
      dataItems.map<UserBrand>((json) => UserBrand.fromJson(json)).toList();
  return response;
}

List<UserDrink> parseUserDrink(dataItems) {
  var response =
      dataItems.map<UserDrink>((json) => UserDrink.fromJson(json)).toList();
  return response;
}

class UserService {
  Future<bool> createUser(body) async {
    String path = '/user';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var reqBody = {
      'username': body['username'],
      'email': body['email'],
      'firstName': body['firstName'],
      'lastName': body['lastName'],
      'fullName': body['fullName'],
      'picLink': body['picLink']
    };
    bool succeed = true;
    var content;

    try {
      content = await http.post(endpoint,
          headers: headers, body: jsonEncode(reqBody));
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> deleteUser(username) async {
    String path = '/user/$username';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    bool succeed = true;
    var content;

    try {
      content = await http.delete(endpoint, headers: headers);
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> updateUser(body, username) async {
    String path = '/user/$username';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var reqBody = {
      'bio': body['bio'],
      'email': body['email'],
      'firstName': body['firstName'],
      'lastName': body['lastName'],
      'fullName': body['fullName'],
      'picLink': body['picLink']
    };
    bool succeed = true;
    var content;
    try {
      content = await http.patch(endpoint,
          headers: headers, body: jsonEncode(reqBody));
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<ProfUser?> getUser(username, myUser) async {
    String path = '/searchuser/$username';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'user': myUser
    };
    var response;
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var responseBody = json.decode(response.body);
    if (responseBody['message'] == 'No user exists by that username') {
      return null;
    }
    return compute(parseUser, responseBody);
  }

  Future<ProfUser> getMyUser() async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String user = FirebaseAuth.instance.currentUser!.displayName!;
    String path = '/user/$user';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
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
    return compute(parseUser, json.decode(response.body));
  }

  Future<dynamic> getUserBar(username, [page]) async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String path = '/bar/$username';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.userApiUrl}', path, params);
    }
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
    var responseBody = json.decode(response.body);
    return compute(parseUserBar, responseBody['bars']);
  }

  Future<dynamic> getUserBrand(username, [page]) async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String path = '/brand/$username';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.userApiUrl}', path, params);
    }
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

    var responseBody = json.decode(response.body);
    return compute(parseUserBrand, responseBody['brands']);
  }

  Future<dynamic> getUserDrink(username, [page]) async {
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    String path = '/drink/$username';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    if (page != null && page > 1) {
      var params = {'offset': page.toString()};
      endpoint = Uri.https('${Config.userApiUrl}', path, params);
    }
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
    var responseBody = json.decode(response.body);
    return compute(parseUserDrink, responseBody['drinks']);
  }

  Future<bool> createUserBar(body) async {
    String path = '/user/bar';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var reqBody = {
      'username': body['username'],
      'bar': body['bar'],
      'location': body['location'],
      'neighborhood': body['neighborhood']
    };
    bool succeed = true;
    var content;

    try {
      content = await http.post(endpoint,
          headers: headers, body: jsonEncode(reqBody));
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> createUserBrand(body) async {
    String path = '/user/brand';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var reqBody = {
      'username': body['username'],
      'brand': body['brand'],
      'type': body['type']
    };
    bool succeed = true;
    var content;

    try {
      content = await http.post(endpoint,
          headers: headers, body: jsonEncode(reqBody));
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> createUserDrink(body) async {
    String path = '/user/drink';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var reqBody = {'username': body['username'], 'drink': body['drink']};
    bool succeed = true;
    var content;

    try {
      content = await http.post(endpoint,
          headers: headers, body: jsonEncode(reqBody));
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> deleteUserBar(body) async {
    String path = '/user/bar';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    bool succeed = true;
    var content;

    var reqBody = {'username': body['username'], 'uuid': body['uuid']};

    try {
      content = await http.delete(endpoint,
          headers: headers, body: jsonEncode(reqBody));
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> deleteUserBrand(body) async {
    String path = '/user/brand';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    bool succeed = true;
    var content;
    var reqBody = {'username': body['username'], 'uuid': body['uuid']};

    try {
      content = await http.delete(endpoint,
          headers: headers, body: jsonEncode(reqBody));
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> deleteUserDrink(body) async {
    String path = '/user/drink';
    var endpoint = Uri.https('${Config.userApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    bool succeed = true;
    var content;

    var reqBody = {'username': body['username'], 'uuid': body['uuid']};
    try {
      content = await http.delete(endpoint,
          headers: headers, body: jsonEncode(reqBody));
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }
}
