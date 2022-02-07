import 'dart:async';

import 'package:flutter/material.dart';

import '../../calendar/CalendarTwoChoice.dart';
import '../../calendar/CalendarChoice.dart';

Future<DateTime> calendarChoiceModalBottomSheet(DateTime selectedDateTime, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: Theme.of(context).backgroundColor,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Wrap(
                  children: [
                    CalendarChoice(
                      selectedDateTime: selectedDateTime,
                    ),
                  ],
                ))),
      );
    },
  );
  if (result == null) {
    return selectedDateTime;
  } else {
    return result;
  }
}

Future<List<DateTime>> calendarTwoChoiceModalBottomSheet(DateTime startDateTime, DateTime endDateTime, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: Theme.of(context).backgroundColor,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    CalendarTwoChoice(
                      startDateTime: startDateTime,
                      endDateTime: endDateTime,
                      onStartDateTimeChanged: (onStartDateTimeChanged) {
                        startDateTime = onStartDateTimeChanged;
                      },
                      onEndDateTimeChanged: (onEndDateTimeChanged) {
                        endDateTime = onEndDateTimeChanged;
                      },
                    ),
                  ],
                ))),
      );
    },
  );
  if (result == null) {
    return [startDateTime, endDateTime];
  } else {
    return result;
  }
}
