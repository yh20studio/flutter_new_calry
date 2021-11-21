import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/schedules/Schedules.dart';
import 'package:flutter_new_calry/domain/labels/Labels.dart';
import 'package:flutter_new_calry/domain/labelColors/LabelColors.dart';
import 'package:flutter_new_calry/modalBottomSheet/calendar/CalendarModalBottomSheet.dart';
import 'package:flutter_new_calry/modalBottomSheet/labels/LabelsModalBottomSheet.dart';
import 'package:flutter_new_calry/widgets/TextInputFormWidget.dart';
import 'package:flutter_new_calry/widgets/DateWidget.dart';
import 'package:flutter_new_calry/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_new_calry/modalBottomSheet/time/TimeModalBottomSheet.dart';
import 'package:flutter_new_calry/widgets/TimeWidget.dart';
import 'package:flutter_new_calry/controller/schedules/schedulesController.dart';
import 'package:flutter_new_calry/widgets/ContainerWidget.dart';

class SchedulesInput extends StatefulWidget {
  SchedulesInput({Key? key, this.selectedDate}) : super(key: key);
  final DateTime? selectedDate;
  @override
  _SchedulesInputstate createState() => _SchedulesInputstate();
}

class _SchedulesInputstate extends State<SchedulesInput> {
  DateTime now = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Labels labels = Labels(title: "레드", label_colors: LabelColors(code: "#ff7b7b"));
  List<Labels> labelsList = [];

  bool isSetTime = false;

  SharedPreferences? prefs;

  @override
  void initState() {
    awaitHttpFunctionGetLabels();
    startDate = widget.selectedDate!;
    endDate = widget.selectedDate!;
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
              onPressed: _httpPostSchedules,
              child: Text("저장"),
            ),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        dateTimeInputForm(start: startDate!, end: endDate!, title: '일정', width: _width, context: context),
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
              });
            },
            activeTrackColor: Colors.yellow,
            activeColor: Colors.orangeAccent,
          ),
        ),
        isSetTime ? timeInputForm(start: startTime!, end: endTime!, width: _width, context: context) : SizedBox(),
        SizedBox(
          height: 10,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: textInputForm(controller: _titleController, title: 'Title', width: _width, context: context),
        ),
        SizedBox(
          height: 10,
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

  void _httpPostSchedules() async {
    DateTime startDateTime;
    DateTime endDateTime;
    if (isSetTime == true) {
      startDateTime = DateTime.utc(startDate!.year, startDate!.month, startDate!.day, startTime!.hour, startTime!.minute);
      endDateTime = DateTime.utc(startDate!.year, endDate!.month, endDate!.day, endTime!.hour, endTime!.minute);
    } else {
      startDateTime = DateTime.utc(startDate!.year, startDate!.month, startDate!.day);
      endDateTime = DateTime.utc(startDate!.year, endDate!.month, endDate!.day);
    }

    Schedules schedules =
        Schedules(startDate: startDateTime, endDate: endDateTime, title: _titleController.text, content: _contentController.text, labels: labels);
    var httpResult = await postSchedules(schedules);
    Navigator.pop(context, httpResult);
  }
}
