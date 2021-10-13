import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/dialog/RoutinesListInputDialog.dart';
import 'package:flutter_webservice/dialog/DurationChoiceDialog.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';

class RoutinesGroupsInput extends StatefulWidget {
  RoutinesGroupsInput({Key? key, this.routines}) : super(key: key);

  final Routines? routines;

  @override
  _RoutinesGroupsInputstate createState() => _RoutinesGroupsInputstate();
}

class _RoutinesGroupsInputstate extends State<RoutinesGroupsInput> {
  TextEditingController _titleController = TextEditingController();

  TimeDuration timeDuration = TimeDuration(hour: 0, min: 0, sec: 0);

  List<Routines> routinesList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text('Custom Routines Input'),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            textInputForm(
                controller: _titleController,
                title: 'Title',
                width: _width,
                context: context),
            TextButton(
                onPressed: () => __awaitRoutinesListInputDialog(),
                child: Text("루틴 추가")),
            durationInputForm(
                timeDuration: timeDuration,
                title: 'Duration',
                width: _width,
                context: context),
            SizedBox(
              height: 30,
            ),
            IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: _httpPostRoutinesGroups),
          ],
        ))));
  }

  Widget durationInputForm(
      {required TimeDuration timeDuration,
      required String title,
      required double width,
      required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _duraionChoiceDialog() async {
            var dialogResult = await duraionChoiceDialog(context, timeDuration);
            setState(() {
              print(timeDuration.hour);
              timeDuration = dialogResult;
            });
          }

          _duraionChoiceDialog();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(title, style: Theme.of(context).textTheme.headline2),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${timeDuration.hour}"),
                  Text("시간"),
                  Text("${timeDuration.min}"),
                  Text("분"),
                  Text("${timeDuration.sec}"),
                  Text("초"),
                ],
              ),
            )
          ],
        ));
  }

  void __awaitRoutinesListInputDialog() async {
    var dialogResult = await routinesListInputDialog(context, routinesList);

    setState(() {
      print("update");
      routinesList = dialogResult;
    });
  }

  void _httpPostRoutinesGroups() async {
    RoutinesGroups routinesGroups = RoutinesGroups(
      title: _titleController.text,
      routinesList: routinesList,
      duration: (timeDuration.hour!) * 3600 +
          (timeDuration.min!) * 60 +
          (timeDuration.sec!),
    );
    var httpResult = await postRoutinesGroups(routinesGroups);
    print((jsonDecode(httpResult)));
    Navigator.pop(context, 'success');
  }
}
