import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/input/ArchivesUpdate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class ArchivesDetail extends StatefulWidget {
  ArchivesDetail({Key? key, this.archives}) : super(key: key);

  final Archives? archives;

  @override
  _ArchivesDetailstate createState() => _ArchivesDetailstate();
}

class _ArchivesDetailstate extends State<ArchivesDetail> {
  Archives? archives;
  String? popResult = "";

  @override
  void initState() {
    archives = widget.archives!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, popResult);
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            appBar: AppBar(
              title: Text(archives!.title!),
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                Text(archives!.title!),
                Text(archives!.content!),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      _launchUrl(archives!.url!);
                    },
                    child: Text("바로가기")),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: _awaitReturnValueFromArchivesUpdate,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: _httpDeleteArchives,
                ),
              ],
            )))));
  }

  void _httpDeleteArchives() async {
    var httpResult = await deleteArchives(archives!);
    print((httpResult));
    Navigator.pop(context, httpResult);
  }

  void _awaitReturnValueFromArchivesUpdate() async {
    try {
      var awaitResult = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArchivesUpdate(
                    archives: archives,
                  )));
      setState(() {
        popResult = "update";
        archives = awaitResult;
      });
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
