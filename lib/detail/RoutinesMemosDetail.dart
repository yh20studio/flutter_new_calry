import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/dialog/AlertDialog.dart';
import 'package:flutter_webservice/input/RoutinesMemosInput.dart';
import 'package:flutter_webservice/input/RoutinesUpdate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webservice/widgets/TimeDurationWidget.dart';
import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';
import 'package:flutter_webservice/widgets/ContainerWidget.dart';
import 'package:flutter_webservice/widgets/ListViewWidget.dart';
import 'package:flutter_webservice/widgets/DateWidget.dart';
import 'dart:convert';

class RoutinesMemosDetail extends StatefulWidget {
  RoutinesMemosDetail({Key? key, this.memos}) : super(key: key);

  final Memos? memos;

  @override
  _RoutinesMemosDetailstate createState() => _RoutinesMemosDetailstate();
}

class _RoutinesMemosDetailstate extends State<RoutinesMemosDetail> {
  TextEditingController _memoController = TextEditingController();
  Memos? memos;
  String? popResult = "";

  @override
  void initState() {
    memos = widget.memos!;
    _memoController.text = widget.memos!.content!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, popResult);
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            appBar: AppBar(
              title: Text("메모 Detail"),
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            monthDayDateWidget(
                                datetime: memos!.created_date,
                                context: context),
                            SizedBox(
                              height: 30,
                            ),
                            textInputForm(
                                controller: _memoController,
                                title: 'Memo',
                                width: _width,
                                context: context),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text("삭제"),
                                  onPressed: _httpDeleteRoutinesMemos,
                                ),
                                TextButton(
                                  child: Text("완료"),
                                  onPressed:
                                      _awaitReturnValueFromRoutinesMemosUpdate,
                                ),
                              ],
                            )
                          ],
                        ))))));
  }

  void _httpDeleteRoutinesMemos() async {
    try {
      var httpResult = await deleteRoutinesMemos(memos!);
      print((httpResult));
      Navigator.pop(context, [httpResult, null]);
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _awaitReturnValueFromRoutinesMemosUpdate() async {
    Memos updateMemos = Memos(
        id: memos!.id,
        routines_id: memos!.routines_id,
        content: _memoController.text);
    try {
      var httpResult = await updateRoutinesMemos(updateMemos);
      Navigator.pop(context, ["update", httpResult]);
    } on Exception catch (exception) {
      print(exception);
    }
  }
}
