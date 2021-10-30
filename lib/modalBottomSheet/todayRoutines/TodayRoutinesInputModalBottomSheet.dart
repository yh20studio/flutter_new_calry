import 'package:flutter/material.dart';
import 'package:flutter_new_calry/input/todayRoutines/TodayRoutinesInput.dart';
import 'package:flutter_new_calry/domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';
import 'package:flutter_new_calry/domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';

todayRoutinesInputModalBottomSheet(
  BuildContext context,
  TodayRoutinesGroups? todayRoutinesGroups,
  List<RoutinesGroupsUnions>? routinesGroupsUnionsList,
  List<Routines>? routinesList,
) async {
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
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: DraggableScrollableSheet(
                          initialChildSize: 1,
                          builder: (_, controller) {
                            return SingleChildScrollView(
                                child: Wrap(
                              children: [
                                TodayRoutinesInput(
                                    todayRoutinesGroups: todayRoutinesGroups,
                                    routinesGroupsUnionsList: routinesGroupsUnionsList,
                                    routinesList: routinesList,
                                    onTodayRoutinesGroupsChanged: (changed) {
                                      todayRoutinesGroups = changed;
                                    })
                              ],
                            ));
                          }))),
            );
          },
        );
      });

  if (result == null) {
    return ["refresh", todayRoutinesGroups];
  } else {
    return result;
  }
}
