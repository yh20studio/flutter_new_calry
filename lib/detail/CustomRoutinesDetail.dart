import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/dialog.dart';
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

class CustomRoutinesDetail extends StatefulWidget {
  CustomRoutinesDetail({Key? key, this.customRoutines}) : super(key: key);

  final CustomRoutines? customRoutines;

  @override
  _CustomRoutinesDetailstate createState() => _CustomRoutinesDetailstate();
}

class _CustomRoutinesDetailstate extends State<CustomRoutinesDetail> {
  TextEditingController _iconController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  CustomRoutines? customRoutines;
  String? popResult = "";

  @override
  void initState() {
    customRoutines = widget.customRoutines!;
    _titleController.text = widget.customRoutines!.title!;
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
              title: Text(customRoutines!.title!),
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
                                        timeDuration:
                                            customRoutines!.timeDuration!,
                                      )
                                    ])),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text("삭제"),
                                  onPressed: _httpDeleteCustomRoutines,
                                ),
                                TextButton(
                                  child: Text("완료"),
                                  onPressed: _httpUpdateCustomRoutines,
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

  void _httpDeleteCustomRoutines() async {
    var httpResult = await deleteCustomRoutines(customRoutines!);
    print((httpResult));
    Navigator.pop(context, [httpResult, null]);
  }

  void _httpUpdateCustomRoutines() async {
    CustomRoutines newCustomRoutines = CustomRoutines(
        id: widget.customRoutines!.id,
        icon: widget.customRoutines!.icon,
        title: _titleController.text,
        duration: (customRoutines!.timeDuration!.hour!) * 3600 +
            (customRoutines!.timeDuration!.min!) * 60 +
            (customRoutines!.timeDuration!.sec!));
    try {
      var httpResult = await updateCustomRoutines(newCustomRoutines);
      Navigator.pop(context, ["update", httpResult]);
    } on Exception catch (exception) {
      print(exception);
    }
  }
}
