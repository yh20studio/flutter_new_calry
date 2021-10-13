import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_webservice/class.dart';

import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';

class RoutinesMemosInput extends StatefulWidget {
  RoutinesMemosInput({Key? key, this.routines}) : super(key: key);

  final Routines? routines;

  @override
  _RoutinesMemosInputstate createState() => _RoutinesMemosInputstate();
}

class _RoutinesMemosInputstate extends State<RoutinesMemosInput> {
  TextEditingController _memoController = TextEditingController();

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
          title: Text('Memo Input'),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            textInputForm(
                controller: _memoController,
                title: 'Memo',
                width: _width,
                context: context),
            SizedBox(
              height: 30,
            ),
            IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: _httpPostMemos),
          ],
        ))));
  }

  void _httpPostMemos() async {
    Memos memos = Memos(
      routines_id: widget.routines!.id,
      content: _memoController.text,
    );
    try {
      var httpResult = await postRoutinesMemos(memos);
      Navigator.pop(context, httpResult);
    } catch (e) {
      print(e);
    }
  }
}
