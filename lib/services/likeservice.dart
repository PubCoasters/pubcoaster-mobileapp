import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:async';

class LikeService {
  Future<bool> addLike(item) async {
    String path = '/like/${item['uuid']}';
    var endpoint = Uri.https('${Config.postApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'username': item['username']
    };

    bool succeed = true;
    var content;

    try {
      content = await http.post(endpoint, headers: headers);
    } catch (e) {
      print(e);
      succeed = false;
    }

    if (content == null || content.statusCode == 500) {
      succeed = false;
    }

    return succeed;
  }

  Future<bool> deleteLike(item) async {
    String path = '/like/${item['uuid']}';
    var endpoint = Uri.https('${Config.postApiUrl}', path);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'username': item['username']
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
}
