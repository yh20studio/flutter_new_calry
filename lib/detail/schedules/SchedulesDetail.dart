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
import '../../controller/jwt/JwtController.dart';
import '../../widgets/ContainerWidget.dart';

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
            padding: EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _httpDeleteSchedules,
                  child: Text(
                    "삭제",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: Text("일정 편집",
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w700)))),
                TextButton(
                    onPressed: () => _httpUpdateSchedules(),
                    child: Text("저장",
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor))),
              ],
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
                "일정",
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
          widget:
        dateTimeInputForm(start: startDate!, end: endDate!, width: _width, context: context),
        )),
          SizedBox(height: 20,),
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
        )),
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

  Widget dateTimeInputForm({required DateTime start, required DateTime end, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _calendarModalBottomSheet() async {
            var result = await calendarTwoChoiceModalBottomSheet(start, end, context);
            setState(() {
              startDate = result[0];
              endDate = result[1];
            });
          }

          _calendarModalBottomSheet();
        },
        child:
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
            )
        );
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
      var httpResult = await updateSchedules(await getJwt(context), schedules);
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
      var httpResult = await deleteSchedules(await getJwt(context), schedules);
      setState(() {
        Navigator.pop(context, ["${httpResult}", schedules]);
      });
    } on Exception catch (exception) {
      print(exception);
    }
  }
}
