import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/ArchivesDetail.dart';

class ArchivesUpdate extends StatefulWidget {
  ArchivesUpdate({Key? key, this.archives}) : super(key: key);

  final Archives? archives;

  @override
  _ArchivesUpdatestate createState() => _ArchivesUpdatestate();
}

class _ArchivesUpdatestate extends State<ArchivesUpdate> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.archives!.title!;
    _contentController.text = widget.archives!.content!;
    _urlController.text = widget.archives!.url!;

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
                  Icons.edit,
                ),
                onPressed: _httpUpdateArchives),
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

  void _httpUpdateArchives() async {
    Archives archives = Archives(
      id: widget.archives!.id,
      title: _titleController.text,
      content: _contentController.text,
      url: _urlController.text,
    );
    var httpResult = await updateArchives(archives);
    Navigator.pop(context, httpResult);
  }
}
