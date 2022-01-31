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
              onPressed: _httpPostFocusTodos,
              child: Text("저장"),
            ),
          ],
        )),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: textInputForm(controller: _contentController, title: 'Content', width: _width, context: context),
        ),
      ],
    )));
  }

  void _httpPostFocusTodos() async {
    FocusTodos focusTodos = FocusTodos(content: _contentController.text, success: false);
    try {
      var httpResult = await postFocusTodos(await getJwt(context), focusTodos);
      Navigator.pop(context, httpResult);
    } catch (e) {
      alertDialog(context, e.toString());
    }
  }
}
