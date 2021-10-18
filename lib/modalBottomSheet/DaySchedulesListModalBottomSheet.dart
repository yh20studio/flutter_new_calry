import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/list/QuickSchedulesList.dart';
import 'package:flutter_webservice/listItems.dart';
import 'package:flutter_webservice/calendar/CalendarTwoChoice.dart';
import 'package:flutter_webservice/functions.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webservice/list/DaySchedulesList.dart';

daySchedulesListModalBottomSheet(DateTime date, List<Schedules> dayScheduleList, List<QuickSchedules> quickScheduleList, BuildContext context) async {
  String action = '';
  Schedules scheduleChange = Schedules();

  var result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
                child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: DraggableScrollableSheet(
                      initialChildSize: 1,
                      builder: (_, controller) {
                        return SingleChildScrollView(
                            child: Wrap(
                          children: [
                            DaySchedulesList(
                              date: date,
                              dayScheduleList: dayScheduleList,
                              onRefreshChanged: (onRefreshChanged) {
                                action = onRefreshChanged;
                              },
                              onScheduleChanged: (onScheduleChanged) {
                                scheduleChange = onScheduleChanged;
                              },
                            ),
                            Divider(
                              color: Colors.black,
                              height: 1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            QuickSchedulesList(
                              date: date,
                              quickScheduleList: quickScheduleList,
                              onRefreshChanged: (onRefreshChanged) {},
                              onScheduleChanged: (onScheduleChanged) {
                                setModalState(() {
                                  dayScheduleList.add(onScheduleChanged);
                                  action = "input";
                                  scheduleChange = onScheduleChanged;
                                });
                              },
                              onQuickScheduleChanged: (onQuickScheduleChanged) {},
                            )
                          ],
                        ));
                      })),
            ));
          },
        );
      });

  return [action, scheduleChange];
}
