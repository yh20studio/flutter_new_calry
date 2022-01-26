import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignUp.dart';
import '../domain/labels/Labels.dart';
import '../dialog/AlertDialog.dart';
import '../controller/member/MemberController.dart';
import '../controller/labels/LabelsController.dart';
import '../widgets/ContainerWidget.dart';
import '../main.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  @override
  _Loginstate createState() => _Loginstate();
}

class _Loginstate extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Calry",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 32),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "해당 서비스는 로그인이 필요합니다.",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            )),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    borderPaddingTitleContainerWidget(
                        title: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("이메일", style: Theme.of(context).textTheme.headline2),
                        ),
                        widget: authTestInputForm(controller: _emailController, width: _width, context: context),
                        context: context),
                    SizedBox(
                      height: 20,
                    ),
                    borderPaddingTitleContainerWidget(
                        title: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("비밀번호", style: Theme.of(context).textTheme.headline2),
                        ),
                        widget: authTestInputForm(controller: _passwordController, width: _width, context: context),
                        context: context),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: _awaitFromSignUp),
                        TextButton(
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: _httpPostLogin),
                      ],
                    )
                  ],
                ))));
  }

  Widget authTestInputForm({required TextEditingController controller, required double width, required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.8,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.transparent),
          child: TextFormField(
            style: TextStyle(fontSize: 30, color: Colors.black),
            obscureText: controller == _passwordController ? true : false,
            keyboardType: TextInputType.emailAddress,
            controller: controller,
            decoration: InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.only(top: 0.0)),
          ),
        ),
      ],
    );
  }

  void _httpPostLogin() async {
    if (_emailController.text == "") {
      _awaitDialog("이메일을 입력해주세요.");
    } else if (_passwordController.text == "") {
      _awaitDialog("비밀번호를 입력해주세요.");
    } else {
      try {
        var httpResult = await postLogin(_emailController.text, _passwordController.text);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // token 저장
        prefs.setString('accessToken', jsonDecode(httpResult)['accessToken']);
        prefs.setInt('accessTokenExpiresIn', jsonDecode(httpResult)['accessTokenExpiresIn']);

        var labelResult = await getLabels();
        // Labels 저장
        final String encodedData = Labels.encode(labelResult);
        await prefs.setString('labels', encodedData);
        print("Login Success");
        navigatorKey.currentState!.pushNamed('/');
      } on Exception catch (exception) {
        print(exception);
        if (exception.toString() == "Exception: 가입되지 않은 이메일입니다.") {
          _awaitDialog("가입되지 않은 이메일입니다.");
        } else if (exception.toString() == "Exception: 비밀번호가 틀렸습니다.") {
          _awaitDialog("비밀번호가 틀렸습니다.");
        }
      }
    }
  }

  void _awaitFromSignUp() async {
    var awaitResult = await Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
    if (awaitResult == 'delete') {
      setState(() {
        print('reload');
      });
    }
  }

  void _awaitDialog(String message) async {
    var dialogResult = await alertDialog(context, message);

    if (dialogResult == 'ok') {
      setState(() {
        _passwordController.clear();
      });
    }
  }
}
