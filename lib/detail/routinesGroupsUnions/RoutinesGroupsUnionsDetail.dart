import 'package:flutter/material.dart';

import '../../domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';
import '../../domain/routinesGroups/RoutinesGroups.dart';
import '../../widgets/TimeDurationWidget.dart';
import '../../widgets/TextInputFormWidget.dart';
import '../../widgets/ContainerWidget.dart';
import '../../modalBottomSheet/time/TimeDurationModalBottomSheet.dart';
import '../../modalBottomSheet/routines/RoutinesListForRoutinesGroupsModalBottomSheet.dart';
import '../../controller/routinesGroupsUnion/RoutinesGroupsUnionsController.dart';
import '../../controller/routines/RoutinesController.dart';
import '../../domain/timeDuration/TimeDuration.dart';
import '../../domain/routines/Routines.dart';
import '../../auth/Login.dart';
import '../../controller/jwt/JwtController.dart';

class RoutinesGroupsUnionsDetail extends StatefulWidget {
  RoutinesGroupsUnionsDetail({Key? key, this.routinesGroupsUnions})
      : super(key: key);

  final RoutinesGroupsUnions? routinesGroupsUnions;

  @override
  _RoutinesGroupsUnionsDetailstate createState() =>
      _RoutinesGroupsUnionsDetailstate();
}

class _RoutinesGroupsUnionsDetailstate
    extends State<RoutinesGroupsUnionsDetail> {
  TextEditingController _titleController = TextEditingController();
  RoutinesGroupsUnions? routinesGroupsUnions;
  int addIndex = -1;
  List<RoutinesGroups> routinesGroupsList = [];

  @override
  void initState() {
    super.initState();
    routinesGroupsUnions = widget.routinesGroupsUnions!;
    widget.routinesGroupsUnions!.routinesGroupsList!.forEach((element) {
      routinesGroupsList.add(element);
    });

    _titleController.text = widget.routinesGroupsUnions!.title!;
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
                TextButton(
                  onPressed: _httpDeleteRoutinesGroupsAll,
                  child: Text(
                    "??????",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(
                  child: Center(child:Text(
                    "?????? ?????? ??????",
                    style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontWeight: FontWeight.w700),
                  ),
                )),
                TextButton(
                  onPressed: _httpUpdateRoutinesGroups,
                  child: Text("??????",
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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: overlayPaddingContainerWidget(
              context: context,
              widget: textInputSimpleForm(
                  controller: _titleController, context: context)),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "?????? ?????????",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                    onPressed:
                        _awaitReturnValueFromRoutinesListForRoutinesGroups,
                    child: Text("??????")),
              ],
            )),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: overlayContainerWidget(
                widget: Container(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                        children: List.generate(
                            routinesGroupsList.length,
                            (i) => listViewRoutines(
                                index: i,
                                routinesGroups: routinesGroupsList[i],
                                width: _width,
                                context: context)).toList())),
                context: context))
      ],
    )));
  }

  Widget listViewRoutines(
      {required int index,
      required RoutinesGroups routinesGroups,
      required double width,
      required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(routinesGroups.routines!.title!),
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
                            routinesGroups.routines!.timeDuration!.hour == 0
                                ? SizedBox()
                                : Text(
                                    "${routinesGroups.routines!.timeDuration!.hour} ??????",
                                    style: TextStyle(fontSize: 17),
                                  ),
                            routinesGroups.routines!.timeDuration!.min == 0
                                ? SizedBox()
                                : Text(
                                    "${routinesGroups.routines!.timeDuration!.min} ???",
                                    style: TextStyle(fontSize: 17),
                                  ),
                            routinesGroups.routines!.timeDuration!.sec == 0
                                ? SizedBox()
                                : Text(
                                    "${routinesGroups.routines!.timeDuration!.sec} ???",
                                    style: TextStyle(fontSize: 17),
                                  ),
                          ],
                        ),
                      )
                    ]))),
        IconButton(
            onPressed: () => _deleteRoutinesGroups(index),
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            )),
      ],
    );
  }

  Widget durationInputForm(
      {required TimeDuration timeDuration, required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _timeDurationChoiceModalBottomSheet() async {
            var dialogResult =
                await timeDurationChoiceModalBottomSheet(timeDuration, context);
            setState(() {
              timeDuration = dialogResult;
            });
          }

          _timeDurationChoiceModalBottomSheet();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            timeDurationWidget(timeDuration: timeDuration, context: context),
          ],
        ));
  }

  void _awaitReturnValueFromRoutinesListForRoutinesGroups() async {
    try {
      List<Routines> routinesList = await getRoutines(await getJwt(context));
      var awaitResult = await routinesListForRoutinesGroupsModalBottomSheet(
          routinesList, context);
      if (awaitResult != null) {
        setState(() {
          if (awaitResult[0] == 'add') {
            RoutinesGroups routinesGroups =
                RoutinesGroups(id: -1, routines: awaitResult[1]);
            routinesGroupsList.add(routinesGroups);
          }
        });
      }
    } catch (e) {
      if (e == 'login') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  void _deleteRoutinesGroups(int index) async {
    setState(() {
      routinesGroupsList.removeAt(index);
    });
  }

  void _httpDeleteRoutinesGroupsAll() async {
    try {
      await deleteRoutinesGroupsUnions(
          await getJwt(context), routinesGroupsUnions!);
      Navigator.pop(context, ["delete", routinesGroupsUnions]);
    } catch (e) {
      if (e == 'login') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  void _httpUpdateRoutinesGroups() async {
    RoutinesGroupsUnions newRoutinesGroupsUnions = RoutinesGroupsUnions(
        id: widget.routinesGroupsUnions!.id,
        title: _titleController.text,
        routinesGroupsList: routinesGroupsList);
    try {
      var httpResult = await updateRoutinesGroupsUnions(
          await getJwt(context), newRoutinesGroupsUnions);
      Navigator.pop(context, ["update", httpResult]);
    } catch (e) {
      if (e == 'login') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }
}
