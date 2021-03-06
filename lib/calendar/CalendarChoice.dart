import 'package:flutter/material.dart';

import 'Calendar.dart';
import '../widgets/ContainerWidget.dart';

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
                      style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                _toggleBtn(false),
                _toggleBtn(true),
              ],
            )),
        Flexible(
            child: overlayContainerWidget(
        context: context,
    widget:PageView.builder(
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
                })))
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
          color: Theme.of(context).hoverColor,
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
      style: TextStyle(color: index == 0 ? Colors.red : Theme.of(context).hoverColor, fontSize: 14),
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
                  : Theme.of(context).hoverColor
              : (calendarDate.date!.weekday == DateTime.sunday)
                  ? Colors.red.withOpacity(0.5)
                  : Theme.of(context).hoverColor.withOpacity(0.5),
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
            style: TextStyle(color: Theme.of(context).hoverColor, fontWeight: FontWeight.w600),
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
          color: Theme.of(context).hoverColor
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
                  style: TextStyle(fontSize: 18, color: (index == currentDateTime!.month - 1) ? Theme.of(context).primaryColor : Theme.of(context).hoverColor),
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
            Expanded(child:Center(child:Text("연도 선택"))),
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
                  title: Center(child: Text(
                    '$thisYear',
                    style: TextStyle(fontSize: 18, color: (thisYear == currentDateTime!.year) ? Theme.of(context).primaryColor : Theme.of(context).hoverColor),
                  )),
                );
              }),
        ),
      ],
    );
  }
}
