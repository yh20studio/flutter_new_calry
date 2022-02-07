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
            style: TextStyle(color: Theme.of(context).hoverColor),
          ),
          iconTheme: IconThemeData(color: Theme.of(context).hoverColor),
          elevation: 0.0,
          backgroundColor: Theme.of(context).dialogBackgroundColor
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
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
                    overlayContainerWidget(
                      context: context,
                      widget: authTestInputForm(controller: _emailController, width: _width, context: context),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "비밀번호",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    overlayContainerWidget(
                      context: context,
                      widget: authTestInputForm(controller: _passwordController, width: _width, context: context),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "비밀번호 확인",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    overlayContainerWidget(
                      context: context,
                      widget: authTestInputForm(controller: _passwordConfirmController, width: _width, context: context),
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
                    overlayContainerWidget(
                      context: context,
                      widget: authTestInputForm(controller: _nameController, width: _width, context: context),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        child: Text(
                          "가입하기",
                          style: TextStyle(color: Theme.of(context).hoverColor),
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
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.transparent),
          child: TextFormField(
            style: TextStyle(fontSize: 30, color:Theme.of(context).hoverColor),
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
