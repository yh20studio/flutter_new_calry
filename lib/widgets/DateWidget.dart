import 'package:flutter/material.dart';

import 'ContainerWidget.dart';

final List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];

Widget appBarMonthDayWeekdayDateWidget(
    {required DateTime? datetime, required BuildContext context}) {
  int weekday;
  datetime!.weekday == 7 ? weekday = 0 : weekday = datetime.weekday;
  return Text(
    "${datetime.month}월 ${datetime.day}일 ${weekDays[weekday]}",
    style: TextStyle(
      color: Theme.of(context).primaryColor,
    ),
  );
}

Widget monthDayWeekdayDateWidget(
    {required DateTime? datetime, required BuildContext context}) {
  int weekday;
  datetime!.weekday == 7 ? weekday = 0 : weekday = datetime.weekday;

  return Text(
    "${datetime.month}월 ${datetime.day}일 ${weekDays[weekday]}",
      style: TextStyle(fontWeight: FontWeight.w700)
  );
}

Widget yearMonthDateWidget(
    {required DateTime? datetime, required BuildContext context}) {
  return Text(
    "${datetime!.year}년 ${datetime.month}월",
    style: TextStyle(color: Colors.black),
  );
}

Widget summaryHeaderDateWidget(
    {required DateTime? datetime, required BuildContext context}) {
  return Stack(
    children: [
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Theme.of(context).hoverColor,
          ),
          Text(
            "${datetime!.year}년 ",
            style: TextStyle(color: Theme.of(context).hoverColor,),
          ),
          Text(
            "${datetime.month}월 ",
            style: TextStyle(color:Theme.of(context).hoverColor,),
          ),
        ],
      )),
    ],
  );
}

Widget summaryDateWidget(
    {required String? title,
    required DateTime? datetime,
    required BuildContext context}) {
  return Container(
      padding: EdgeInsets.all(10),
      color: title == "시작"
          ? Theme.of(context).primaryColor.withOpacity(0.5)
          : Colors.orange.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${datetime!.year}년",
                style: TextStyle(color: Colors.black38),
              ),
              Text(
                "${datetime.month}월",
                style: TextStyle(color: Colors.black38),
              )
            ],
          ),
          Text(
            " ${datetime.day}일",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ],
      ));
}

Widget monthDayDateWidget(
    {required DateTime? datetime, required BuildContext context}) {
  return Text(
    "${datetime!.month}월 ${datetime.day}일",
  );
}

Widget dayDateWidget(
    {required DateTime? datetime,
    required bool holiday,
    required BuildContext context}) {
  return Text("${datetime!.day}",
      style: TextStyle(
          color: holiday ? Colors.red : Theme.of(context).hoverColor,
          fontSize: Theme.of(context).textTheme.subtitle1!.fontSize));
}
