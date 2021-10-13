import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/dialog/DurationChoiceDialog.dart';
import 'package:flutter_webservice/input/RoutinesMemosInput.dart';
import 'package:flutter_webservice/input/RoutinesUpdate.dart';
import 'package:flutter_webservice/detail/RoutinesMemosDetail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webservice/widgets/TimeDurationWidget.dart';
import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';
import 'package:flutter_webservice/widgets/ContainerWidget.dart';
import 'package:flutter_webservice/widgets/ListViewWidget.dart';
import 'package:flutter_webservice/widgets/DateWidget.dart';
import 'dart:convert';

class RoutinesDetail extends StatefulWidget {
  RoutinesDetail({Key? key, this.routines}) : super(key: key);

  final Routines? routines;

  @override
  _RoutinesDetailstate createState() => _RoutinesDetailstate();
}

class _RoutinesDetailstate extends State<RoutinesDetail> {
  TextEditingController _iconController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  Routines? routines;
  String? popResult = "";
  List<Memos>? routines_memosList = [];

  @override
  void initState() {
    routines = widget.routines!;
    routines_memosList = widget.routines!.routines_memosList;
    _titleController.text = widget.routines!.title!;
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
              title: Text(routines!.title!),
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            borderPaddingContainerWidget(
                              context: context,
                              widget: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("아이콘 변경"),
                                  Container(
                                    width: 50,
                                    child:
                                        Image.asset('assets/images/sunny.png'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            borderPaddingContainerWidget(
                                context: context,
                                widget: textInputSimpleForm(
                                    controller: _titleController,
                                    context: context)),
                            SizedBox(
                              height: 20,
                            ),
                            borderPaddingContainerWidget(
                                context: context,
                                widget: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("시간"),
                                      durationInputForm(
                                        context: context,
                                        timeDuration: routines!.timeDuration!,
                                      )
                                    ])),
                            SizedBox(
                              height: 20,
                            ),
                            borderPaddingContainerWidget(
                                context: context,
                                widget: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("메모"),
                                          TextButton(
                                            onPressed: () =>
                                                _awaitReturnValueFromRoutinesMemosInput(),
                                            child: Text("추가"),
                                          )
                                        ],
                                      ),
                                      Wrap(
                                          spacing:
                                              8.0, // gap between adjacent chips
                                          runSpacing: 4.0, // gap between lines
                                          children: List.generate(
                                              routines_memosList!.length,
                                              (i) => listViewMemos(
                                                  index: i,
                                                  memos: routines_memosList![i],
                                                  width: _width,
                                                  context: context)).toList())
                                    ])),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text("삭제"),
                                  onPressed: _httpDeleteRoutines,
                                ),
                                TextButton(
                                  child: Text("완료"),
                                  onPressed: _httpUpdateRoutines,
                                ),
                              ],
                            ),
                          ],
                        ))))));
  }

  Widget durationInputForm(
      {required TimeDuration timeDuration, required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _duraionChoiceDialog() async {
            var dialogResult = await duraionChoiceDialog(context, timeDuration);
            setState(() {
              print(timeDuration.hour);
              timeDuration = dialogResult;
            });
          }

          _duraionChoiceDialog();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${timeDuration.hour}"),
                  Text("시간"),
                  Text("${timeDuration.min}"),
                  Text("분"),
                  Text("${timeDuration.sec}"),
                  Text("초"),
                ],
              ),
            )
          ],
        ));
  }

  Widget listViewMemos(
      {required int? index,
      required Memos? memos,
      required double? width,
      required BuildContext context}) {
    // widget layout for listview items
    return InkWell(
        onTap: () =>
            _awaitReturnValueFromRoutinesMemosDetail(context, memos!, index!),
        child: Container(
            decoration: new BoxDecoration(
                border: Border(
              top: BorderSide(width: 0.1, color: Theme.of(context).canvasColor),
            )),
            width: width! * 0.8,
            padding: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      monthDayDateWidget(
                          datetime: memos!.created_date, context: context),
                    ]),
                SizedBox(
                  height: 10,
                ),
                Text("${memos.content}")
              ],
            )));
  }

  void _awaitReturnValueFromRoutinesMemosDetail(
      BuildContext context, Memos memos, int index) async {
    try {
      var awaitResult = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RoutinesMemosDetail(
                    memos: memos,
                  )));

      if (awaitResult[0] == "delete") {
        setState(() {
          routines_memosList!.removeAt(index);
          popResult = "update";
        });
      } else if (awaitResult[0] == "update") {
        setState(() {
          routines_memosList![index] = awaitResult[1];
          popResult = "update";
        });
      }
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _httpDeleteRoutines() async {
    var httpResult = await deleteRoutines(routines!);
    print((httpResult));
    Navigator.pop(context, [httpResult, null]);
  }

  void _awaitReturnValueFromRoutinesMemosInput() async {
    try {
      var awaitResult = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RoutinesMemosInput(
                    routines: routines,
                  )));
      setState(() {
        popResult = "update";
        routines_memosList!.insert(0, awaitResult);
      });
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _httpUpdateRoutines() async {
    Routines newRoutines = Routines(
        id: widget.routines!.id,
        icon: widget.routines!.icon,
        title: _titleController.text,
        duration: (routines!.timeDuration!.hour!) * 3600 +
            (routines!.timeDuration!.min!) * 60 +
            (routines!.timeDuration!.sec!));
    try {
      var httpResult = await updateRoutines(newRoutines);
      Navigator.pop(context, ["update", httpResult]);
    } on Exception catch (exception) {
      print(exception);
    }
  }
}
