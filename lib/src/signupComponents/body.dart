import 'package:flutter/material.dart';
import 'package:hi_world/src/loginPage.dart';
import 'package:hi_world/src/signupComponents/background.dart';
import 'package:hi_world/src/signupComponents/or_divider.dart';
import 'package:hi_world/src/signupComponents/social_icon.dart';
import 'package:hi_world/src/designComponents/already_have_an_account_acheck.dart';
import 'package:hi_world/src/designComponents/rounded_button.dart';
import 'package:hi_world/src/designComponents/rounded_input_field.dart';
import 'package:hi_world/src/designComponents/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:hi_world/src/signupComponents/body.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _email, _password;
    final auth = FirebaseAuth.instance;

    _signup(String _email, String _password) async {
      try {
        await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);

        //NEU THANH CONG
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                _email = value.trim();
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _password = value.trim();
              },
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () => _signup(_email, _password),
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
