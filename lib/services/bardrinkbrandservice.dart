import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:async';
import 'package:NewApp/models/bars.dart';
import 'package:NewApp/models/brands.dart';
import 'package:NewApp/models/drinks.dart';
import 'package:flutter/foundation.dart';

List<Bars> parseBars(dataItems) {
  var response = dataItems.map<Bars>((json) => Bars.fromJson(json)).toList();
  return response;
}

List<Brands> parseBrands(dataItems) {
  var response =
      dataItems.map<Brands>((json) => Brands.fromJson(json)).toList();
  return response;
}

List<Drinks> parseDrinks(dataItems) {
  var response =
      dataItems.map<Drinks>((json) => Drinks.fromJson(json)).toList();
  return response;
}

List<Bars> parseNameBar(dataItems) {
  var response = dataItems.map<Bars>((json) => Bars.fromJson(json)).toList();
  return response;
}

List<Brands> parseNameBrand(dataItems) {
  var response =
      dataItems.map<Brands>((json) => Brands.fromJson(json)).toList();
  return response;
}

List<Drinks> parseNameDrink(dataItems) {
  var response =
      dataItems.map<Drinks>((json) => Drinks.fromJson(json)).toList();
  return response;
}

class BarDrinkBrandService {
  Future<dynamic> getAllBars(user, [page]) async {
    String path = '/bars';
    var params = {
      'user': user,
    };
    var endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (page != null && page > 1) {
      params = {
        'user': user,
        'offset': page.toString(),
      };
      endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
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
    return compute(parseBars, responseBody);
  }

  Future<dynamic> getAllDrinks(user, [page]) async {
    String path = '/drinks';
    var params = {
      'user': user,
    };
    var endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (page != null && page > 1) {
      var params = {
        'user': user,
        'offset': page.toString(),
      };
      endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
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
    return compute(parseDrinks, responseBody);
  }

  Future<dynamic> getAllBrands(user, [page]) async {
    String path = '/brands';
    var params = {
      'user': user,
    };
    var endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (page != null && page > 1) {
      var params = {
        'user': user,
        'offset': page.toString(),
      };
      endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
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
    return compute(parseBrands, responseBody);
  }

  Future<dynamic> getBarByName(name, user, [page]) async {
    String path = '/bar/$name';
    var params = {
      'user': user,
    };
    if (page != null && page > 1) {
      params = {
        'user': user,
        'offset': page.toString(),
      };
    }
    var endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
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
    var responseBody = json.decode(response.body);
    return compute(parseNameBar, responseBody);
  }

  Future<dynamic> getDrinkByName(name, user) async {
    String path = '/drink/$name';
    var params = {
      'user': user,
    };
    var endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
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
    var responseBody = json.decode(response.body);
    return compute(parseNameDrink, responseBody);
  }

  Future<dynamic> getBrandByName(name, user) async {
    String path = '/brand/$name';
    var params = {
      'user': user,
    };
    var endpoint = Uri.https('${Config.bardrinkbrandApiUrl}', path, params);
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
    var responseBody = json.decode(response.body);
    return compute(parseNameBrand, responseBody);
  }
}
