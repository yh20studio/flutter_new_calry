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
            padding: EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Theme.of(context).backgroundColor)
                ),
                Expanded(child:Center(child:Text("메모 추가", style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w700)))),
                TextButton(
                  onPressed: () => _httpPostMemos(),
                  child: Text("저장", style: TextStyle(color: Theme.of(context).backgroundColor)
                )),
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
                    "Memo",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )),
        SizedBox(height: 10,),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
          child:overlayPaddingContainerWidget(
          context: context,
          widget: textInputSimpleForm(controller: _memoController, context: context),
        )),
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
