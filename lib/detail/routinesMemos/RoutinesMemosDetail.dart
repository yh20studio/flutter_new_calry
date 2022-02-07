import 'package:flutter/material.dart';

import '../../widgets/TextInputFormWidget.dart';
import '../../widgets/DateWidget.dart';
import '../../controller/routinesMemos/RoutinesMemosController.dart';
import '../../domain/routinesMemos/RoutinesMemos.dart';
import '../../widgets/ContainerWidget.dart';
import '../../controller/jwt/JwtController.dart';

class RoutinesMemosDetail extends StatefulWidget {
  RoutinesMemosDetail({Key? key, this.routinesMemos}) : super(key: key);

  final RoutinesMemos? routinesMemos;

  @override
  _RoutinesMemosDetailstate createState() => _RoutinesMemosDetailstate();
}

class _RoutinesMemosDetailstate extends State<RoutinesMemosDetail> {
  TextEditingController _memoController = TextEditingController();
  RoutinesMemos? routinesMemos;
  String? popResult = "";

  @override
  void initState() {
    routinesMemos = widget.routinesMemos!;
    _memoController.text = widget.routinesMemos!.content!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Container(
                child: Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close,
                        color: Theme.of(context).backgroundColor)),
                Expanded(
                    child: Center(
                        child: Text("메모 편집",
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w700)))),
                TextButton(
                    onPressed: () => _awaitReturnValueFromRoutinesMemosUpdate(),
                    child: Text("저장",
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor))),
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
                    "Date",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                monthDayDateWidget(
                    datetime: routinesMemos!.created_date, context: context)
              ],
            )),
        SizedBox(
          height: 30,
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Memo",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )),
        SizedBox(height: 10,),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: borderPaddingContainerWidget(
                widget: textInputSimpleForm(
                    controller: _memoController,
                    context: context),
                context: context)),
        SizedBox(
          height: 30,
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text(
                    "삭제",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: _httpDeleteRoutinesMemos,
                ),
              ],
            ))
      ],
    ))));
  }

  void _httpDeleteRoutinesMemos() async {
    try {
      var httpResult =
          await deleteRoutinesMemos(await getJwt(context), routinesMemos!);
      Navigator.pop(context, [httpResult, null]);
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _awaitReturnValueFromRoutinesMemosUpdate() async {
    RoutinesMemos newRoutinesMemos =
        RoutinesMemos(id: routinesMemos!.id, content: _memoController.text);
    try {
      var httpResult =
          await updateRoutinesMemos(await getJwt(context), newRoutinesMemos);
      Navigator.pop(context, ["update", httpResult]);
    } on Exception catch (exception) {
      print(exception);
    }
  }
}
