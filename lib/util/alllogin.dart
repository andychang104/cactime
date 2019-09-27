import 'package:cactime/newUserSetting.dart';
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
  
  String accountError = '17008';
  String passwordError = '17009';
  String noAccount = '17011';
  String fbAccountError = '17012';
  String passwordLength = '17026';

  //Firebase email登入忘記密碼
  Future sendPassword(BuildContext context, String email) async {
    await mAuth.sendPasswordResetEmail(
        email: email
    ).then(
            (value){
          toastclass.showToast("已傳送E-mail");
        }
    ).catchError((error){
      RegExp exp = new RegExp(r'\d{5}');
      var err = exp.firstMatch(error.toString());
      print(error);
      print("@@@@@-"+err.group(0));

      if (err.group(0) == noAccount){
        toastclass.showToast("該帳號不存在，請您先註冊");
      }
      else{
        toastclass.showToast("E-mail寄送失敗");
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
          toastclass.showToast("註冊成功! uid = ${auth.uid}");

        }
    ).catchError((error){
      RegExp exp = new RegExp(r'\d{5}');
      var err = exp.firstMatch(error.toString());
      print(error);
      print("@@@@@-"+err.group(0));

      if (err.group(0) == accountError){
        toastclass.showToast("帳號格式錯誤");
      }
      else if (err.group(0) == passwordError){
        toastclass.showToast("密碼錯誤");
      }
      else if (err.group(0) == noAccount){
        toastclass.showToast("帳號錯誤");
      }
      else if (err.group(0) == passwordLength){
        toastclass.showToast("密碼長度必須為6個字元以上");
      }
      else{
        toastclass.showToast("請再次確認帳號以及密碼");
      }
    });

    Navigator.pop(context);
  }

  //Firebase email登入
  Future loginFirebase(BuildContext context, String email, String password) async {
    await mAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then(
            (value){
          Navigator.pop(context);
          auth = value;
          print(auth);
          login = true;
          toastclass.showToast("登入成功! uid = ${auth.uid}");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => newUserSetting(auth.uid)),
          );
        }
    ).catchError((error){
      Navigator.pop(context);
      RegExp exp = new RegExp(r'\d{5}');
      var err = exp.firstMatch(error.toString());
      print(error);
      print(err.group(0));

      if (err.group(0) == accountError){
        showJoinCheckDialog(context, email, password);
      }
      else if (err.group(0) == accountError){
        toastclass.showToast("帳號格式錯誤");
      }
      else if (err.group(0) == passwordError){
        toastclass.showToast("密碼錯誤");
      }
      else{
        toastclass.showToast("請再次確認帳號以及密碼");
      }

    });

  }

  //顯示註冊提示視窗
  Future<Null> showJoinCheckDialog(BuildContext context, String email, String password) async {
    switch (await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: new Text("登入"),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text("您尚未加入過會員是否註冊?"),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('確定'),
              onPressed: () {
                joinFirebase(context, email, password);
                Navigator.pop(context);
                showDialog(context: context, child: new progressdialog().progress);
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
        title: new Text("訊息"),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                controller: passwordCheckEdit,
                decoration: new InputDecoration(hintText: '請輸入電子郵件'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('確定'),
              onPressed: () {
                sendPassword(context, passwordCheckEdit.text);
                Navigator.pop(context);
                showDialog(context: context, child: new progressdialog().progress);
              })
        ],
      ),
    )) {
    }
  }

  //Firebase facebook登入
  Future<Null> logInFaceBook() async {
    final FacebookLoginResult result =
    await facebookSignIn.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        await mAuth.signInWithFacebook(accessToken: result.accessToken.token).then(
                (value){
              auth = value;
              print(auth);
              login = true;
              toastclass.showToast('''登入成功!uid = ${auth.uid}''');

            }
        ).catchError((error){
          RegExp exp = new RegExp(r'\d{5}');
          var err = exp.firstMatch(error.toString());
          print(error);
          print("@@@@@@-"+err.group(0));
          if (err.group(0) == noAccount){
            toastclass.showToast("帳號錯誤");
          }
          else if (err.group(0) == passwordError){
            toastclass.showToast("密碼錯誤");
          }
          else if(err.group(0) == fbAccountError){
            toastclass.showToast("此帳號申請時不為FB登入");
          }
          else{
            toastclass.showToast("請再次確認帳號以及密碼");
          }

        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        toastclass.showToast("無此用戶");
        break;
      case FacebookLoginStatus.error:
        toastclass.showToast("登入錯誤請重新登入");
        break;
    }
  }

  //Firebase google登入
  Future<Null> signInGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null){
      GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
      if(authentication != null){
        FirebaseUser user = await mAuth.signInWithGoogle(idToken: authentication.idToken, accessToken: authentication.accessToken);
        toastclass.showToast("UID-"+user.uid);
      }
    }


  }
}
