//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './signup_page.dart';
import './forgot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSignedOut;

  final Function onSignedIn;

  const LoginPage({Key key, this.onSignedOut, this.onSignedIn})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Login to iSkorez')),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return "email cannot be empty";
                    }
                  },
                  onSaved: (input) => _email = input,
                  decoration: InputDecoration(labelText: 'Your email'),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return "Please provide a password";
                    }
                  },
                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(labelText: 'Your password'),
                  obscureText: true,
                ),
                FlatButton(
                  onPressed: signIn,
                  child: Text("Login", style: TextStyle(color: Colors.white)),
                  color: Colors.blue,
                ),
                forgotPassBtn(),
                FlatButton(
                  onPressed: invokeSignupPage,
                  child: Text(
                    "Not a member yet? Sign up!",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            )),
      ),
    );
  }

//Sign in funtion
//Validates form and SignsIn with FirebaseAuth
  void signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        //On succesful logIn, set _authStatus = AuthStatus.signedIn;
        widget.onSignedIn(user);
      } catch (e) {
        print(e);
      }
    }
  }

//invoke Signup Page
  void invokeSignupPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  } //END
//==================================

Widget forgotPassBtn(){
  return FlatButton(
    onPressed: invokeForgotPassPage,
    child:Text("forgot password?") ,
    
  );
}

void invokeForgotPassPage(){
 Navigator.push(
       context,
           MaterialPageRoute(builder: (context) => ForgotPassword()));  

}
//-------------------------------------------------------
}
