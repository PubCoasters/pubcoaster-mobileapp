import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'config.dart';
import 'package:NewApp/models/busyness.dart';

Busyness parseResponse(data) {
  var response = Busyness.fromJson(data);
  return response;
}

class BusyService {
  Future<bool> createBusyBar(body) async {
    var endpoint = Uri.https('${Config.busyApiUrl}', '/barbusyness');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    bool succeed;
    var content;

    try {
      content = await http.post(
        endpoint,
        headers: headers,
        body: jsonEncode(body),
      );
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

  Future<Busyness> getLiveBusyness(body) async {
    var endpoint = Uri.https('${Config.busyApiUrl}', '/live/barbusyness');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response;
    try {
      response = await http.post(
        endpoint,
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      print(e);
      return compute(parseResponse, {'busyness': 'Error Getting Live Info'});
    }

    if (response.statusCode == 500) {
      return compute(parseResponse, {'busyness': 'Error Getting Live Info'});
    }
    return compute(parseResponse, json.decode(response.body));
  }

  Future<Busyness> getAverageBusyness(body) async {
    var endpoint = Uri.https('${Config.busyApiUrl}', '/average/barbusyness');
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response;
    try {
      response = await http.post(
        endpoint,
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      print(e);
      return compute(parseResponse, {'busyness': 'Error Getting Average Info'});
    }

    if (response.statusCode == 500) {
      return compute(parseResponse, {'busyness': 'Error Getting Average Info'});
    }
    return compute(parseResponse, json.decode(response.body));
  }
}
