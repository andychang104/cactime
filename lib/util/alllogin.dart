import 'package:cactime/generated/i18n.dart';
import 'package:cactime/index.dart';
import 'package:cactime/util/progressdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cactime/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';


class alllogin{

  bool login = false;
  FirebaseUser auth;
  FirebaseAuth mAuth = FirebaseAuth.instance;
  toast toastclass = new toast();
  FacebookLogin facebookSignIn = new FacebookLogin();
  GoogleSignIn googleSignIn = new GoogleSignIn();
  var passwordCheckEdit = TextEditingController(text: "");

  //Firebase email登入忘記密碼
  Future sendPassword(BuildContext context, String email) async {
    await mAuth.sendPasswordResetEmail(
        email: email
    ).then(
            (value){
          toastclass.showToast(S.of(context).personalMsg);
        }
    ).catchError((error){
      RegExp exp = new RegExp(r'\d{5}');
      var err = exp.firstMatch(error.toString());
      print(error.toString());
      if(err != null){
        if (err.group(0) == '17011'){
          toastclass.showToast(S.of(context).loginDialogJoin);
        }
        else{
          toastclass.showToast(S.of(context).toastMag6);
        }
      }
      else{
        toastclass.showToast(S.of(context).loginDialogJoin);
      }

    });
    Navigator.pop(context);
  }


  //Firebase email註冊
  Future joinFirebase(BuildContext context, String email, String password) async {
    await mAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then(
        (value){
          auth = value;
          print(auth);
          login = true;
          toastclass.showToast(S.of(context).toastMag3+"! uid = ${auth.uid}");

        }
    ).catchError((error){
      RegExp exp = new RegExp(r'\d{5}');
      var err = exp.firstMatch(error.toString());
      print(error.toString());

      if(err != null){
        if (err.group(0) == '17008'){
          toastclass.showToast(S.of(context).toastMag2);
        }
        else if (err.group(0) == '17009'){
          toastclass.showToast(S.of(context).toastMag4);
        }
        else if (err.group(0) == '17011'){
          toastclass.showToast(S.of(context).toastMag2);
        }
        else if (err.group(0) == '17026'){
          toastclass.showToast(S.of(context).toastMag12);
        }
        else{
          toastclass.showToast(S.of(context).toastMag8);
        }
      }
      else{
          toastclass.showToast(S.of(context).toastMag8);
      }

    });

    Navigator.pop(context);
  }

  //Firebase email登入
  Future loginFirebase(BuildContext context, String email, String password, Test test) async {
    await mAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then(
            (value){
          Navigator.pop(context);
          auth = value;
          print(auth);
          login = true;
          test.loginType = 1;
          test.test(auth.uid);
          toastclass.showToast(S.of(context).toastMag1+"! uid = ${auth.uid}");


        }
    ).catchError((error){
      Navigator.pop(context);
      RegExp exp = new RegExp(r'\d{5}');
      var err = exp.firstMatch(error.toString());
      print(error.toString());
      if(err != null){
        print(err.group(0));
        if (err.group(0) == '17011'){
          showJoinCheckDialog(context, email, password);
        }
        else if (err.group(0) == '17008'){
          toastclass.showToast(S.of(context).toastMag11);
        }
        else if (err.group(0) == '17009'){
          toastclass.showToast(S.of(context).toastMag4);
        }
        else{
          toastclass.showToast(S.of(context).toastMag8);
        }
      }
      else{
        if(error.toString().indexOf("The password is invalid or the user does not have a password") != -1){
          toastclass.showToast(S.of(context).toastMag4);
        }
        else{
          showJoinCheckDialog(context, email, password);
        }
      }


    });

  }

  //顯示註冊提示視窗
  Future<Null> showJoinCheckDialog(BuildContext context, String email, String password) async {
    switch (await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: new Text(S.of(context).login),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(S.of(context).loginDialogJoin),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: Text(S.of(context).dialogNoBtn),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: Text(S.of(context).dialogOkBtn),
              onPressed: () {
                joinFirebase(context, email, password);
                Navigator.pop(context);
                showDialog(context: context, child: new progressdialog().showProgress(context));
              })
        ],
      ),
    )) {
    }
  }

  //顯示輸入email視窗
  Future<Null> showPasswordDialog(BuildContext context) async {
    switch (await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: new Text(S.of(context).dialogTitle),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                controller: passwordCheckEdit,
                decoration: new InputDecoration(hintText: S.of(context).loginEditMailHint),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: Text(S.of(context).dialogNoBtn),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: Text(S.of(context).dialogOkBtn),
              onPressed: () {
                sendPassword(context, passwordCheckEdit.text);
                Navigator.pop(context);
                showDialog(context: context, child: new progressdialog().showProgress(context));
              })
        ],
      ),
    )) {
    }
  }

  //Firebase facebook登入
  Future<Null> logInFaceBook(Test test, BuildContext context) async {
    final FacebookLoginResult result =
    await facebookSignIn.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        await mAuth.signInWithFacebook(accessToken: result.accessToken.token).then(
                (value){
              auth = value;
              print(auth);
              login = true;
              toastclass.showToast(S.of(context).toastMag1+'''!uid = ${auth.uid}''');
              test.loginType = 1;
              test.test(auth.uid);
            }
        ).catchError((error){
          RegExp exp = new RegExp(r'\d{5}');
          var err = exp.firstMatch(error.toString());
          print(error.toString());
          if(err != null){
            if (err.group(0) == '17011'){
              toastclass.showToast(S.of(context).toastMag2);
            }
            else if (err.group(0) == '17009'){
              toastclass.showToast(S.of(context).toastMag4);
            }
            else if(err.group(0) == '17012'){
              toastclass.showToast(S.of(context).toastMag7);
            }
            else{
              toastclass.showToast(S.of(context).toastMag8);
            }
          }
          else{
            if(error.toString().indexOf("The password is invalid or the user does not have a password") != -1){
              toastclass.showToast(S.of(context).toastMag4);
            }
            else if(error.toString().indexOf("An account already exists with the same email address but different sign-in credentials.")!= -1){
              toastclass.showToast(S.of(context).toastMag7);
            }
            else{
              toastclass.showToast(S.of(context).toastMag8);
            }
          }
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        toastclass.showToast(S.of(context).toastMag9);
        break;
      case FacebookLoginStatus.error:
        toastclass.showToast(S.of(context).toastMag10);
        break;
    }
  }

  //Firebase google登入
  Future<Null> signInGoogle(Test test) async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null){
      GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
      if(authentication != null){
        FirebaseUser user = await mAuth.signInWithGoogle(idToken: authentication.idToken, accessToken: authentication.accessToken);
        toastclass.showToast("UID-"+user.uid);
        print("UID-"+user.uid);
        test.loginType = 1;
        test.test(user.uid);
      }
    }


  }


}