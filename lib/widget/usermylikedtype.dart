import 'package:flutter/material.dart';
import 'package:NewApp/services/userservice.dart';
import 'package:NewApp/models/userbar.dart';
import 'package:NewApp/models/userbrand.dart';
import 'package:NewApp/models/userdrink.dart';
import 'package:strings/strings.dart';
import 'package:NewApp/models/userlikedargs.dart';
import 'package:NewApp/pages/myuserlikedtype.dart';

class UserMyLikedType extends StatelessWidget {
  UserMyLikedType(this.type, this.info);
  final String type;
  final dynamic info;
  final userService = new UserService();

  deleteBar(String uuid, String user, context) async {
    var body = {'username': user, 'uuid': uuid};
    bool succeed = await userService.deleteUserBar(body);
    if (succeed) {
      Navigator.pushReplacementNamed(context, MyUserLikedType.route,
          arguments: UserLiked(type: type, user: user));
    } else {
      final snackBar = SnackBar(
          content: Text('Error with deleting bar. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  deleteBrand(String uuid, String user, context) async {
    var body = {'username': user, 'uuid': uuid};
    bool succeed = await userService.deleteUserBrand(body);
    if (succeed) {
      Navigator.pushReplacementNamed(context, MyUserLikedType.route,
          arguments: UserLiked(type: type, user: user));
    } else {
      final snackBar = SnackBar(
          content: Text('Error with deleting brand. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  deleteDrink(String uuid, String user, context) async {
    var body = {'username': user, 'uuid': uuid};
    bool succeed = await userService.deleteUserDrink(body);
    if (succeed) {
      Navigator.pushReplacementNamed(context, MyUserLikedType.route,
          arguments: UserLiked(type: type, user: user));
    } else {
      final snackBar = SnackBar(
          content: Text('Error with deleting drink. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _drinkInfo(context) {
    UserDrink drinkInfo = info as UserDrink;
    return Column(
      children: [
        Divider(
          color: Colors.white,
          thickness: 0.25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                deleteDrink(drinkInfo.uuid, drinkInfo.user, context);
              },
            ),
            Text(
              '${capitalize(drinkInfo.drinkName)}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Merriweather-Bold',
                fontSize: 20,
              ),
            ),
            Icon(
              Icons.local_drink,
              color: Colors.red,
            ),
          ],
        ),
        Divider(
          color: Colors.white,
          thickness: 0.25,
        ),
      ],
    );
  }

  Widget _barDisplay(UserBar info) {
    if (info.neighborhood == '') {
      return Column(
        children: [
          Divider(
            color: Colors.white,
            thickness: 0.25,
          ),
          Text(
            '${capitalize(info.barName)}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            ),
          ),
          Text(
            '${info.location}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 0.25,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Divider(
            color: Colors.white,
            thickness: 0.25,
          ),
          Text(
            '${capitalize(info.barName)}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            ),
          ),
          Text(
            '${capitalize(info.neighborhood)}, ${info.location}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 0.25,
          ),
        ],
      );
    }
  }

  Widget _barInfo(context) {
    UserBar barInfo = info as UserBar;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            deleteBar(barInfo.uuid, barInfo.user, context);
          },
        ),
        _barDisplay(barInfo),
        Icon(
          Icons.sports_bar,
          color: Colors.red,
        )
      ],
    );
  }

  Widget _brandInfo(context) {
    UserBrand brandInfo = info as UserBrand;
    return Column(
      children: [
        Divider(
          color: Colors.white,
          thickness: 0.25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                deleteBrand(brandInfo.uuid, brandInfo.user, context);
              },
            ),
            Column(
              children: [
                Text(
                  'Name: ${capitalize(brandInfo.brandName)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Merriweather-Bold',
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Type: ${capitalize(brandInfo.type)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Merriweather-Bold',
                    fontSize: 20,
                  ),
                )
              ],
            ),
            Icon(
              Icons.local_bar,
              color: Colors.red,
            )
          ],
        ),
        Divider(
          color: Colors.white,
          thickness: 0.25,
        ),
      ],
    );
  }

  Widget _typeInfo(context) {
    switch (type) {
      case 'bar':
        return _barInfo(context);
      case 'drink':
        return _drinkInfo(context);
      case 'brand':
        return _brandInfo(context);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: _typeInfo(context),
    );
  }
}
