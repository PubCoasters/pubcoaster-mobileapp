import 'package:flutter/material.dart';
import 'package:NewApp/widget/bottomnav.dart';
import 'package:NewApp/widget/navbarhome.dart';
import 'package:NewApp/widget/navdrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:NewApp/pages/feedback.dart';
import 'package:NewApp/models/feedbackargs.dart';
import 'package:NewApp/services/busyservice.dart';
import 'package:NewApp/pages/locationposts.dart';

class SearchBusyBarFromFeed extends StatefulWidget {
  static const route = '/searchbusybarfromfeed';
  @override
  _SearchBusyBarFromFeedState createState() => _SearchBusyBarFromFeedState();
}

class _SearchBusyBarFromFeedState extends State<SearchBusyBarFromFeed> {
  String? barName;
  String? neighborhood;
  String? location;
  String? locationType;
  Future<dynamic>? liveInfo;
  Future<dynamic>? averageInfo;
  final busyService = BusyService();

  grabLiveInfo(body) async {
    var response;
    try {
      response = await busyService.getLiveBusyness(body);
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
          content: Text('Error getting information. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return response;
  }

  grabAverageInfo(body) async {
    var response;
    try {
      response = await busyService.getAverageBusyness(body);
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
          content: Text('Error getting information. Check network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return response;
  }

  searchBusyBarApi() {
    if (barName == null || location == null) {
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
        'location': location,
        'bar': barName,
        'neighborhood': neighborhood
      };
      liveInfo = grabAverageInfo(body);
      averageInfo = grabLiveInfo(body);
      Future.delayed(
        Duration.zero,
        () => {
          showDialog(
            context: context,
            builder: (BuildContext content) {
              return _liveBusy();
            },
          )
        },
      );
    }
  }

  Widget _liveBusy() {
    Iterable<Future<dynamic>> futures = [averageInfo!, liveInfo!];
    return FutureBuilder(
        future: Future.wait(futures),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data as List;
            var liveTime = data[1];
            var averageTime = data[0];
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .1,
                left: MediaQuery.of(context).size.height * .1,
                right: MediaQuery.of(context).size.height * .1,
                bottom: MediaQuery.of(context).size.height * .2,
              ),
              title: Text(
                'Busyness Level for $barName in $location',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 23),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Live Busyness Level: \n ${liveTime.busyness}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Average Busyness Level: \n ${averageTime.busyness}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                        tooltip: 'Close Dialog',
                      ),
                      FloatingActionButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, LocationPosts.route,
                            arguments: location),
                        child: Icon(Icons.check),
                        backgroundColor: Colors.red,
                        tooltip: 'Give Feedback',
                      ),
                    ],
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Text(
                'Error retrieving information: Check network connection',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 23),
                textAlign: TextAlign.center,
              ),
              actions: [
                FloatingActionButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.check),
                  backgroundColor: Colors.red,
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null &&
              snapshot.error == null) {
            return AlertDialog(
              title: Text(
                'Error retrieving information: Database may be off',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 23),
                textAlign: TextAlign.center,
              ),
              actions: [
                FloatingActionButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.check),
                  backgroundColor: Colors.red,
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  openGoogleUrl() async {
    if (barName == null || location == null) {
      final snackBar = SnackBar(
          content: Text('Error: fill out the required fields',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (neighborhood == null) {
      String _url = 'https://google.com/search';
      barName = barName!.replaceAll(' ', '-');
      _url += '?q=$location+$barName';
      await launch(_url);
      Navigator.pushReplacementNamed(context, FeedBack.route,
          arguments: FeedBackArgs(location: location!, bar: barName!));
    } else {
      String _url = 'https://google.com/search';
      barName = barName!.replaceAll(' ', '-');
      neighborhood = neighborhood!.replaceAll(' ', '-');
      _url += '?q=$location+$neighborhood+$barName';
      await launch(_url);
      Navigator.pushReplacementNamed(context, FeedBack.route,
          arguments: FeedBackArgs(
              location: location!, bar: barName!, neighborhood: neighborhood!));
    }
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

  Widget _searchForm() {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 0),
              child: Text(
                'Search how busy bars in different areas are',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
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
            _buttonRow(),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              searchBusyBarApi();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'See what WE say',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)))),
          ),
        ),
        VerticalDivider(
          color: Colors.white,
          thickness: 1.5,
        ),
        Expanded(
            child: ElevatedButton(
          onPressed: () {
            openGoogleUrl();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'See what Google says',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)))),
        )),
      ],
    );
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
              child: _searchForm(),
            ),
          )
        ],
      ),
      endDrawer: NavDrawer(),
      bottomNavigationBar: BottomNav(),
    );
  }
}
