import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/dialog/DurationChoiceDialog.dart';
import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';

class RoutinesUpdate extends StatefulWidget {
  RoutinesUpdate({Key? key, this.routines}) : super(key: key);

  final Routines? routines;

  @override
  _RoutinesUpdatestate createState() => _RoutinesUpdatestate();
}

class _RoutinesUpdatestate extends State<RoutinesUpdate> {
  TextEditingController _iconController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  TimeDuration timeDuration = TimeDuration(hour: 0, min: 0, sec: 0);

  @override
  void initState() {
    _iconController.text = widget.routines!.icon!;
    _titleController.text = widget.routines!.title!;
    timeDuration = widget.routines!.timeDuration!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text('Update'),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            textInputForm(
                controller: _iconController,
                title: 'Icon',
                width: _width,
                context: context),
            textInputForm(
                controller: _titleController,
                title: 'Title',
                width: _width,
                context: context),
            durationInputForm(
                timeDuration: timeDuration,
                title: 'Duration',
                width: _width,
                context: context),
            IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: _httpUpdateRoutines),
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

  void _httpUpdateRoutines() async {
    Routines routines = Routines(
        id: widget.routines!.id,
        icon: _iconController.text,
        title: _titleController.text,
        duration: (timeDuration.hour!) * 3600 +
            (timeDuration.min!) * 60 +
            (timeDuration.sec!));
    var httpResult = await updateRoutines(routines);
    Navigator.pop(context, httpResult);
  }
}
