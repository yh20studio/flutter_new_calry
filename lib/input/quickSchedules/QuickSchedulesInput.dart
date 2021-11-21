import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/quickSchedules/QuickSchedules.dart';
import 'package:flutter_new_calry/domain/labels/Labels.dart';
import 'package:flutter_new_calry/domain/labelColors/LabelColors.dart';
import 'package:flutter_new_calry/modalBottomSheet/time/TimeModalBottomSheet.dart';
import 'package:flutter_new_calry/modalBottomSheet/labels/LabelsModalBottomSheet.dart';
import 'package:flutter_new_calry/widgets/TextInputFormWidget.dart';
import 'package:flutter_new_calry/widgets/TimeWidget.dart';
import 'package:flutter_new_calry/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_new_calry/controller/quickSchedules/QuickSchedulesController.dart';
import 'package:flutter_new_calry/widgets/ContainerWidget.dart';

class QuickSchedulesInput extends StatefulWidget {
  QuickSchedulesInput({Key? key}) : super(key: key);

  @override
  _QuickSchedulesInputstate createState() => _QuickSchedulesInputstate();
}

class _QuickSchedulesInputstate extends State<QuickSchedulesInput> {
  DateTime now = DateTime.now();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Labels labels = Labels(title: "레드", label_colors: LabelColors(code: "#ff7b7b"));
  List<Labels> labelsList = [];

  SharedPreferences? prefs;

  bool isSetTime = false;

  @override
  void initState() {
    awaitHttpFunctionGetLabels();
    startTime = TimeOfDay(hour: now.hour, minute: now.minute);
    endTime = TimeOfDay(hour: now.hour, minute: now.minute);
    super.initState();
  }

  void awaitHttpFunctionGetLabels() async {
    prefs = await SharedPreferences.getInstance();
    final String labelString = await prefs!.getString('labels')!;
    setState(() {
      labelsList = Labels.decode(labelString);
      labels = labelsList[0];
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
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
            TextButton(
              onPressed: _httpPostQuickSchedules,
              child: Text("저장"),
            ),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text("시간 설정", style: Theme.of(context).textTheme.headline2),
        ),
        Center(
          child: Switch(
            value: isSetTime,
            onChanged: (value) {
              setState(() {
                isSetTime = value;
                print(isSetTime);
              });
            },
            activeTrackColor: Colors.yellow,
            activeColor: Colors.orangeAccent,
          ),
        ),
        isSetTime ? timeInputForm(start: startTime!, end: endTime!, width: _width, context: context) : SizedBox(),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: textInputForm(controller: _titleController, title: 'Title', width: _width, context: context),
        ),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: textInputForm(controller: _contentController, title: 'Content', width: _width, context: context),
        ),
        SizedBox(
          height: 20,
        ),
        labelsInputForm(labelsList: labelsList, width: _width, context: context),
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

  void _httpPostQuickSchedules() async {
    QuickSchedules quickSchedules = QuickSchedules(
        startTime: isSetTime ? startTime : null,
        endTime: isSetTime ? endTime : null,
        title: _titleController.text,
        content: _contentController.text,
        labels: labels);
    var httpResult = await postQuickSchedules(quickSchedules);
    Navigator.pop(context, httpResult);
  }
}
