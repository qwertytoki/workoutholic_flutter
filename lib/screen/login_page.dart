import 'package:flutter/material.dart';
import 'package:workoutholic/auth.dart';

class LoginPage extends StatefulWidget {
  // LoginPage({this.auth, this.onSignedIn});
  LoginPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  // final formKey = new GlobalKey<FormState>();
  // String _email;
  // String _password;
  // FormType _formType = FormType.login;
  // bool validateAndSave() {
  //   final form = formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     // print('Form is valid, email: $_email, password: $_password');
  //     return true;
  //   }
  //   return false;
  // }

  // void moveToRegister() {
  //   // formKey.currentState.reset();
  //   setState(() {
  //     _formType = FormType.register;
  //   });
  // }

  // void moveToLogin() {
  //   // formKey.currentState.reset();
  //   setState(() {
  //     _formType = FormType.login;
  //   });
  // }

  // void validateAndSubmit() async {
  //   if (validateAndSave()) {
  //     try {
  //       if (_formType == FormType.login) {
  //         String userId =
  //             await widget.auth.signInWithEmailAndPassword(_email, _password);
  //         print('Signed in:$userId');
  //       } else {
  //         String userId = await widget.auth
  //             .createUserWithEmailAndPassword(_email, _password);
  //         print('Registered user: $userId');
  //       }
  //       widget.onSignedIn();
  //     } catch (e) {
  //       print('error: $e');
  //     }
  //   }
  // }
  
  void signInWithGoogle() async{
    print("ログインを試す");
    widget.auth.googleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
        ),
        body: new Container(
        // body: Center(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  onPressed: () => signInWithGoogle,
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text('Login with Google'),
                )
              ],
            )
            // child: new Form(
            //     key: formKey,
            //     child: new Column(
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: buildInputs() + buildSubmitButtons(),
                // ))
            ));
  }


  // List<Widget> buildInputs() {
  //   return [
  //     new TextFormField(
  //       decoration: new InputDecoration(labelText: 'Email'),
  //       validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
  //       onSaved: (value) => _email = value,
  //     ),
  //     new TextFormField(
  //       decoration: new InputDecoration(labelText: 'Password'),
  //       obscureText: true,
  //       validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
  //       onSaved: (value) => _password = value,
  //     ),
  //   ];
  // }

  // List<Widget> buildSubmitButtons() {
  //   if (_formType == FormType.login) {
  //     return [
  //       new RaisedButton(
  //         child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
  //         onPressed: validateAndSubmit,
  //       ),
  //       new FlatButton(
  //         child: new Text('Create an account',
  //             style: new TextStyle(fontSize: 20.0)),
  //         onPressed: moveToRegister,
  //       ),
  //     ];
  //   } else {
  //     return [
  //       new RaisedButton(
  //         child: new Text('Create an account',
  //             style: new TextStyle(fontSize: 20.0)),
  //         onPressed: validateAndSubmit,
  //       ),
  //       new FlatButton(
  //         child: new Text('Have an account? Login ',
  //             style: new TextStyle(fontSize: 20.0)),
  //         onPressed: moveToLogin,
  //       ),
  //     ];
  //   }
  // }
}
