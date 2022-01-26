import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog/TwoChoiceDialog.dart';
import '../widgets/ContainerWidget.dart';
import '../controller/member/MemberController.dart';
import '../domain/member/Member.dart';
import '../main.dart';

class MemberInfo extends StatefulWidget {
  MemberInfo({Key? key, this.member}) : super(key: key);

  final Member? member;
  @override
  _MemberInfostate createState() => _MemberInfostate();
}

class _MemberInfostate extends State<MemberInfo> {
  Member? member;

  @override
  void initState() {
    member = widget.member!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "로그인 정보",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("이메일"),
                    SizedBox(
                      height: 5,
                    ),
                    borderPaddingContainerWidget(widget: Text(member!.email!), context: context),
                    SizedBox(
                      height: 20,
                    ),
                    Text("이름"),
                    SizedBox(
                      height: 5,
                    ),
                    borderPaddingContainerWidget(widget: Text(member!.name!), context: context),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _httpPostLogout,
                          child: Text(
                            '로그아웃',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    )
                  ],
                ))));
  }

  void _httpPostLogout() async {
    var result = await _awaitTwoChoiceDialog("로그아웃 하시겠습니까?");
    if (result != null) {
      if (result == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        try {
          var httpResult = await postLogout(prefs.getString('accessToken'), prefs.getInt('accessTokenExpiresIn'));
          prefs.remove('accessToken');
          prefs.remove('accessTokenExpiresIn');
          print("reLogin!");
          navigatorKey.currentState!.pushNamed('login');
        } catch (e) {
          prefs.remove('accessToken');
          prefs.remove('accessTokenExpiresIn');
          print("reLogin!");
          navigatorKey.currentState!.pushNamed('login');
        }
      }
    }
  }

  Future<bool> _awaitTwoChoiceDialog(String message) async {
    var dialogResult = await twoChoiceDialog(context, message);

    if (dialogResult == 'ok') {
      return true;
    } else {
      return false;
    }
  }
}
