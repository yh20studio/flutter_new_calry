import 'package:flutter/material.dart';

import '../../list/routines/RoutinesListForTodayRoutines.dart';
import '../../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import '../../domain/routines/Routines.dart';

routinesListForTodayRoutinesModalBottomSheet(TodayRoutinesGroups? todayRoutinesGroups, List<Routines> routinesList, BuildContext context) async {
  String action = "";

  await showModalBottomSheet<dynamic>(
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
                                RoutinesListForTodayRoutines(
                                    todayRoutinesGroups: todayRoutinesGroups,
                                    routinesList: routinesList,
                                    onRefreshChanged: (onRefreshChanged) {
                                      action = onRefreshChanged;
                                    },
                                    onTodayRoutinesGroupsChanged: (onTodayRoutinesGroupsChanged) {
                                      todayRoutinesGroups = onTodayRoutinesGroupsChanged;
                                    })
                              ],
                            ));
                          }))),
            );
          },
        );
      });

  return [action, todayRoutinesGroups];
}
