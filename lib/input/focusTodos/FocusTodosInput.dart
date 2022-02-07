import 'package:flutter/material.dart';

import '../../widgets/TextInputFormWidget.dart';
import '../../controller/focusTodos/FocusTodosController.dart';
import '../../domain/focusTodos/FocusTodos.dart';
import '../../dialog/AlertDialog.dart';
import '../../widgets/ContainerWidget.dart';
import '../../controller/jwt/JwtController.dart';

class FocusTodosInput extends StatefulWidget {
  FocusTodosInput({Key? key}) : super(key: key);

  @override
  _FocusTodosInputstate createState() => _FocusTodosInputstate();
}

class _FocusTodosInputstate extends State<FocusTodosInput> {
  DateTime now = DateTime.now();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    icon: Icon(Icons.close,
                        color: Theme.of(context).backgroundColor)),
                Expanded(
                    child: Center(
                        child: Text("할일 추가",
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w700)))),
                TextButton(
                  onPressed: () => _httpPostFocusTodos(),
                  child: Text("저장",
                      style:
                          TextStyle(color: Theme.of(context).backgroundColor)),
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
                    "Todo",
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
            child: overlayPaddingContainerWidget(
              context: context,
              widget: textInputSimpleForm(
                  controller: _contentController, context: context),
            )),
      ],
    )));
  }

  void _httpPostFocusTodos() async {
    FocusTodos focusTodos =
        FocusTodos(content: _contentController.text, success: false);
    try {
      var httpResult = await postFocusTodos(await getJwt(context), focusTodos);
      Navigator.pop(context, httpResult);
    } catch (e) {
      alertDialog(context, e.toString());
    }
  }
}
