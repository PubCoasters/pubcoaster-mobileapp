import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportPost extends StatelessWidget {
  ReportPost(this.uuid);
  final String uuid;

  launchUrl(context) async {
    String emailUrl = 'mailto:pubcoasters@gmail.com?subject=Report Post: $uuid';
    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      final snackBar = SnackBar(
          content: Text(
              'Error opening up the mail app. Feel free to email us at pubcoasters@gmail.com. Either describe the post or let us check it out by giving us this number: $uuid',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.warning),
      onPressed: () {
        launchUrl(context);
      },
      tooltip: 'Report Post',
      color: Colors.white,
    );
  }
}
