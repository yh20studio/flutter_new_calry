import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/calendars/WeekCalendars.dart';
import 'package:flutter_new_calry/functions.dart';
import 'dart:ui';
import 'package:flutter_new_calry/domain/schedules/Schedules.dart';
import 'package:flutter_new_calry/domain/quickSchedules/QuickSchedules.dart';
import 'package:flutter_new_calry/widgets/WeekdayWidget.dart';
import 'package:flutter_new_calry/widgets/DateWidget.dart';
import 'package:flutter_new_calry/modalBottomSheet/schedules/DaySchedulesListModalBottomSheet.dart';
import 'package:flutter_new_calry/modalBottomSheet/calendar/CalendarModalBottomSheet.dart';
import 'package:flutter_new_calry/calendar/Calendar.dart';
import 'package:flutter_new_calry/controller/quickSchedules/QuickSchedulesController.dart';
import 'package:flutter_new_calry/domain/calendars/Calendars.dart';
import 'package:flutter_new_calry/controller/calendars/CalendarsController.dart';

class CalendarNewHome extends StatefulWidget {
  CalendarNewHome({Key? key, this.bodyHeight}) : super(key: key);
  final double? bodyHeight;

  @override
  _CalendarNewHomestate createState() => _CalendarNewHomestate();
}

class _CalendarNewHomestate extends State<CalendarNewHome> {
  DateTime _dateTime = DateTime.now();
  final PageController pageController = new PageController(initialPage: 3001);
  Map<int, Schedules> schedulesMap = {};
  Map<DateTime, Schedules> holidaysMap = {};

  //calendar
  Map<int, DateTime> dateTimeMap = {};
  Map<DateTime, WeekCalendars> weekScheduleCalendar = {};
  Future<WeekSchedulesCalendar>? futureWeekSchedulesCalendar;
  int left_cnt = 0;
  bool isJumptoPage = false;

  Future<List<QuickSchedules>>? futureQuickSchedulesList;
  List<QuickSchedules>? quickSchedulesList;

