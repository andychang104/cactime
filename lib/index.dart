import 'package:cactime/newUserSetting.dart';
import 'package:cactime/util/alllogin.dart';
import 'package:cactime/util/preferences.dart';
import 'package:cactime/util/progressdialog.dart';
import 'package:cactime/util/toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'generated/i18n.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

preferences preferencesclass = new preferences();
toast toastclass = new toast();
alllogin loginclass = new alllogin();

class Index extends StatefulWidget {
  @override
  Test createState() => Test();
}

class Test extends State<Index> {
  bool isEmailCheck = preferencesclass.getEmailCheck();
  var userEmailEdit =
      TextEditingController(text: preferencesclass.getUserEmail());
  var userpasswordEdit = TextEditingController(text: "");

  void onChanged(bool value) {
    setState(() {
      isEmailCheck = value;
      preferencesclass.setEmailCheck(isEmailCheck);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.deepPurple,
          title: new Text(S.of(context).loginTitle),
          automaticallyImplyLeading: false),
      body: new Container(
        margin: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    new Text(
                      (S.of(context).loginMsg),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: new TextField(
                        controller: userEmailEdit,
                        //controller: new TextEditingController(text: widget.msg1),
                        decoration: InputDecoration(
                          hintText: (S.of(context).loginEditMailHint),
                          border: new UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: new TextField(
                        controller: userpasswordEdit,
                        //controller: new TextEditingController(text: widget.msg1),
                        decoration: InputDecoration(
                          hintText: (S.of(context).loginEditPasswordHint),
                          border: new UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        autofocus: true,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                child: Row(
                  children: <Widget>[
                    new Checkbox(
                      value: isEmailCheck,
                      onChanged: (bool value) {
                        //_isEmailCheck = value;
                        onChanged(value);
                      },
                      activeColor: Colors.deepPurple,
                    ),
                    Expanded(
                      flex: 1,
                      child: new RichText(
                        text: new TextSpan(
                            text: (S.of(context).loginTextCheck),
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                if (isEmailCheck) {
                                  onChanged(false);
                                } else {
                                  onChanged(true);
                                }
                              }),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 10.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: new MaterialButton(
                          height: 45.0,
                          child: Text((S.of(context).loginBtn),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              )),
                          color: Colors.deepPurple,
                          elevation: 4.0,
                          textColor: Colors.white,
                          splashColor: Colors.black12,
                          onPressed: () async {
                            if (userEmailEdit.text.length == 0) {
                              toastclass.showToast("請輸入帳號");
                            } else if (userpasswordEdit.text.length == 0) {
                              toastclass.showToast("請輸入密碼");
                            } else {
                              if (preferencesclass.getEmailCheck()) {
                                preferencesclass
                                    .setUserEmail(userEmailEdit.text);
                              } else {
                                preferencesclass.setUserEmail("");
                              }

                              showDialog(
                                  context: context,
                                  child: new progressdialog().progress);

                              loginclass.loginFirebase(context,
                                  userEmailEdit.text, userpasswordEdit.text);
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: new MaterialButton(
                          height: 45.0,
                          child: Text((S.of(context).noLoginBtn),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              )),
                          color: Colors.deepPurple,
                          elevation: 4.0,
                          textColor: Colors.white,
                          splashColor: Colors.black12,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => newUserSetting("")),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: new MaterialButton(
                        height: 45.0,
                        child: Text((S.of(context).loginLostPassword),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            )),
                        color: Colors.deepPurple,
                        elevation: 4.0,
                        textColor: Colors.white,
                        splashColor: Colors.black12,
                        onPressed: () {
                          loginclass.showPasswordDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 15.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: new SignInButton(
                          Buttons.Facebook,
                          onPressed: () {
                            loginclass.logInFaceBook();
                          },
                          mini: true,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: new SignInButton(
                          Buttons.Google,
                          onPressed: () {
                            loginclass.signInGoogle();
                          },
                          mini: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
