import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/modalBottomSheet/CalendarModalBottomSheet.dart';
import 'package:flutter_webservice/modalBottomSheet/LabelsModalBottomSheet.dart';

import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';
import 'package:flutter_webservice/widgets/DateWidget.dart';
import 'package:flutter_webservice/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulesInput extends StatefulWidget {
  SchedulesInput({Key? key, this.selectedDate}) : super(key: key);
  final DateTime? selectedDate;
  @override
  _SchedulesInputstate createState() => _SchedulesInputstate();
}

class _SchedulesInputstate extends State<SchedulesInput> {
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Labels labels = Labels(title: "레드", label_colors: LabelColors(code: "#ff7b7b"));
  List<Labels> labelsList = [];

  SharedPreferences? prefs;

  @override
  void initState() {
    awaitHttpFunctionGetLabels();
    startDate = widget.selectedDate!;
    endDate = widget.selectedDate!;
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
    var _height = MediaQuery.of(context).size.height;
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
              onPressed: _httpPostSchedules,
              child: Text("저장"),
            ),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        dateTimeInputForm(start: startDate!, end: endDate!, title: '일정', width: _width, context: context),
        textInputForm(controller: _titleController, title: 'Title', width: _width, context: context),
        textInputForm(controller: _contentController, title: 'Content', width: _width, context: context),
        labelsInputForm(labelsList: labelsList, width: _width, context: context),
      ],
    )));
  }

  Widget dateTimeInputForm({required DateTime start, required DateTime end, required String title, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _calendarModalBottomSheet() async {
            var result = await calendarTwoChoiceModalBottomSheet(start, end, context);
            setState(() {
              print(result[0].toString());
              print(result[0].toIso8601String());
              print(result[0].toLocal());
              startDate = result[0];
              endDate = result[1];
            });
          }

          _calendarModalBottomSheet();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(title, style: Theme.of(context).textTheme.headline2),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  monthDayWeekdayDateWidget(datetime: start, context: context),
                  Text(
                    " ~ ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  monthDayWeekdayDateWidget(datetime: end, context: context),
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

  void _httpPostSchedules() async {
    Schedule schedule = Schedule(startDate: startDate, endDate: endDate, title: _titleController.text, content: _contentController.text, labels: labels);
    var httpResult = await postSchedules(schedule);
    Navigator.pop(context, httpResult);
  }
}
