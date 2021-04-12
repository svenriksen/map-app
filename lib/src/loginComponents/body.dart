import 'package:flutter/material.dart';
import 'package:hi_world/src/loginComponents/background.dart';
import 'package:hi_world/src/signup.dart';
import 'package:hi_world/src/designComponents/already_have_an_account_acheck.dart';
import 'package:hi_world/src/designComponents/rounded_button.dart';
import 'package:hi_world/src/designComponents/rounded_input_field.dart';
import 'package:hi_world/src/designComponents/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hi_world/src/UserPage.dart';
import 'package:hi_world/src/Global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String Extract(String str) {
      String res = "";
      int i = 0;
      while (str[i] != "@") {
        res += str[i];
        ++i;
      }
      return res;
    }

    String _email, _password;
    final auth = FirebaseAuth.instance;
    _signin(String _email, String _password) async {
      print(_email);
      print(_password);
      try {
        await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Credentials.email = _email;
        Credentials.name = Extract(Credentials.email);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (!prefs.containsKey('username') || !prefs.containsKey('password')) {
          prefs.setString('username', _email);
          prefs.setString('password', _password);
        }
        //NEU THANH CONG
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserPage()));
      } on FirebaseAuthException catch (error) {
        Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
      }
    }

    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {
                  _email = value;
                }),
            RoundedPasswordField(
              onChanged: (value) {
                _password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () => _signin(_email, _password),
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
