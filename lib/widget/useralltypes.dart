import 'package:flutter/material.dart';
import 'package:NewApp/models/bars.dart';
import 'package:NewApp/models/brands.dart';
import 'package:NewApp/models/drinks.dart';
import 'package:strings/strings.dart';
import 'package:NewApp/services/userservice.dart';

class UserAllTypes extends StatefulWidget {
  UserAllTypes(this.type, this.info, this.user);
  final String type;
  final dynamic info;
  final String user;
  @override
  _UserAllTypesState createState() => _UserAllTypesState();
}

class _UserAllTypesState extends State<UserAllTypes> {
  final userService = new UserService();

  deleteBar(Bars barInfo) async {
    var body = {'username': widget.user, 'uuid': widget.info.uuid};
    bool succeed = await userService.deleteUserBar(body);
    if (succeed) {
      if (mounted) {
        setState(() {
          barInfo.liked = false;
        });
      }
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

  deleteBrand(Brands brandInfo) async {
    var body = {'username': widget.user, 'uuid': widget.info.uuid};
    bool succeed = await userService.deleteUserBrand(body);
    if (succeed) {
      setState(() {
        brandInfo.liked = false;
      });
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

  deleteDrink(Drinks drinkInfo) async {
    var body = {'username': widget.user, 'uuid': widget.info.uuid};
    bool succeed = await userService.deleteUserDrink(body);
    if (succeed) {
      setState(() {
        drinkInfo.liked = false;
      });
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

  likeBar(Bars barInfo) async {
    var body = {
      'username': widget.user,
      'bar': widget.info.barName,
      'location': widget.info.location,
      'neighborhood': widget.info.neighborhood,
    };
    bool succeed = await userService.createUserBar(body);
    if (succeed) {
      setState(() {
        barInfo.liked = true;
      });
    } else {
      final snackBar = SnackBar(
          content: Text('Error with liking bar. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  likeBrand(Brands brandInfo) async {
    var body = {
      'username': widget.user,
      'brand': widget.info.brandName,
      'type': widget.info.type,
    };
    bool succeed = await userService.createUserBrand(body);
    if (succeed) {
      setState(() {
        brandInfo.liked = true;
      });
    } else {
      final snackBar = SnackBar(
          content: Text('Error with liking brand. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  likeDrink(Drinks drinkInfo) async {
    var body = {
      'username': widget.user,
      'drink': widget.info.drinkName,
    };
    bool succeed = await userService.createUserDrink(body);
    if (succeed) {
      setState(() {
        drinkInfo.liked = true;
      });
    } else {
      final snackBar = SnackBar(
          content: Text('Error with liking drink. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _likeIcon(info) {
    if (info.liked) {
      switch (widget.type) {
        case 'bar':
          return IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Bars barInfo = info as Bars;
              deleteBar(barInfo);
            },
          );
        case 'drink':
          return IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Drinks drinkInfo = info as Drinks;
              deleteDrink(drinkInfo);
            },
          );
        case 'brand':
          return IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Brands brandInfo = info as Brands;
              deleteBrand(brandInfo);
            },
          );
      }
      return IconButton(
        icon: Icon(Icons.favorite, color: Colors.red),
        onPressed: () {},
      );
    } else {
      switch (widget.type) {
        case 'bar':
          return IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.grey),
            onPressed: () {
              Bars barInfo = info as Bars;
              likeBar(barInfo);
            },
          );
        case 'brand':
          return IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.grey),
            onPressed: () {
              Brands brandInfo = info as Brands;
              likeBrand(brandInfo);
            },
          );
        case 'drink':
          return IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.grey),
            onPressed: () {
              Drinks drinkInfo = info as Drinks;
              likeDrink(drinkInfo);
            },
          );
      }
      return IconButton(
        icon: Icon(Icons.favorite_border, color: Colors.grey),
        onPressed: () {},
      );
    }
  }

  Widget _barInfo() {
    Bars barInfo = widget.info as Bars;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _likeIcon(widget.info),
        _barDisplay(barInfo),
        Icon(
          Icons.sports_bar,
          color: Colors.red,
        )
      ],
    );
  }

  Widget _barDisplay(Bars info) {
    if (info.neighborhood == '' || info.neighborhood == null) {
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
            '${capitalize(info.neighborhood!)}, ${info.location}',
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

  Widget _drinkInfo() {
    Drinks drinkInfo = widget.info as Drinks;
    return Column(
      children: [
        Divider(
          color: Colors.white,
          thickness: 0.25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _likeIcon(widget.info),
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

  Widget _brandInfo() {
    Brands brandInfo = widget.info as Brands;
    return Column(
      children: [
        Divider(
          color: Colors.white,
          thickness: 0.25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _likeIcon(widget.info),
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
              Icons.sports_bar,
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

  Widget _typeInfo() {
    switch (widget.type) {
      case 'bar':
        return _barInfo();
      case 'drink':
        return _drinkInfo();
      case 'brand':
        return _brandInfo();
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
      child: _typeInfo(),
    );
  }
}
