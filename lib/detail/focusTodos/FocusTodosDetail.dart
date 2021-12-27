import 'package:flutter/material.dart';
import 'package:flutter_new_calry/controller/focusTodos/FocusTodosController.dart';
import 'package:flutter_new_calry/domain/focusTodos/FocusTodos.dart';
import 'package:flutter_new_calry/widgets/TextInputFormWidget.dart';
import 'package:flutter_new_calry/dialog/AlertDialog.dart';
import 'package:flutter_new_calry/widgets/ContainerWidget.dart';

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
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _httpDeleteFocusTodos,
              child: Text(
                "삭제",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: _httpSuccessFocusTodos,
              child: Text("할일 완료"),
            ),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        borderPaddingContainerWidget(
          context: context,
          widget: textInputForm(controller: _contentController, title: 'Content', width: _width, context: context),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: _httpUpdateFocusTodos,
          child: Text("수정"),
        ),
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
      var httpResult = await updateFocusTodos(focusTodos);
      Navigator.pop(context, ["update", httpResult]);
    } on Exception catch (exception) {
      alertDialog(context, exception.toString());
    }
  }

  void _httpSuccessFocusTodos() async {
    FocusTodos focusTodos = FocusTodos(id: widget.focusTodos!.id, content: _contentController.text, success: true, successDateTime: DateTime.now());

    try {
      var httpResult = await successFocusTodos(focusTodos);
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
      var httpResult = await deleteFocusTodos(focusTodos);
      Navigator.pop(context, ["${httpResult}", focusTodos]);
    } on Exception catch (exception) {
      alertDialog(context, exception.toString());
    }
  }
}