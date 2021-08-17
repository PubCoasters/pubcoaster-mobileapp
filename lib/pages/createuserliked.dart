import 'package:flutter/material.dart';
import 'package:NewApp/widget/navbarhome.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/services/userservice.dart';
import 'package:NewApp/pages/myuserlikedtype.dart';
import 'package:NewApp/models/userlikedargs.dart';

class CreateUserLiked extends StatefulWidget {
  CreateUserLiked(this.type, this.user);
  final String type;
  final String user;
  static const route = '/createuserliked';
  @override
  _CreateUserLikedState createState() => _CreateUserLikedState();
}

class _CreateUserLikedState extends State<CreateUserLiked> {
  final userService = new UserService();
  String? location;
  String? neighborhood;
  String? barName;
  String? brandName;
  String? type;
  String? drinkName;
  String? locationType;

  createUserBar() async {
    if (barName != null && location != null) {
      bool succeed = false;
      var body = {
        'neighborhood': (neighborhood != null) ? neighborhood : '',
        'username': widget.user,
        'location': location,
        'bar': barName,
      };
      succeed = await userService.createUserBar(body);
      if (succeed) {
        final snackBar = SnackBar(
            content: Text('Successfully created bar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacementNamed(context, MyUserLikedType.route,
            arguments: UserLiked(type: widget.type, user: widget.user));
      } else {
        final snackBar = SnackBar(
            content: Text('Error: could not create bar. Check connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Make sure to fill out need information',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  createUserBrand() async {
    if (brandName != null && type != null) {
      bool succeed = false;
      var body = {
        'username': widget.user,
        'brand': brandName,
        'type': type,
      };
      succeed = await userService.createUserBrand(body);
      if (succeed) {
        final snackBar = SnackBar(
            content: Text('Successfully created brand!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacementNamed(context, MyUserLikedType.route,
            arguments: UserLiked(type: widget.type, user: widget.user));
      } else {
        final snackBar = SnackBar(
            content: Text('Error: could not create brand. Check connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Make sure to fill out need information',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  createUserDrink() async {
    if (drinkName != null) {
      bool succeed = false;
      var body = {
        'username': widget.user,
        'drink': drinkName,
      };
      succeed = await userService.createUserDrink(body);
      if (succeed) {
        final snackBar = SnackBar(
            content: Text('Successfully created brand!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacementNamed(context, MyUserLikedType.route,
            arguments: UserLiked(type: widget.type, user: widget.user));
      } else {
        final snackBar = SnackBar(
            content: Text('Error: could not create brand. Check connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
          content: Text('Make sure to fill out need information',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _createDrink() {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 0),
              child: Center(
                child: Text(
                  'Create a New Drink to like',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Drink*'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {drinkName = value})
                    }
                },
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, MyUserLikedType.route,
                        arguments:
                            UserLiked(type: widget.type, user: widget.user));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                ),
                ElevatedButton(
                  onPressed: () {
                    createUserDrink();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createBrand() {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 0),
              child: Center(
                child: Text(
                  'Create a New Brand to like',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Brand*'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {brandName = value})
                    }
                },
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Type*'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {type = value})
                    }
                },
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, MyUserLikedType.route,
                        arguments:
                            UserLiked(type: widget.type, user: widget.user));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                ),
                ElevatedButton(
                  onPressed: () {
                    createUserBrand();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createBar() {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 0),
              child: Center(
                child: Text(
                  'Create a New Bar to like',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Bar*'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {barName = value})
                    }
                },
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
              child: DropdownButtonFormField(
                items: ['City', 'College']
                    .map((String value) => DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        ))
                    .toList(),
                onChanged: (String? value) {
                  if (mounted) {
                    setState(() {
                      locationType = value!;
                    });
                  }
                },
                hint: Text('Location Type*'),
                decoration: InputDecoration(focusColor: Colors.black),
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            _locationDropdown(),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Neighborhood'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {neighborhood = value})
                    }
                },
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, MyUserLikedType.route,
                        arguments:
                            UserLiked(type: widget.type, user: widget.user));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                ),
                ElevatedButton(
                  onPressed: () {
                    createUserBar();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _locationDropdown() {
    if (locationType == 'City') {
      return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
        child: DropdownButtonFormField(
            items: [
              'Columbus',
              'Chicago',
              'New York',
              'Denver',
              'Washington DC',
              'San Francisco',
              'Orlando',
              'Phoenix',
              'Boston',
              'Los Angeles'
            ]
                .map((String value) => DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    ))
                .toList(),
            onChanged: (String? value) {
              if (mounted) {
                setState(() {
                  location = value!;
                });
              }
            },
            hint: Text('City*'),
            decoration: InputDecoration(focusColor: Colors.black)),
      );
    } else if (locationType == 'College') {
      return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
        child: DropdownButtonFormField(
            items: [
              'Ohio State',
              'University of Michigan',
              'Michigan State',
              'Penn State',
              'University of Illinois',
              'University of Wisconsin'
            ]
                .map((String value) => DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    ))
                .toList(),
            onChanged: (String? value) {
              if (mounted) {
                setState(() {
                  location = value!;
                });
              }
            },
            hint: Text('College*'),
            decoration: InputDecoration(focusColor: Colors.black)),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
        child: DropdownButtonFormField(
            items: [],
            hint: Text('Location*'),
            decoration: InputDecoration(focusColor: Colors.black)),
      );
    }
  }

  Widget _createDisplay() {
    switch (widget.type) {
      case 'bar':
        return _createBar();
      case 'drink':
        return _createDrink();
      case 'brand':
        return _createBrand();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          NavBar(),
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 4, top: 6),
            child: Container(
              decoration: BoxDecoration(border: Border.all(width: 4)),
              padding: const EdgeInsets.only(right: 4, left: 4, top: 10),
              child: _createDisplay(),
            ),
          )
        ],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
