import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/schedules/Schedules.dart';
import 'package:flutter_new_calry/widgets/DateWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_new_calry/functions.dart';
import 'package:flutter_new_calry/modalBottomSheet/Schedules/SchedulesInputModalBottomSheet.dart';
import 'package:flutter_new_calry/modalBottomSheet/Schedules/SchedulesDetailModalBottomSheet.dart';

class DaySchedulesList extends StatefulWidget {
  DaySchedulesList({Key? key, this.date, this.dayScheduleList, this.onRefreshChanged, this.onScheduleChanged}) : super(key: key);

  final DateTime? date;
  final List<Schedules>? dayScheduleList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<Schedules>? onScheduleChanged;

  @override
  _DaySchedulesListstate createState() => _DaySchedulesListstate();
}

class _DaySchedulesListstate extends State<DaySchedulesList> {
  @override
  void initState() {
    super.initState();
    widget.onRefreshChanged!('');
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
            Expanded(child: Center(child: monthDayWeekdayDateWidget(datetime: widget.date, context: context))),
            IconButton(onPressed: () => _awaitReturnValueFromSchedulesInput(), icon: Icon(Icons.add)),
          ],
        )),
        SizedBox(
          height: 30,
        ),
        widget.dayScheduleList!.length == 0
            ? Center(
                child: Text("추가한 일정이 없습니다."),
              )
            : Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: List.generate(widget.dayScheduleList!.length,
                        (i) => listViewDaySchedules(index: i, schedules: widget.dayScheduleList![i], width: _width, context: context)).toList())),
        SizedBox(
          height: 30,
        ),
      ],
    )));
  }

  Widget listViewDaySchedules({required int index, required Schedules schedules, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () => _awaitReturnValueFromScheduleDetail(schedules, index),
        child: Container(
            width: width,
            padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.circle,
                color: MyFunction.parseColor(schedules.labels!.label_colors!.code!),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text(schedules.title!)),
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

  void _awaitReturnValueFromScheduleDetail(Schedules schedules, int index) async {
    var awaitResult = await schedulesDetailModalBottomSheet(schedules, context);

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
