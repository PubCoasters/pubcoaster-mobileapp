import 'package:flutter/material.dart';
import 'package:NewApp/models/userbar.dart';
import 'package:NewApp/models/userbrand.dart';
import 'package:NewApp/models/userdrink.dart';
import 'package:strings/strings.dart';

class UserLikedTypeWidget extends StatelessWidget {
  UserLikedTypeWidget(this.type, this.info);
  final String type;
  final dynamic info;

  Widget _drinkInfo() {
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
        )
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

  Widget _barInfo() {
    UserBar barInfo = info as UserBar;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _barDisplay(barInfo),
        Icon(
          Icons.sports_bar,
          color: Colors.red,
        )
      ],
    );
  }

  Widget _brandInfo() {
    UserBrand brandInfo = info as UserBrand;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Divider(
              color: Colors.white,
              thickness: 0.25,
            ),
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
            ),
            Divider(
              color: Colors.white,
              thickness: 0.25,
            ),
          ],
        ),
        Icon(
          Icons.local_bar,
          color: Colors.red,
        )
      ],
    );
  }

  Widget _typeInfo() {
    switch (type) {
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
