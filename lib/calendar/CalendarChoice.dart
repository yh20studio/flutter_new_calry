import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/ArchivesDetail.dart';
import 'package:flutter_webservice/input/SchedulesInput.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_webservice/widgets/DateWidget.dart';

enum CalendarViews { dates, months, year }
enum StartWeekDay { sunday, monday }

class CalendarChoice extends StatefulWidget {
  CalendarChoice({Key? key, this.selectedDateTime}) : super(key: key);
  final DateTime? selectedDateTime;

  @override
  _CalendarChoiceState createState() => _CalendarChoiceState();
}

class _CalendarChoiceState extends State<CalendarChoice> {
  CalendarViews currentView = CalendarViews.dates;

  DateTime? currentDateTime;
  DateTime? selectedDateTime;

  bool startSelect = false;
  bool endSelect = false;

  List<Calendar>? sequentialDates;
  int? midYear;
  // final List<String> weekDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  final List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];
  // final List<String> monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  final List<String> monthNames = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

  //PageView
  final PageController pageController = new PageController(initialPage: 4242);

  @override
  void initState() {
    super.initState();
    currentDateTime = DateTime(widget.selectedDateTime!.year, widget.selectedDateTime!.month);
    selectedDateTime = DateTime(widget.selectedDateTime!.year, widget.selectedDateTime!.month, widget.selectedDateTime!.day);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  // get calendar for current month
  void _getCalendar() {
    sequentialDates = CustomCalendar().getMonthCalendar(currentDateTime!.month, currentDateTime!.year, startWeekDay: StartWeekDay.sunday);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 16),
            height: 400,
            child: (currentView == CalendarViews.dates)
                ? _datesView()
                : (currentView == CalendarViews.months)
                    ? _showMonthsList()
                    : _yearsView(midYear ?? currentDateTime!.year)));
  }

  Widget _datesView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // prev month button
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // explained in later stages
                        currentView = CalendarViews.months;
                      });
                    },
                    child: Text(
                      '${currentDateTime!.year}년 ${monthNames[currentDateTime!.month - 1]}',
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                _toggleBtn(false),
                _toggleBtn(true),
              ],
            )),
        Flexible(
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: pageController,
                onPageChanged: (i) {
                  // right directioon
                  if (pageController.page! < i) {
                    if (currentView == CalendarViews.dates) {
                      setState(() => _getNextMonth());
                    } else if (currentView == CalendarViews.year) {
                      setState(() {
                        midYear = (midYear == null) ? currentDateTime!.year + 9 : midYear! + 9;
                      });
                    }
                  }
                  // left directioon
                  else {
                    if (currentView == CalendarViews.dates) {
                      setState(() => _getPrevMonth());
                    } else if (currentView == CalendarViews.year) {
                      setState(() {
                        midYear = (midYear == null) ? currentDateTime!.year - 9 : midYear! - 9;
                      });
                    }
                  }
                },
                itemBuilder: (context, index) {
                  return _calendarBody();
                }))
      ],
    );
  }

  // next / prev month buttons
  Widget _toggleBtn(bool next) {
    return InkWell(
      // explained in later stages
      onTap: () {
        if (currentView == CalendarViews.dates) {
          setState(() => (next) ? _getNextMonth() : _getPrevMonth());
        } else if (currentView == CalendarViews.year) {
          if (next) {
            midYear = (midYear == null) ? currentDateTime!.year + 9 : midYear! + 9;
          } else {
            midYear = (midYear == null) ? currentDateTime!.year - 9 : midYear! - 9;
          }
          setState(() {});
        }
      },
      child: Container(
        width: 50,
        height: 50,
        child: Icon(
          (next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }

  // calendar body
  Widget _calendarBody() {
    if (sequentialDates == null) return Container();
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: sequentialDates!.length + 7,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 0,
        crossAxisCount: 7,
        crossAxisSpacing: 5,
        childAspectRatio: (MediaQuery.of(context).size.width / 350),
      ),
      itemBuilder: (context, index) {
        if (index < 7) return _weekDayTitle(index);
        if (sequentialDates![index - 7].date == selectedDateTime)
          return _selector(
            sequentialDates![index - 7],
          );
        return _calendarDates(sequentialDates![index - 7]);
      },
    );
  }

  // calendar header
  Widget _weekDayTitle(int index) {
    return Center(
        child: Text(
      weekDays[index],
      style: TextStyle(color: index == 0 ? Colors.red : Colors.black, fontSize: 14),
    ));
  }

  // calendar element
  Widget _calendarDates(Calendar calendarDate) {
    return InkWell(
      onTap: () {
        if (selectedDateTime != calendarDate.date) {
          if (calendarDate.nextMonth) {
            _getNextMonth();
          } else if (calendarDate.prevMonth) {
            _getPrevMonth();
          }
          setState(() {
            Navigator.pop(context, calendarDate.date);
          });
        }
      },
      child: Center(
          child: Text(
        '${calendarDate.date!.day}',
        style: TextStyle(
          color: (calendarDate.thisMonth)
              ? (calendarDate.date!.weekday == DateTime.sunday)
                  ? Colors.red
                  : Colors.black
              : (calendarDate.date!.weekday == DateTime.sunday)
                  ? Colors.red.withOpacity(0.5)
                  : Colors.black.withOpacity(0.5),
        ),
      )),
    );
  }

  // date selector
  Widget _selector(Calendar calendarDate) {
    return Container(
      width: 30,
      height: 30,
      // decoration: BoxDecoration(
      //   color: Colors.transparent,
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: type == 1 ? Colors.orange : Colors.purple, width: 2),
      // ),
      // child: Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10),
      //     border: Border.all(color: Colors.orange, width: type == 2 ? 2 : 0),
      //   ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${calendarDate.date!.day}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),

          // Text(
          //   type == 0
          //       ? "Start"
          //       : type == 1
          //           ? "End"
          //           : "Same",
          //   style: TextStyle(color: Colors.black, fontSize: 10),
          // )
        ],
      ),
    );
  }

  // get next month calendar
  void _getNextMonth() {
    if (currentDateTime!.month == 12) {
      currentDateTime = DateTime(currentDateTime!.year + 1, 1);
    } else {
      currentDateTime = DateTime(currentDateTime!.year, currentDateTime!.month + 1);
    }
    _getCalendar();
  }

  // get previous month calendar
  void _getPrevMonth() {
    if (currentDateTime!.month == 1) {
      currentDateTime = DateTime(currentDateTime!.year - 1, 12);
    } else {
      currentDateTime = DateTime(currentDateTime!.year, currentDateTime!.month - 1);
    }
    _getCalendar();
  }

  // show months list
  Widget _showMonthsList() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              //switch to years views
              currentView = CalendarViews.year;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '${currentDateTime!.year}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Divider(
          color: Colors.black,
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: monthNames.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                // change month of currentDateTime
                currentDateTime = DateTime(currentDateTime!.year, index + 1);
                _getCalendar();
                // switch back to dates view
                setState(() => currentView = CalendarViews.dates);
              },
              title: Center(
                child: Text(
                  monthNames[index],
                  style: TextStyle(fontSize: 18, color: (index == currentDateTime!.month - 1) ? Colors.yellow : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // years list views
  Widget _yearsView(int midYear) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _toggleBtn(false),
            Spacer(),
            _toggleBtn(true),
          ],
        ),
        Expanded(
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                int thisYear;
                if (index < 4) {
                  thisYear = midYear - (4 - index);
                } else if (index > 4) {
                  thisYear = midYear + (index - 4);
                } else {
                  thisYear = midYear;
                }
                return ListTile(
                  onTap: () {
                    // change year of currentDateTime
                    currentDateTime = DateTime(thisYear, currentDateTime!.month);
                    _getCalendar();
                    // switch back to months view
                    setState(() => currentView = CalendarViews.months);
                  },
                  title: Text(
                    '$thisYear',
                    style: TextStyle(fontSize: 18, color: (thisYear == currentDateTime!.year) ? Colors.yellow : Colors.black),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class Calendar {
  final DateTime? date;
  final bool thisMonth;
  final bool prevMonth;
  final bool nextMonth;
  Calendar({this.date, this.thisMonth = false, this.prevMonth = false, this.nextMonth = false});
}

class CustomCalendar {
// number of days in month
  //[JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC]
  final List<int> monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
// check for leap year
  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) return true;
        return false;
      }
      return true;
    }
    return false;
  }

  List<Calendar> getMonthCalendar(int month, int year, {StartWeekDay startWeekDay = StartWeekDay.sunday}) {
    // validate
    if (year == null || month == null || month < 1 || month > 12) throw ArgumentError('Invalid year or month');
    List<Calendar> calendar = [];
    // get no. of days in the month
    // month-1 because _monthDays starts from index 0
    // and month starts from 1
    int totalDays = monthDays[month - 1];
    // if this is a leap year and the month is february,
    // increment the total days by 1
    if (isLeapYear(year) && month == DateTime.february) totalDays++;
    // get days for this month
    for (int i = 0; i < totalDays; i++) {
      calendar.add(
        Calendar(
          // i+1 because day starts from 1 in DateTime class
          date: DateTime(year, month, i + 1),
          thisMonth: true,
        ),
      );
    }
    // used for previous and next month's calendar days
    int otherYear;
    int otherMonth;
    int leftDays;
    // fill the unfilled starting weekdays of this month
    // with the previous month days
    if ((startWeekDay == StartWeekDay.sunday && calendar.first.date!.weekday != DateTime.sunday) ||
        (startWeekDay == StartWeekDay.monday && calendar.first.date!.weekday != DateTime.monday)) {
      // if this month is january,
      // then previous month would be decemeber of previous year
      if (month == DateTime.january) {
        otherMonth = DateTime.december;
        otherYear = year - 1;
      } else {
        otherMonth = month - 1;
        otherYear = year;
      }
      // month-1 because _monthDays starts from index 0
      // and month starts from 1
      totalDays = monthDays[otherMonth - 1];
      if (isLeapYear(otherYear) && otherMonth == DateTime.february) totalDays++;
      leftDays = totalDays - calendar.first.date!.weekday + ((startWeekDay == StartWeekDay.sunday) ? 0 : 1);

      for (int i = totalDays; i > leftDays; i--) {
        // add days to the start of the list to maintain the sequence
        calendar.insert(
          0,
          Calendar(
            date: DateTime(otherYear, otherMonth, i),
            prevMonth: true,
          ),
        );
      }
    }
    // fill the unfilled ending weekdays of this month
    // with the next month days
    if ((startWeekDay == StartWeekDay.sunday && calendar.last.date!.weekday != DateTime.saturday) ||
        (startWeekDay == StartWeekDay.monday && calendar.last.date!.weekday != DateTime.sunday)) {
      // if this month is december,
      // then next month would be january of next year
      if (month == DateTime.december) {
        otherMonth = DateTime.january;
        otherYear = year + 1;
      } else {
        otherMonth = month + 1;
        otherYear = year;
      }
      // month-1 because _monthDays starts from index 0
      // and month starts from 1
      totalDays = monthDays[otherMonth - 1];
      if (isLeapYear(otherYear) && otherMonth == DateTime.february) totalDays++;
      leftDays = 7 - calendar.last.date!.weekday - ((startWeekDay == StartWeekDay.sunday) ? 1 : 0);
      if (leftDays == -1) leftDays = 6;
      for (int i = 0; i < leftDays; i++) {
        calendar.add(
          Calendar(
            date: DateTime(otherYear, otherMonth, i + 1),
            nextMonth: true,
          ),
        );
      }
    }
    return calendar;
  }
}
