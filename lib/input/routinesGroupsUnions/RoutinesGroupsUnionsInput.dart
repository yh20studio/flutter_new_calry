import 'package:flutter/material.dart';
import 'package:flutter_new_calry/widgets/TextInputFormWidget.dart';
import 'package:flutter_new_calry/modalBottomSheet/routines/RoutinesListForRoutinesGroupsModalBottomSheet.dart';
import 'package:flutter_new_calry/controller/routines/RoutinesController.dart';
import 'package:flutter_new_calry/controller/routinesGroupsUnion/RoutinesGroupsUnionsController.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';
import 'package:flutter_new_calry/domain/routinesGroups/RoutinesGroups.dart';
import 'package:flutter_new_calry/domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';
import 'package:flutter_new_calry/widgets/ContainerWidget.dart';

class RoutinesGroupsUnionsInput extends StatefulWidget {
  RoutinesGroupsUnionsInput({Key? key}) : super(key: key);

  @override
  _RoutinesGroupsUnionsInputstate createState() => _RoutinesGroupsUnionsInputstate();
}

class _RoutinesGroupsUnionsInputstate extends State<RoutinesGroupsUnionsInput> {
  TextEditingController _titleController = TextEditingController();
  List<Routines> selectRoutinesList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
            TextButton(
              onPressed: _httpPostRoutinesGroups,
              child: Text("저장"),
            ),
          ],
        )),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: textInputForm(controller: _titleController, title: 'Title', width: _width, context: context),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "루틴 리스트",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: _awaitReturnValueFromRoutinesListForRoutinesGroups, child: Text("추가")),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List.generate(
                    selectRoutinesList.length, (i) => listViewRoutines(index: i, routines: selectRoutinesList[i], width: _width, context: context)).toList()))
      ],
    )));
  }

  Widget listViewRoutines({required int index, required Routines routines, required double width, required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(routines.title!),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                            child: Icon(
                          Icons.timer_rounded,
                          size: 17,
                        )),
                        Text(":"),
                        routines.timeDuration!.hour == 0
                            ? SizedBox()
                            : Text(
                                "${routines.timeDuration!.hour} 시간",
                                style: TextStyle(fontSize: 17),
                              ),
                        routines.timeDuration!.min == 0
                            ? SizedBox()
                            : Text(
                                "${routines.timeDuration!.min} 분",
                                style: TextStyle(fontSize: 17),
                              ),
                        routines.timeDuration!.sec == 0
                            ? SizedBox()
                            : Text(
                                "${routines.timeDuration!.sec} 초",
                                style: TextStyle(fontSize: 17),
                              ),
                      ],
                    ),
                  )
                ]))),
        IconButton(
            onPressed: () => _deleteRoutines(index),
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            )),
      ],
    );
  }

  void _deleteRoutines(int index) async {
    setState(() {
      selectRoutinesList.removeAt(index);
    });
  }

  void _httpPostRoutinesGroups() async {
    List<RoutinesGroups> routinesGroupsList = [];
    selectRoutinesList.forEach((routines) {
      RoutinesGroups routinesGroups = RoutinesGroups(routines: routines);
      routinesGroupsList.add(routinesGroups);
    });

    RoutinesGroupsUnions routinesGroupsUnions = RoutinesGroupsUnions(title: _titleController.text, routinesGroupsList: routinesGroupsList);
    try {
      RoutinesGroupsUnions httpResult = await postRoutinesGroupsUnions(routinesGroupsUnions);
      Navigator.pop(context, httpResult);
    } catch (e) {
      print(e);
    }
  }

  void _awaitReturnValueFromRoutinesListForRoutinesGroups() async {
    List<Routines> routinesList = await getRoutines();
    var awaitResult = await routinesListForRoutinesGroupsModalBottomSheet(routinesList, context);
    if (awaitResult != null) {
      setState(() {
        print(awaitResult[0]);
        if (awaitResult[0] == 'add') {
          selectRoutinesList.add(awaitResult[1]);
        }
      });
    }
  }
}
