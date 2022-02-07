import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog/TwoChoiceDialog.dart';
import '../widgets/ContainerWidget.dart';
import '../controller/member/MemberController.dart';
import '../domain/member/Member.dart';
import '../controller/jwt/JwtController.dart';

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
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: Text(
            "로그인 정보",
            style: TextStyle(color: Theme.of(context).hoverColor),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Theme.of(context).hoverColor),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "E-mail",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    overlayPaddingContainerWidget(
                      context: context,
                      widget: Text(member!.email!),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "이름",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    overlayPaddingContainerWidget(
                      context: context,
                      widget: Text(member!.name!),
                    ),
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
          var httpResult = await postLogout(
              await getJwt(context),
              prefs.getString('accessToken'),
              prefs.getInt('accessTokenExpiresIn'));
          prefs.remove('accessToken');
          prefs.remove('accessTokenExpiresIn');
          print("reLogin!");
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        } catch (e) {
          prefs.remove('accessToken');
          prefs.remove('accessTokenExpiresIn');
          print("reLogin!");
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
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
