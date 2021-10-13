import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/ArchivesDetail.dart';
import 'package:flutter_webservice/input/SchedulesInput.dart';
import 'package:flutter_webservice/widgets/DateWidget.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_webservice/functions.dart';
import 'package:flutter_webservice/modalBottomSheet/SchedulesInputModalBottomSheet.dart';
import 'package:flutter_webservice/modalBottomSheet/SchedulesDetailModalBottomSheet.dart';

class DaySchedulesList extends StatefulWidget {
  DaySchedulesList({Key? key, this.date, this.dayScheduleList, this.onRefreshChanged, this.onScheduleChanged}) : super(key: key);

  final DateTime? date;
  final List<Schedule>? dayScheduleList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<Schedule>? onScheduleChanged;

  @override
  _DaySchedulesListstate createState() => _DaySchedulesListstate();
}

class _DaySchedulesListstate extends State<DaySchedulesList> {
  @override
  void initState() {
    super.initState();
    widget.onRefreshChanged!('');
    widget.onScheduleChanged!(Schedule());
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
            Expanded(child: Center(child: monthDayWeekdayDateWidget(datetime: widget.date, context: context))),
            IconButton(onPressed: () => _awaitReturnValueFromSchedulesInput(), icon: Icon(Icons.add)),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        Container(
            child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List.generate(widget.dayScheduleList!.length,
                    (i) => listViewDaySchedules(index: i, schedule: widget.dayScheduleList![i], width: _width, context: context)).toList())),
        SizedBox(
          height: 50,
        ),
        TextButton(onPressed: () {}, child: Text(("나만의 일정 빠르게 추가"))),
      ],
    )));
  }

  Widget listViewDaySchedules({required int index, required Schedule schedule, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () => _awaitReturnValueFromScheduleDetail(schedule, index),
        child: Container(
            width: width,
            padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.circle,
                color: MyFunction.parseColor(schedule.labels!.label_colors!.code!),
              ),
              SizedBox(
                width: 10,
              ),
              Text(schedule.title!),
            ])));
  }

  void _awaitReturnValueFromSchedulesInput() async {
    var awaitResult = await schedulesInputModalBottomSheet(widget.date!, context);
    if (awaitResult != null) {
      setState(() {
        widget.dayScheduleList!.add(awaitResult);
        widget.onRefreshChanged!('input');
        widget.onScheduleChanged!(awaitResult);
      });
    }
  }

  void _awaitReturnValueFromScheduleDetail(Schedule schedules, int index) async {
    var awaitResult = await schedulesDetailModalBottomSheet(schedules, context);
    print(awaitResult);
    if (awaitResult != null) {
      if (awaitResult[0] == "update") {
        setState(() {
          widget.dayScheduleList![index] = awaitResult[1];
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onScheduleChanged!(awaitResult[1]);
        });
      } else if (awaitResult[0] == "delete") {
        setState(() {
          widget.dayScheduleList!.removeAt(index);
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onScheduleChanged!(awaitResult[1]);
        });
      }
    }
  }
}
