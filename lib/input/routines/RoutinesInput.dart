import 'package:flutter/material.dart';

import '../../widgets/TextInputFormWidget.dart';
import '../../modalBottomSheet/time/TimeDurationModalBottomSheet.dart';
import '../../widgets/TimeDurationWidget.dart';
import '../../controller/routines/RoutinesController.dart';
import '../../domain/timeDuration/TimeDuration.dart';
import '../../domain/routines/Routines.dart';
import '../../widgets/ContainerWidget.dart';
import '../../controller/jwt/JwtController.dart';

class RoutinesInput extends StatefulWidget {
  RoutinesInput({Key? key}) : super(key: key);

  @override
  _RoutinesInputstate createState() => _RoutinesInputstate();
}

class _RoutinesInputstate extends State<RoutinesInput> {
  TextEditingController _titleController = TextEditingController();

  TimeDuration timeDuration = TimeDuration(hour: 0, min: 0, sec: 0);

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
                      "루틴 생성",
                      style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.w700),
                    ),
                    )),
                TextButton(
                  onPressed: _httpPostRoutines,
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
          widget: textInputSimpleForm(
              controller: _titleController, context: context),
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
                "Duration",
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
          widget: durationInputForm(
              timeDuration: timeDuration, width: _width, context: context),
        )),
        SizedBox(
          height: 30,
        ),
      ],
    )));
  }

  Widget durationInputForm(
      {required TimeDuration timeDuration,
      required double width,
      required BuildContext context}) {
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
      child: timeDurationWidget(timeDuration: timeDuration, context: context),
    );
  }

  void _httpPostRoutines() async {
    Routines routines = Routines(
      title: _titleController.text,
      duration: (timeDuration.hour!) * 3600 +
          (timeDuration.min!) * 60 +
          (timeDuration.sec!),
    );
    var httpResult = await postRoutines(await getJwt(context), routines);
    Navigator.pop(context, httpResult);
  }
}