  @override
  void initState() {
    super.initState();
    futureWeekSchedulesCalendar = getWholeSchedules();
    futureQuickSchedulesList = getQuickSchedules();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() => _getThreeCalendar());
    });
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    AppBar appBar = AppBar(
        title: InkWell(
            onTap: () => _awaitReturnValueFromDateTimeChoiceModalBottomSheet(),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: summaryHeaderDateWidget(datetime: _dateTime, context: context),
                  ),
                ],
              ),
            )),
        elevation: 0.0,
        backgroundColor: Colors.white);
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: appBar,
        ),
        body: Center(
            child: Container(
                child: Column(
          children: [
            Container(
              height: 35,
              child: weekdayWidget(context: context),
            ),
            Expanded(
                child: FutureBuilder<WeekSchedulesCalendar>(
                    future: futureWeekSchedulesCalendar,
                    builder: (BuildContext context, AsyncSnapshot snapshotWeekSchedulesCalendar) {
                      if (!snapshotWeekSchedulesCalendar.hasData) {
                        print('no data');
                        return Container();
                      } else if (snapshotWeekSchedulesCalendar.hasError) {
                        return Text("Error");
                      } else {
                        weekScheduleCalendar = snapshotWeekSchedulesCalendar.data!.weekCalendars;
                        schedulesMap = snapshotWeekSchedulesCalendar.data!.schedules;
                        holidaysMap = snapshotWeekSchedulesCalendar.data!.holidays;
                        return FutureBuilder<List<QuickSchedules>>(
                            future: futureQuickSchedulesList,
                            builder: (BuildContext context, AsyncSnapshot snapshotQuickSchedules) {
                              if (!snapshotQuickSchedules.hasData) {
                                print('no data');
                                return Container();
                              } else if (snapshotQuickSchedules.hasError) {
                                print('Error');
                                return Text('Error');
                              } else {
                                quickSchedulesList = snapshotQuickSchedules.data!;
                                return PageView.builder(
                                    scrollDirection: Axis.horizontal,
                                    controller: pageController,
                                    onPageChanged: (i) {
                                      // next Month

                                      if (pageController.page! < i) {
                                        setState(() {
                                          DateTime _nextMonth = _getNextMonth(_dateTime);
                                          DateTime _next2Month = _getNextMonth(_nextMonth);
                                          if (!dateTimeMap.containsKey(i + 1)) {
                                            dateTimeMap[i + 1] = _next2Month;
                                          }
                                          _dateTime = _nextMonth;
                                        });
                                      }
                                      // prev Month
                                      else if (pageController.page! > i) {
                                        setState(() {
                                          DateTime _prevMonth = _getPrevMonth(_dateTime);
                                          DateTime _prev2Month = _getPrevMonth(_prevMonth);
                                          if (!dateTimeMap.containsKey(i - 1)) {
                                            dateTimeMap[i - 1] = _prev2Month;
                                          }
                                          _dateTime = _prevMonth;
                                        });
                                      } else {}
                                    },
                                    itemBuilder: (context, index) {
                                      DateTime dateTime = dateTimeMap[index]!;
                                      List<Calendar> sequentialDates =
                                          CustomCalendar().getMonthCalendar(dateTime.month, dateTime.year, startWeekDay: StartWeekDay.sunday);
                                      List weekDateCalendar =
                                          List.generate(sequentialDates.length ~/ 7, (i) => List.generate(7, (j) => sequentialDates[i * 7 + j]));
                                      List<GlobalKey> keyList = List.generate(weekDateCalendar.length, (index) => GlobalKey()).toList();
                                      return Container(
                                          child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: widget.bodyHeight! - 50 - 35,
                                              ),
                                              child: ListView.builder(
                                                  physics: new ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: weekDateCalendar.length,
                                                  itemBuilder: (context, i) {
                                                    return Container(
                                                        child: ConstrainedBox(
                                                            key: keyList[i],
                                                            constraints: BoxConstraints(
                                                                minHeight: (widget.bodyHeight! - 50 - 35) / (weekDateCalendar.length),
                                                                maxHeight: widget.bodyHeight!),
                                                            child: Stack(
                                                              children: [
                                                                listViewCalendar(
                                                                    dates: weekDateCalendar[i],
                                                                    schedules: schedulesMap,
                                                                    weekCalendars: weekScheduleCalendar[weekDateCalendar[i][0].date] == null
                                                                        ? WeekCalendars(weeks: [])
                                                                        : weekScheduleCalendar[weekDateCalendar[i][0].date]!,
                                                                    width: _width,
                                                                    context: context),
                                                                Positioned.fill(
                                                                  child: listViewOverlapCalendar(
                                                                      dates: weekDateCalendar[i],
                                                                      schedules: schedulesMap,
                                                                      weekCalendars: weekScheduleCalendar[weekDateCalendar[i][0].date] == null
                                                                          ? WeekCalendars(weeks: [])
                                                                          : weekScheduleCalendar[weekDateCalendar[i][0].date]!,
                                                                      quickSchedulesList: quickSchedulesList!,
                                                                      context: context),
                                                                )
                                                              ],
                                                            )));
                                                  })));
                                    });
                              }
                            });
                      }
                    })),
          ],
        ))));
  }

  void _getThreeCalendar() {
    DateTime _nextMonth;
    DateTime _prevMonth;
    if (_dateTime.month == 12) {
      _nextMonth = DateTime(_dateTime.year + 1, 1);
    } else {
      _nextMonth = DateTime(_dateTime.year, _dateTime.month + 1);
    }
    if (_dateTime.month == 1) {
      _prevMonth = DateTime(_dateTime.year - 1, 12);
    } else {
      _prevMonth = DateTime(_dateTime.year, _dateTime.month - 1);
    }
    dateTimeMap[3000] = _prevMonth;
    dateTimeMap[3001] = _dateTime;
    dateTimeMap[3002] = _nextMonth;
  }

  DateTime _getNextMonth(DateTime dateTime) {
    if (dateTime.month == 12) {
      dateTime = DateTime(dateTime.year + 1, 1);
    } else {
      dateTime = DateTime(dateTime.year, dateTime.month + 1);
    }
    return dateTime;
  }

  DateTime _getPrevMonth(DateTime dateTime) {
    if (dateTime.month == 1) {
      dateTime = DateTime(dateTime.year - 1, 12);
    } else {
      dateTime = DateTime(dateTime.year, dateTime.month - 1);
    }
    return dateTime;
  }

  void _awaitReturnValueFromDateTimeChoiceModalBottomSheet() async {
    var result = await calendarChoiceModalBottomSheet(_dateTime, context);
    if (result != null) {
      setState(() {
        _dateTime = result;
        DateTime _nextMonth = _getNextMonth(_dateTime);
        DateTime _prevMonth = _getPrevMonth(_dateTime);
        dateTimeMap.clear();
        dateTimeMap[3000] = _prevMonth;
        dateTimeMap[3001] = _dateTime;
        dateTimeMap[3002] = _nextMonth;
        pageController.jumpToPage(3001);
        isJumptoPage = true;
      });
    }
  }

  void _awaitReturnValueFromDaySchedulesList(DateTime date, List<Schedules> dayScheduleList, List<QuickSchedules> quickSchedulesList) async {
    var awaitResult = await daySchedulesListModalBottomSheet(date, dayScheduleList, quickSchedulesList, context);

    if (awaitResult != null && awaitResult[0] != '') {
      String action = awaitResult[0];
      List<Schedules> schedulesList = awaitResult[1];
      bool first = true;
      Map<DateTime, WeekCalendars>? weekCalendars;
      schedulesList.forEach((schedules) async {
        DateTime start = schedules.startDate!.subtract(Duration(days: schedules.startDate!.weekday == 7 ? 0 : schedules.startDate!.weekday));
        DateTime end = schedules.endDate!.add(Duration(days: schedules.endDate!.weekday == 7 ? 6 : 6 - schedules.endDate!.weekday));
        String updateStart = start.toIso8601String();
        String updateEnd = end.toIso8601String();
        updateStart = updateStart.substring(0, updateStart.length - 1);
        updateEnd = updateEnd.substring(0, updateEnd.length - 1);
        start = DateTime.parse(updateStart);
        end = DateTime.parse(updateEnd);
        if (first) {
          weekCalendars = (await getPartSchedules(updateStart, updateEnd)).weekCalendars;
        }

        if (action == 'input' || action == 'update') {
          setState(() {
            schedulesMap[schedules.id!] = schedules;
            weekCalendars!.forEach((key, value) {
              weekScheduleCalendar[key] = value;
            });
          });
        } else if (action == 'delete') {
          setState(() {
            schedulesMap.remove(schedules.id!);
            while (start.isBefore(end)) {
              weekScheduleCalendar.remove(start);
              start = start.add(Duration(days: 7));
            }
            weekCalendars!.forEach((key, value) {
              weekScheduleCalendar[key] = value;
            });
          });
        }
      });
    }
  }

  Widget listViewCalendar(
      {required List<Calendar> dates,
      required Map<int, Schedules> schedules,
      required WeekCalendars weekCalendars,
      required double width,
      required BuildContext context}) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              dates.length,
              (i) => Expanded(
                      child: Column(children: [
                    Container(
                        color: dates[i].date!.day == DateTime.now().day &&
                                dates[i].date!.month == DateTime.now().month &&
                                dates[i].date!.year == DateTime.now().year
                            ? Colors.amberAccent
                            : Colors.transparent,
                        child: Center(
                            child: dayDateWidget(
                          datetime: dates[i].date,
                          holiday: dates[i].date!.weekday == 7 ? true : holidaysMap.containsKey(dates[i].date),
                          context: context,
                        ))),
                  ]))).toList()),
      Wrap(
          runSpacing: 1.0,
          children: List.generate(
              weekCalendars.weeks!.length,
              (i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      weekCalendars.weeks![i].schedules!.length,
                      (j) => Expanded(
                          flex: weekCalendars.weeks![i].schedules![j].width!,
                          child: weekCalendars.weeks![i].schedules![j].scheduleId == -1
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(left: 1, right: 1),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 1, right: 1),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(3),
                                        color: MyFunction.parseColor(schedules[weekCalendars.weeks![i].schedules![j].scheduleId]!.labels!.label_colors!.code!)),
                                    child: Center(
                                        child: Text(
                                      "${schedules[weekCalendars.weeks![i].schedules![j].scheduleId]!.title}",
                                      style: Theme.of(context).textTheme.subtitle1,
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                    )),
                                  )))).toList())))
    ]);
  }

  Widget listViewOverlapCalendar(
      {required List<Calendar> dates,
      required Map<int, Schedules> schedules,
      required WeekCalendars weekCalendars,
      required List<QuickSchedules> quickSchedulesList,
      required BuildContext context}) {
    return Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: Colors.black))),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      dates.length,
                      (i) => Expanded(
                          child: InkWell(
                              onTap: () {
                                List<Schedules> dayScheduleList = [];
                                for (int index = 0; index < weekCalendars.weeks!.length; index++) {
                                  int gap = 0;
                                  for (int j = 0; j < weekCalendars.weeks![index].schedules!.length; j++) {
                                    if (gap == i) {
                                      if (weekCalendars.weeks![index].schedules![j].scheduleId != -1) {
                                        dayScheduleList.add(schedules[weekCalendars.weeks![index].schedules![j].scheduleId]!);
                                      }
                                      break;
                                    } else {
                                      if (i < weekCalendars.weeks![index].schedules![j].width! + gap) {
                                        dayScheduleList.add(schedules[weekCalendars.weeks![index].schedules![j].scheduleId]!);
                                        break;
                                      } else {
                                        gap = weekCalendars.weeks![index].schedules![j].width! + gap;
                                      }
                                    }
                                  }
                                }

                                _awaitReturnValueFromDaySchedulesList(dates[i].date!, dayScheduleList, quickSchedulesList);
                              },
                              child: Column(children: [])))).toList()))
        ]));
  }
}
