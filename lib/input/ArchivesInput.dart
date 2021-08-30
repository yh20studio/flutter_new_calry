import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';

class ArchivesInput extends StatefulWidget {
  ArchivesInput({Key? key, this.archives}) : super(key: key);

  final Archives? archives;

  @override
  _ArchivesInputstate createState() => _ArchivesInputstate();
}

class _ArchivesInputstate extends State<ArchivesInput> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text('Input'),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            textInputForm(
                controller: _titleController,
                title: 'Title',
                width: _width,
                context: context),
            textInputForm(
                controller: _contentController,
                title: 'Content',
                width: _width,
                context: context),
            textInputForm(
                controller: _urlController,
                title: 'Url',
                width: _width,
                context: context),
            IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: _httpPostArchives),
          ],
        ))));
  }

  void _httpPostArchives() async {
    Archives archives = Archives(
      title: _titleController.text,
      content: _contentController.text,
      url: _urlController.text,
    );
    var httpResult = await postArchives(archives);
    print((jsonDecode(httpResult)));
    Navigator.pop(context, 'success');
  }
}
