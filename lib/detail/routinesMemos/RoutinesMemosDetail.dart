import 'package:flutter/material.dart';
import 'package:flutter_new_calry/widgets/TextInputFormWidget.dart';
import 'package:flutter_new_calry/widgets/DateWidget.dart';
import 'package:flutter_new_calry/controller/routinesMemos/RoutinesMemosController.dart';
import 'package:flutter_new_calry/domain/routinesMemos/RoutinesMemos.dart';
import 'package:flutter_new_calry/widgets/ContainerWidget.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(child: Text("저장"), onPressed: () => _awaitReturnValueFromRoutinesMemosUpdate()),
          ],
        ),
        monthDayDateWidget(datetime: routinesMemos!.created_date, context: context),
        SizedBox(
          height: 30,
        ),
        borderPaddingContainerWidget(widget: textInputForm(controller: _memoController, title: '내용', width: _width, context: context), context: context),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
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
        )
      ],
    ))));
  }

  void _httpDeleteRoutinesMemos() async {
    try {
      var httpResult = await deleteRoutinesMemos(routinesMemos!);
      print((httpResult));
      Navigator.pop(context, [httpResult, null]);
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _awaitReturnValueFromRoutinesMemosUpdate() async {
    RoutinesMemos newRoutinesMemos = RoutinesMemos(id: routinesMemos!.id, content: _memoController.text);
    try {
      var httpResult = await updateRoutinesMemos(newRoutinesMemos);
      Navigator.pop(context, ["update", httpResult]);
    } on Exception catch (exception) {
      print(exception);
    }
  }
}
