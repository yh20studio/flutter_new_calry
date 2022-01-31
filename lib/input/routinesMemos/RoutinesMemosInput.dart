import 'package:flutter/material.dart';

import '../../widgets/TextInputFormWidget.dart';
import '../../controller/routinesMemos/RoutinesMemosController.dart';
import '../../domain/routines/Routines.dart';
import '../../domain/routinesMemos/RoutinesMemos.dart';
import '../../widgets/ContainerWidget.dart';
import '../../controller/jwt/JwtController.dart';

class RoutinesMemosInput extends StatefulWidget {
  RoutinesMemosInput({Key? key, this.routines}) : super(key: key);

  final Routines? routines;

  @override
  _RoutinesMemosInputstate createState() => _RoutinesMemosInputstate();
}

class _RoutinesMemosInputstate extends State<RoutinesMemosInput> {
  TextEditingController _memoController = TextEditingController();

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
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
            TextButton(
              onPressed: () => _httpPostMemos(),
              child: Text("저장"),
            ),
          ],
        )),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: textInputForm(controller: _memoController, title: 'Memo', width: _width, context: context),
        ),
      ],
    )));
  }

  void _httpPostMemos() async {
    RoutinesMemos routinesMemos = RoutinesMemos(
      routines_id: widget.routines!.id,
      content: _memoController.text,
    );
    try {
      RoutinesMemos httpResult = await postRoutinesMemos(await getJwt(context), routinesMemos);
      Navigator.pop(context, httpResult);
    } catch (e) {
      print(e);
    }
  }
}
