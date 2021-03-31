import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './signupScreen.dart';
import './tasks.dart';
import '../controllers/authentications.dart';
import './tasks.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void login() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      signin(email, password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TasksPage(uid: value.uid),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.music,
                size: 100,
                color: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "EmoMusicApp",
                  style: TextStyle(
                      color: Color(0xFFe84545),
                      fontSize: 30.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                          ),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50.0,
                                child: RaisedButton(
                                  onPressed: login,
                                  color: Color(0xFFe84545),
                                  textColor: Colors.white,
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50.0,
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                                  color: Color(0xFF9fd8df),
                                  textColor: Colors.white,
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () => googlesignIn().whenComplete(() async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TasksPage(uid: user.uid)));
                }),
                child: Image(
                  image: AssetImage('assets/signin.png'),
                  width: 200.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
