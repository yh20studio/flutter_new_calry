import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';

final List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];

Widget monthDayWeekdayDateWidget({required DateTime? datetime, required BuildContext context}) {
  int weekday;
  datetime!.weekday == 7 ? weekday = 0 : weekday = datetime.weekday;

  return Text(
    "${datetime.month}월 ${datetime.day}일 ${weekDays[weekday]}",
    style: TextStyle(color: Colors.black),
  );
}

Widget yearMonthDateWidget({required DateTime? datetime, required BuildContext context}) {
  return Text(
    "${datetime!.year}년 ${datetime.month}월",
    style: TextStyle(color: Colors.black),
  );
}

Widget summaryHeaderDateWidget({required DateTime? datetime, required BuildContext context}) {
  return Stack(
    children: [
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.black,
          ),
          Text(
            "${datetime!.year}년 ",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${datetime.month}월 ",
            style: TextStyle(color: Colors.black),
          ),
        ],
      )),
    ],
  );
}

Widget summaryDateWidget({required String? title, required DateTime? datetime, required BuildContext context}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text("${title}"),
      SizedBox(
        height: 5,
      ),
      Container(
          padding: EdgeInsets.all(5),
          color: title == "시작" ? Colors.purple.withOpacity(0.5) : Colors.orange.withOpacity(0.5),
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
          ))
    ],
  );
}

Widget monthDayDateWidget({required DateTime? datetime, required BuildContext context}) {
  return Text(
    "${datetime!.month}월 ${datetime.day}일",
    style: TextStyle(color: Colors.black),
  );
}

Widget dayDateWidget({required DateTime? datetime, required bool holiday, required BuildContext context}) {
  return Text("${datetime!.day}", style: TextStyle(color: holiday ? Colors.red : Colors.black, fontSize: Theme.of(context).textTheme.subtitle1!.fontSize));
}
