import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/schedules/Schedules.dart';
import '../../domain/labels/Labels.dart';
import '../../widgets/TextInputFormWidget.dart';
import '../../widgets/DateWidget.dart';
import '../../modalBottomSheet/calendar/CalendarModalBottomSheet.dart';
import '../../modalBottomSheet/labels/LabelsModalBottomSheet.dart';
import '../../functions.dart';
import '../../modalBottomSheet/time/TimeModalBottomSheet.dart';
import '../../widgets/TimeWidget.dart';
import '../../controller/schedules/SchedulesController.dart';

class SchedulesDetail extends StatefulWidget {
  SchedulesDetail({Key? key, this.schedules}) : super(key: key);
  final Schedules? schedules;

  @override
  _SchedulesDetailstate createState() => _SchedulesDetailstate();
}

class _SchedulesDetailstate extends State<SchedulesDetail> {
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Labels? labels;

  List<Labels> labelsList = [];

  bool? isSetTime;

  SharedPreferences? prefs;

  @override
  void initState() {
    awaitHttpFunctionGetLabels();
    startDate = DateTime(widget.schedules!.startDate!.year, widget.schedules!.startDate!.month, widget.schedules!.startDate!.day);
    endDate = DateTime(widget.schedules!.endDate!.year, widget.schedules!.endDate!.month, widget.schedules!.endDate!.day);

    startTime = TimeOfDay(hour: widget.schedules!.startDate!.hour, minute: widget.schedules!.startDate!.minute);
    endTime = TimeOfDay(hour: widget.schedules!.endDate!.hour, minute: widget.schedules!.endDate!.minute);

    if (startTime == endTime && startTime == TimeOfDay(hour: 0, minute: 0)) {
      isSetTime = false;
    } else {
      isSetTime = true;
    }

    _titleController.text = widget.schedules!.title!;
    _contentController.text = widget.schedules!.content!;
    labels = widget.schedules!.labels!;
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
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _httpDeleteSchedules,
              child: Text(
                "삭제",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: _httpUpdateSchedules,
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
            value: isSetTime!,
            onChanged: (value) {
              setState(() {
                isSetTime = value;
              });
            },
            activeTrackColor: Colors.yellow,
            activeColor: Colors.orangeAccent,
          ),
        ),
        isSetTime! ? timeInputForm(start: startTime!, end: endTime!, width: _width, context: context) : SizedBox(),
        textInputForm(controller: _titleController, title: 'Title', width: _width, context: context),
        textInputForm(controller: _contentController, title: 'Content', width: _width, context: context),
        SizedBox(
          height: 10,
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
                      color: MyFunction.parseColor(labels!.label_colors!.code!),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("${labels!.title}", style: Theme.of(context).textTheme.headline2),
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

  void _httpUpdateSchedules() async {
    DateTime startDateTime;
    DateTime endDateTime;
    if (isSetTime == true) {
      startDateTime = DateTime.utc(startDate!.year, startDate!.month, startDate!.day, startTime!.hour, startTime!.minute);
      endDateTime = DateTime.utc(startDate!.year, endDate!.month, endDate!.day, endTime!.hour, endTime!.minute);
    } else {
      startDateTime = DateTime.utc(startDate!.year, startDate!.month, startDate!.day);
      endDateTime = DateTime.utc(startDate!.year, endDate!.month, endDate!.day);
    }
    Schedules schedules = Schedules(
        id: widget.schedules!.id,
        startDate: startDateTime,
        endDate: endDateTime,
        title: _titleController.text,
        content: _contentController.text,
        labels: labels);

    try {
      var httpResult = await updateSchedules(schedules);
      setState(() {
        Navigator.pop(context, ["update", httpResult]);
      });
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _httpDeleteSchedules() async {
    DateTime startDateTime;
    DateTime endDateTime;
    if (isSetTime == true) {
      startDateTime = DateTime.utc(startDate!.year, startDate!.month, startDate!.day, startTime!.hour, startTime!.minute);
      endDateTime = DateTime.utc(startDate!.year, endDate!.month, endDate!.day, endTime!.hour, endTime!.minute);
    } else {
      startDateTime = DateTime.utc(startDate!.year, startDate!.month, startDate!.day);
      endDateTime = DateTime.utc(startDate!.year, endDate!.month, endDate!.day);
    }
    Schedules schedules = Schedules(
        id: widget.schedules!.id,
        startDate: startDateTime,
        endDate: endDateTime,
        title: _titleController.text,
        content: _contentController.text,
        labels: labels);

    try {
      var httpResult = await deleteSchedules(schedules);
      setState(() {
        Navigator.pop(context, ["${httpResult}", schedules]);
      });
    } on Exception catch (exception) {
      print(exception);
    }
  }
}
