import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/quickSchedules/QuickSchedules.dart';
import '../../domain/labels/Labels.dart';
import '../../domain/labelColors/LabelColors.dart';
import '../../widgets/TextInputFormWidget.dart';
import '../../modalBottomSheet/labels/LabelsModalBottomSheet.dart';
import '../../widgets/TimeWidget.dart';
import '../../functions.dart';
import '../../modalBottomSheet/time/TimeModalBottomSheet.dart';
import '../../controller/quickSchedules/QuickSchedulesController.dart';
import '../../auth/Login.dart';
import '../../controller/jwt/JwtController.dart';
import '../../widgets/ContainerWidget.dart';

class QuickSchedulesDetail extends StatefulWidget {
  QuickSchedulesDetail({Key? key, this.quickSchedules}) : super(key: key);
  final QuickSchedules? quickSchedules;

  @override
  _QuickSchedulesDetailstate createState() => _QuickSchedulesDetailstate();
}

class _QuickSchedulesDetailstate extends State<QuickSchedulesDetail> {
  DateTime now = DateTime.now();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Labels labels = Labels(title: "레드", label_colors: LabelColors(code: "#ff7b7b"));
  List<Labels> labelsList = [];

  SharedPreferences? prefs;

  bool? isSetTime = false;

  @override
  void initState() {
    awaitHttpFunctionGetLabels();
    if (widget.quickSchedules!.startTime == null && widget.quickSchedules!.endTime == null) {
      isSetTime = false;
      startTime = TimeOfDay(hour: now.hour, minute: now.minute);
      endTime = TimeOfDay(hour: now.hour, minute: now.minute);
    } else {
      isSetTime = true;
      startTime = TimeOfDay(hour: widget.quickSchedules!.startTime!.hour, minute: widget.quickSchedules!.startTime!.minute);
      endTime = TimeOfDay(hour: widget.quickSchedules!.endTime!.hour, minute: widget.quickSchedules!.endTime!.minute);
    }
    _titleController.text = widget.quickSchedules!.title!;
    _contentController.text = widget.quickSchedules!.content!;
    labels = widget.quickSchedules!.labels!;
    super.initState();
  }

  void awaitHttpFunctionGetLabels() async {
    prefs = await SharedPreferences.getInstance();
    final String labelString = await prefs!.getString('labels')!;
    setState(() {
      labelsList = Labels.decode(labelString);
    });
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _httpDeleteQuickSchedules,
                  child: Text(
                    "삭제",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(
                    child: Center(child:Text(
                      "반복 일정 편집",
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.w700),
                    ),
                    )),
                TextButton(
                  onPressed: _httpUpdateQuickSchedules,
                  child: Text("저장",
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                      )),
                ),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:Row(
          children: [
            Expanded(
              child: Text(
                "시간",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Switch(
              value: isSetTime!,
              onChanged: (value) {
                setState(() {
                  isSetTime = value;
                });
              },
              activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.8),
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        )),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:isSetTime! ? overlayPaddingContainerWidget(
            context: context,
            widget:timeInputForm(start: startTime!, end: endTime!, width: _width, context: context)) : SizedBox(),
        ),
          SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:Row(
          children: [
            Expanded(
              child: Text(
                "제목",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:overlayPaddingContainerWidget(
          context: context,
          widget: textInputSimpleForm(
              controller: _titleController, context: context),
        )),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:Row(
          children: [
            Expanded(
              child: Text(
                "메모",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:overlayPaddingContainerWidget(
          context: context,
          widget: textInputSimpleForm(
              controller: _contentController, context: context),
        )),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:Row(
          children: [
            Expanded(
              child: Text(
                "라벨",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            labelsInputForm(
                labelsList: labelsList, width: _width, context: context),
          ],
        )),
      ],
    )));
  }

  Widget timeInputForm({required TimeOfDay start, required TimeOfDay end, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _calendarModalBottomSheet() async {
            var result = await timeTwoChoiceModalBottomSheet(start, end, context);
            setState(() {
              startTime = result[0];
              endTime = result[1];
            });
          }

          _calendarModalBottomSheet();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  meridiemHourMinuteTimeWidget(timeOfDay: start, context: context),
                  Text(
                    " ~ ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  meridiemHourMinuteTimeWidget(timeOfDay: end, context: context),
                ],
              ),
            ),
          ],
        ));
  }

  Widget labelsInputForm({required List<Labels> labelsList, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _calendarModalBottomSheet() async {
            var result = await labelsModalBottomSheet(labelsList, context);
            if (result == Labels()) {
            } else if (result == null) {
            } else {
              setState(() {
                labels = result;
              });
            }
          }

          _calendarModalBottomSheet();
        },
        child: Center(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      color: MyFunction.parseColor(labels.label_colors!.code!),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("${labels.title}", style: Theme.of(context).textTheme.headline2),
                  ],
                ))));
  }

  void _httpUpdateQuickSchedules() async {
    QuickSchedules quickSchedules = QuickSchedules(
        id: widget.quickSchedules!.id,
        startTime: isSetTime! ? startTime : null,
        endTime: isSetTime! ? endTime : null,
        title: _titleController.text,
        content: _contentController.text,
        labels: labels);
    try {
      var httpResult = await updateQuickSchedules(await getJwt(context), quickSchedules);
      Navigator.pop(context, ["update", httpResult]);
    } catch (e) {
      if (e == 'login') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  void _httpDeleteQuickSchedules() async {
    QuickSchedules quickSchedules = QuickSchedules(
        id: widget.quickSchedules!.id,
        startTime: isSetTime! ? startTime : null,
        endTime: isSetTime! ? endTime : null,
        title: _titleController.text,
        content: _contentController.text,
        labels: labels);
    await deleteQuickSchedules(await getJwt(context), quickSchedules);
    Navigator.pop(context, ["delete", quickSchedules]);
  }
}
