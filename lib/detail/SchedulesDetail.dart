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

import 'package:flutter_webservice/modalBottomSheet/CalendarModalBottomSheet.dart';
import 'package:flutter_webservice/modalBottomSheet/LabelsModalBottomSheet.dart';

import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';
import 'package:flutter_webservice/widgets/DateWidget.dart';
import 'package:flutter_webservice/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulesDetail extends StatefulWidget {
  SchedulesDetail({Key? key, this.schedules}) : super(key: key);
  final Schedule? schedules;

  @override
  _SchedulesDetailstate createState() => _SchedulesDetailstate();
}

class _SchedulesDetailstate extends State<SchedulesDetail> {
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Labels? labels;

  List<Labels> labelsList = [];

  SharedPreferences? prefs;

  @override
  void initState() {
    awaitHttpFunctionGetLabels();
    startDate = widget.schedules!.startDate;
    endDate = widget.schedules!.endDate;
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

  void _httpUpdateSchedules() async {
    Schedule schedule = Schedule(
        id: widget.schedules!.id, startDate: startDate, endDate: endDate, title: _titleController.text, content: _contentController.text, labels: labels);

    try {
      var httpResult = await updateSchedules(schedule);
      setState(() {
        Navigator.pop(context, ["update", httpResult]);
      });
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _httpDeleteSchedules() async {
    Schedule schedule = Schedule(
        id: widget.schedules!.id, startDate: startDate, endDate: endDate, title: _titleController.text, content: _contentController.text, labels: labels);

    try {
      var httpResult = await deleteSchedules(schedule);
      setState(() {
        Navigator.pop(context, ["${httpResult}", schedule]);
      });
    } on Exception catch (exception) {
      print(exception);
    }
  }
}
