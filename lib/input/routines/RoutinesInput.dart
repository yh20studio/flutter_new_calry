import 'package:flutter/material.dart';
import 'package:flutter_new_calry/widgets/TextInputFormWidget.dart';
import 'package:flutter_new_calry/modalBottomSheet/time/TimeDurationModalBottomSheet.dart';
import 'package:flutter_new_calry/widgets/timeDurationWidget.dart';
import 'package:flutter_new_calry/controller/routines/RoutinesController.dart';
import 'package:flutter_new_calry/domain/timeDuration/TimeDuration.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';

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
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
            TextButton(
              onPressed: _httpPostRoutines,
              child: Text("저장"),
            ),
          ],
        )),
        textInputForm(controller: _titleController, title: 'Title', width: _width, context: context),
        durationInputForm(timeDuration: timeDuration, title: 'Duration', width: _width, context: context),
        SizedBox(
          height: 30,
        ),
      ],
    )));
  }

  Widget durationInputForm({required TimeDuration timeDuration, required String title, required double width, required BuildContext context}) {
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
            Container(
              padding: EdgeInsets.all(10),
              child: Text(title, style: Theme.of(context).textTheme.headline2),
            ),
            timeDurationWidget(timeDuration: timeDuration, context: context),
          ],
        ));
  }

  void _httpPostRoutines() async {
    Routines routines = Routines(
      title: _titleController.text,
      duration: (timeDuration.hour!) * 3600 + (timeDuration.min!) * 60 + (timeDuration.sec!),
    );
    var httpResult = await postRoutines(routines);
    Navigator.pop(context, httpResult);
  }
}
