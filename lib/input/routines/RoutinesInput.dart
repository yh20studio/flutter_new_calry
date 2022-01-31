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
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: textInputForm(controller: _titleController, title: 'Title', width: _width, context: context),
        ),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: durationInputForm(timeDuration: timeDuration, title: 'Duration', width: _width, context: context),
        ),
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
    var httpResult = await postRoutines(await getJwt(context), routines);
    Navigator.pop(context, httpResult);
  }
}
