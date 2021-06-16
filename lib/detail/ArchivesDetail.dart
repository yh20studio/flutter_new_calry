import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'dart:convert';

class ArchivesDetail extends StatefulWidget {
  ArchivesDetail({Key? key, this.archives}) : super(key: key);

  final Archives? archives;

  @override
  _ArchivesDetailstate createState() => _ArchivesDetailstate();
}

class _ArchivesDetailstate extends State<ArchivesDetail> {
  Archives? archives;

  @override
  void initState() {
    archives = widget.archives!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text(archives!.url!),
            Text(archives!.author!),
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: _httpUpdateArchives,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: _httpDeleteArchives,
            ),
          ],
        ))));
  }

  void _httpDeleteArchives() async {
    var httpResult = await deleteArchives(archives!);
    print((httpResult));
    Navigator.pop(context, httpResult);
  }

  void _httpUpdateArchives() async {
    var httpResult = await deleteArchives(archives!);
    print((httpResult));
    Navigator.pop(context, httpResult);
  }
}
