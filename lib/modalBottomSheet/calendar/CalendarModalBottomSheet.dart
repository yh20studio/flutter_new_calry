import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_new_calry/calendar/CalendarTwoChoice.dart';
import 'package:flutter_new_calry/calendar/CalendarChoice.dart';

Future<DateTime> calendarChoiceModalBottomSheet(DateTime selectedDateTime, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
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
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
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
