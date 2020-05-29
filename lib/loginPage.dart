import 'package:HyperBeam/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.baseAuth, this.onSignedIn});
  final BaseAuth baseAuth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  final loginFormKey = new GlobalKey<FormState>();
  final dynamic style1 = TextStyle(fontSize: 20.0);
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = loginFormKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
  void validateAndSubmit() async {
    if(validateAndSave()) {
      try{
        if(_formType == FormType.login){
          String userId = await widget.baseAuth.signInWithEmailAndPassword(_email, _password);
          print("Signed in: $userId");
        } else {
          String userId = await widget.baseAuth.createWithEmailAndPassword(_email, _password);
          print("Created user: $userId");
        }
        widget.onSignedIn(); //call back on handler
      } catch (err) {
        print("Error: $err");
      }
    }
  }

  void goToRegister() {
    loginFormKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }
  void goToLogin() {
    loginFormKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: _buildLoginBody(context),
    );
  }

  Widget _buildLoginBody(BuildContext context){
    return Container(
        padding: EdgeInsets.all(28),
        //form to  be filled in
        child: new Form(
            key: loginFormKey,
            child: Column(
              children: buildInputs() + [Spacer(flex: 1)] +
                  buildButtons() + [Spacer(flex: 12)],
            )
        )
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
        onSaved: (val) => _email = val,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
        onSaved: (val) => _password = val,
        obscureText: true,
      ),
    ];
  }

  List<Widget> buildButtons() {
    if(_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text('Login', style: style1),
          onPressed: validateAndSubmit,
        ),
        Spacer(flex: 1),
        FlatButton(
          child: Text('Create an account', style: style1),
          onPressed: goToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text('Create an account', style: style1),
          onPressed: validateAndSubmit,
        ),
        Spacer(flex: 1),
        FlatButton(
          child: Text('Already have an account? Login', style: style1),
          onPressed: goToLogin,
        ),
      ];
    }

  }
}