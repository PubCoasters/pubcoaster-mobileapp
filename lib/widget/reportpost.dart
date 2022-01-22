import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportPost extends StatelessWidget {
  ReportPost(this.uuid);
  final String uuid;

  launchUrl() async {
    String emailUrl = 'mailto:pubcoasters@gmail.com?subject=Report Post: $uuid';
    print(await canLaunch(emailUrl));
    await launch(emailUrl);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.warning),
      onPressed: () {
        launchUrl();
      },
      tooltip: 'Report Post',
      color: Colors.white,
    );
  }
}
