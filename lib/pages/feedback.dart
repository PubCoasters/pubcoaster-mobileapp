import 'package:flutter/material.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/navbarhome.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:NewApp/services/busyservice.dart';
import 'package:NewApp/pages/locationposts.dart';
import 'package:strings/strings.dart';

class FeedBack extends StatefulWidget {
  static const route = '/feedback';
  final String location;
  final String bar;
  final String? neighborhood;
  FeedBack(this.location, this.bar, this.neighborhood);
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  int? googleLive;
  int? googleAverage;
  String? userLive;
  final busyService = BusyService();

  showLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext content) {
        //getImage()
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.height * .2,
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                strokeWidth: 10,
              ),
            ),
          ),
        );
      },
    );
  }

  apiCall(body) async {
    showLoadingDialog();
    bool succeed = await busyService.createBusyBar(body);
    if (succeed) {
      Navigator.of(context).pop();
      final snackBar = SnackBar(
          content: Text('Successfully submitted',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacementNamed(context, LocationPosts.route,
          arguments: widget.location);
    } else {
      Navigator.of(context).pop();
      final snackBar = SnackBar(
          content: Text('Error: failed to submit',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  submitFeedBack() {
    if (userLive == null) {
      final snackBar = SnackBar(
          content: Text('Error: fill out the required fields',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var body = {
        'google_live_busyness': googleLive,
        'google_average_busyness': googleAverage,
        'busyness': userLive,
        'bar': widget.bar,
        'location': widget.location,
        'neighborhood': widget.neighborhood,
      };
      apiCall(body);
    }
  }

  Widget _title() {
    if (widget.neighborhood == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 0),
        child: Text(
          'Tell us about how busy ${capitalize(widget.bar)} in ${widget.location} was',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 0),
        child: Text(
          'Tell us about ${capitalize(widget.bar)} in ${capitalize(widget.neighborhood!)}, ${widget.location} was',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline),
        ),
      );
    }
  }

  Widget _feedBackForm() {
    return Form(
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _title(),
          const Divider(
            color: Colors.white,
            thickness: 1.5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: DropdownButtonFormField(
              items: ['1', '2', '3', '4', '5']
                  .map((String value) => DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String? value) {
                if (mounted) {
                  setState(() {
                    googleLive = int.parse(value!);
                  });
                }
              },
              hint: Text('How Busy Did Google Say It Was?'),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.075,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: DropdownButtonFormField(
              items: ['1', '2', '3', '4', '5']
                  .map((String value) => DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String? value) {
                if (mounted) {
                  setState(() {
                    googleAverage = int.parse(value!);
                  });
                }
              },
              hint: Text('How Busy Did Google Say It Usually Is?'),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.075,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: DropdownButtonFormField(
              items: [
                'Dead AF',
                'Some Crowd',
                'Lively Enough',
                'There Are Lines',
                'Can’t Move'
              ]
                  .map((String value) => DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String? value) {
                if (mounted) {
                  setState(() {
                    userLive = value;
                  });
                }
              },
              hint: Text('How Busy Would You Say It Is?*'),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.075,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LocationPosts.route,
                      arguments: widget.location);
                },
                child: Text(
                  'Not At Bar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
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
                  submitFeedBack();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)))),
              ),
            ],
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavBar(),
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 4, top: 6),
            child: Container(
              decoration: BoxDecoration(border: Border.all(width: 4)),
              padding: const EdgeInsets.only(right: 4, left: 4, top: 10),
              child: _feedBackForm(),
            ),
          )
        ],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
