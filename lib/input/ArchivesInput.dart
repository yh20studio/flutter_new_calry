import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/ArchivesDetail.dart';

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
            testInputForm(
                controller: _titleController,
                title: 'Title',
                width: _width,
                context: context),
            testInputForm(
                controller: _contentController,
                title: 'Content',
                width: _width,
                context: context),
            testInputForm(
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

  Widget testInputForm(
      {required TextEditingController controller,
      required String title,
      required double width,
      required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Text(title, style: Theme.of(context).textTheme.headline2),
        ),
        Container(
          width: width * 0.8,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.transparent),
          child: TextFormField(
            style: TextStyle(fontSize: 30),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: controller,
            decoration: InputDecoration(
                disabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.only(top: 0.0)),
          ),
        ),
      ],
    );
  }

  void _httpPostArchives() async {
    Archives archives = Archives(
        title: _titleController.text,
        content: _contentController.text,
        url: _urlController.text,
        author: '2young');
    var httpResult = await postArchives(archives);
    print((jsonDecode(httpResult)));
    Navigator.pop(context, 'success');
  }
}
