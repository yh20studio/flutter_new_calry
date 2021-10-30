import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';
import 'package:flutter_new_calry/widgets/TimeDurationWidget.dart';
import 'package:flutter_new_calry/widgets/TextInputFormWidget.dart';
import 'package:flutter_new_calry/widgets/ContainerWidget.dart';
import 'package:flutter_new_calry/modalBottomSheet/time/TimeDurationModalBottomSheet.dart';
import 'package:flutter_new_calry/controller/routines/RoutinesController.dart';
import 'package:flutter_new_calry/domain/timeDuration/TimeDuration.dart';
import 'package:flutter_new_calry/auth/Login.dart';

class RoutinesDetail extends StatefulWidget {
  RoutinesDetail({Key? key, this.routines}) : super(key: key);

  final Routines? routines;

  @override
  _RoutinesDetailstate createState() => _RoutinesDetailstate();
}

class _RoutinesDetailstate extends State<RoutinesDetail> {
  TextEditingController _titleController = TextEditingController();
  Routines? routines;
  String? popResult = "";

  @override
  void initState() {
    routines = widget.routines!;
    _titleController.text = widget.routines!.title!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _httpDeleteRoutines,
              child: Text(
                "삭제",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: _httpUpdateRoutines,
              child: Text("저장"),
            ),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(context: context, widget: textInputSimpleForm(controller: _titleController, context: context)),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
            context: context,
            widget: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text("시간"),
              durationInputForm(
                timeDuration: routines!.timeDuration!,
                context: context,
              )
            ])),
        SizedBox(
          height: 20,
        ),
      ],
    )));
  }

  Widget durationInputForm({required TimeDuration timeDuration, required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _timeDurationChoiceModalBottomSheet() async {
            var dialogResult = await timeDurationChoiceModalBottomSheet(timeDuration, context);
            setState(() {
              print(timeDuration.hour);
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

  void _httpDeleteRoutines() async {
    try {
      await deleteRoutines(routines!);
      Navigator.pop(context, ["delete", routines]);
    } catch (e) {
      if (e == 'login') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  void _httpUpdateRoutines() async {
    Routines newRoutines = Routines(
        id: widget.routines!.id,
        title: _titleController.text,
        duration: (routines!.timeDuration!.hour!) * 3600 + (routines!.timeDuration!.min!) * 60 + (routines!.timeDuration!.sec!));
    try {
      var httpResult = await updateRoutines(newRoutines);
      Navigator.pop(context, ["update", httpResult]);
    } catch (e) {
      if (e == 'login') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }
}
