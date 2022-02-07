import 'package:flutter/material.dart';

import '../../controller/focusTodos/FocusTodosController.dart';
import '../../domain/focusTodos/FocusTodos.dart';
import '../../widgets/TextInputFormWidget.dart';
import '../../dialog/AlertDialog.dart';
import '../../widgets/ContainerWidget.dart';
import '../../controller/jwt/JwtController.dart';

class FocusTodosDetail extends StatefulWidget {
  FocusTodosDetail({Key? key, this.focusTodos}) : super(key: key);
  final FocusTodos? focusTodos;

  @override
  _FocusTodosDetailstate createState() => _FocusTodosDetailstate();
}

class _FocusTodosDetailstate extends State<FocusTodosDetail> {
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    _contentController.text = widget.focusTodos!.content!;
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
                TextButton(
                  onPressed: _httpDeleteFocusTodos,
                  child: Text(
                    "삭제",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: Text("할일 편집",
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w700)))),
                TextButton(
                  onPressed: () => _httpSuccessFocusTodos(),
                  child: Text("완료", style: TextStyle(
                      color: Theme.of(context).backgroundColor)),
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
          child:overlayPaddingContainerWidget(
          context: context,
          widget: textInputSimpleForm(
              controller: _contentController, context: context),
        )),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child:TextButton(
          onPressed: _httpUpdateFocusTodos,
          child: Text("수정"),
        )),
      ],
    )));
  }

  void _httpUpdateFocusTodos() async {
    FocusTodos focusTodos = FocusTodos(
      id: widget.focusTodos!.id,
      content: _contentController.text,
      success: widget.focusTodos!.success,
      successDateTime: widget.focusTodos!.successDateTime,
    );

    try {
      var httpResult =
          await updateFocusTodos(await getJwt(context), focusTodos);
      Navigator.pop(context, ["update", httpResult]);
    } on Exception catch (exception) {
      alertDialog(context, exception.toString());
    }
  }

  void _httpSuccessFocusTodos() async {
    FocusTodos focusTodos = FocusTodos(
        id: widget.focusTodos!.id,
        content: _contentController.text,
        success: true,
        successDateTime: DateTime.now());

    try {
      var httpResult =
          await successFocusTodos(await getJwt(context), focusTodos);
      Navigator.pop(context, ["delete", httpResult]);
    } on Exception catch (exception) {
      alertDialog(context, exception.toString());
    }
  }

  void _httpDeleteFocusTodos() async {
    FocusTodos focusTodos = FocusTodos(
      id: widget.focusTodos!.id,
      content: _contentController.text,
      success: widget.focusTodos!.success,
      successDateTime: widget.focusTodos!.successDateTime,
    );

    try {
      var httpResult =
          await deleteFocusTodos(await getJwt(context), focusTodos);
      Navigator.pop(context, ["${httpResult}", focusTodos]);
    } on Exception catch (exception) {
      alertDialog(context, exception.toString());
    }
  }
}
