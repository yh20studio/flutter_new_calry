import 'package:flutter/material.dart';

import '../dialog/AlertDialog.dart';
import '../controller/member/MemberController.dart';
import '../widgets/ContainerWidget.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpstate createState() => _SignUpstate();
}

class _SignUpstate extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text(
            "Calry 가입하기",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
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
                      height: 15,
                    ),
                    borderPaddingTitleContainerWidget(
                        title: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("비밀번호", style: Theme.of(context).textTheme.headline2),
                        ),
                        widget: authTestInputForm(controller: _passwordController, width: _width, context: context),
                        context: context),
                    SizedBox(
                      height: 15,
                    ),
                    borderPaddingTitleContainerWidget(
                        title: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("비밀번호 확인", style: Theme.of(context).textTheme.headline2),
                        ),
                        widget: authTestInputForm(controller: _passwordConfirmController, width: _width, context: context),
                        context: context),
                    SizedBox(
                      height: 15,
                    ),
                    borderPaddingTitleContainerWidget(
                        title: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("이름", style: Theme.of(context).textTheme.headline2),
                        ),
                        widget: authTestInputForm(controller: _nameController, width: _width, context: context),
                        context: context),
                    SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        child: Text(
                          "가입하기",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: _httpPostSignUp),
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
            keyboardType: TextInputType.multiline,
            obscureText: controller == _passwordController
                ? true
                : controller == _passwordConfirmController
                    ? true
                    : false,
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

  void _httpPostSignUp() async {
    try {
      await postSignUp(_emailController.text, _passwordController.text, _nameController.text);
      Navigator.pop(context, 'success');
    } catch (exception) {
      _awaitDialog(exception.toString());
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
