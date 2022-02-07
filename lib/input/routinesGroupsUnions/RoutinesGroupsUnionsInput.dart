import 'package:flutter/material.dart';

import '../../widgets/TextInputFormWidget.dart';
import '../../modalBottomSheet/routines/RoutinesListForRoutinesGroupsModalBottomSheet.dart';
import '../../controller/routines/RoutinesController.dart';
import '../../controller/routinesGroupsUnion/RoutinesGroupsUnionsController.dart';
import '../../domain/routines/Routines.dart';
import '../../domain/routinesGroups/RoutinesGroups.dart';
import '../../domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';
import '../../widgets/ContainerWidget.dart';
import '../../controller/jwt/JwtController.dart';

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
            padding: EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Theme.of(context).backgroundColor,)),
                Expanded(
                    child: Center(child:Text(
                      "루틴 그룹 생성",
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.w700),
                    ),
                    )),
                TextButton(
                  onPressed: _httpPostRoutinesGroups,
                  child: Text("저장",
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                      )),
                ),
              ],
            )),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:Row(
          children: [
            Expanded(
              child: Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:overlayPaddingContainerWidget(
          context: context,
          widget: textInputSimpleForm(controller: _titleController, context: context),
        )),
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:Row(
          children: [
            Expanded(
              child: Text(
                "루틴 리스트",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: _awaitReturnValueFromRoutinesListForRoutinesGroups, child: Text("추가")),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:overlayContainerWidget(
          context: context,
          widget: Container(
              padding: EdgeInsets.only(top:5, bottom:5, left: 10, right:10),
              child: selectRoutinesList.length == 0
                  ? Container(
                padding: EdgeInsets.all(20),
                child: Center(child:Text("루틴을 추가해 보세요!"),))
              :Wrap(
                children: List.generate(
                    selectRoutinesList.length, (i) => listViewRoutines(index: i, routines: selectRoutinesList[i], width: _width, context: context)).toList()))
        ))],
    )));
  }

  Widget listViewRoutines({required int index, required Routines routines, required double width, required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
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
      RoutinesGroupsUnions httpResult = await postRoutinesGroupsUnions(await getJwt(context), routinesGroupsUnions);
      Navigator.pop(context, httpResult);
    } catch (e) {
      print(e);
    }
  }

  void _awaitReturnValueFromRoutinesListForRoutinesGroups() async {
    List<Routines> routinesList = await getRoutines(await getJwt(context));
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
