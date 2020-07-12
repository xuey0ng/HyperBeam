import 'package:HyperBeam/auth.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  //final BaseAuth baseAuth;
  //final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

//Single page
enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  String _name;
  String _email;
  String _password;
  var size;
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
  void validateAndSubmit(BuildContext context, bool googleSignIn) async {
    final auth = Provider.of<FirebaseAuthService>(context);
    if (googleSignIn) {
      try {
        await auth.signInWithGoogle();
      } catch (err) {
        print("Error: $err");
      }
    } else {
      if(validateAndSave()) {
        try{
          if (_formType == FormType.login) {
            User user0 = await auth.signInWithEmailAndPassword(_email, _password);
            User user = await Firestore.instance.collection("users").document(user0.id).get().then((value){
              return User(name: value.data['name'],
                  email: value.data['email'], id: user0.id);
            });
            print("Signed in: $user");
          } else {
            User user = await auth.createWithEmailAndPassword(_email, _password);
            user.name = _name;
            user.email = _email;
            Firestore.instance.collection("users").document(user.id).setData({
              'name' : user.name,
              'email' : user.email,
            });
            print("Created user: ${user.id}");
          }
        } catch (err) {
          print("Error: $err");
        }
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Login")),
      body: _buildLoginBody(context),
    );
  }

  Widget _buildLoginBody(BuildContext context){
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg2.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(28),
            //form to  be filled in
            child: new Form(
                key: loginFormKey,
                child: Column(
                  children: buildInputs() + [Spacer(flex: 1)] +
                      buildButtons() + [Spacer(flex: 12)],
                )
            )
        ),
      ]

    );
  }

  List<Widget> buildInputs() {
    if(_formType == FormType.login) {
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
    } else {
      return [
        TextFormField(
          decoration: InputDecoration(labelText: 'Name'),
          validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
          onSaved: (val) => _name = val,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
          onSaved: (val) => _email = val,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Password'),
          validator: (val) => val.toString().length < 6 ? 'Password has to be at least 6 characters' : null,
          onSaved: (val) => _password = val,
          obscureText: true,
        ),
      ];
    }
  }

  List<Widget> buildButtons() {
    if(_formType == FormType.login) {
      return [
        Container(
          width: size.width * 0.8,
          child: OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
              validateAndSubmit(context, false);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Spacer(flex: 1),
        Container(
          width: size.width * 0.8,
          child: OutlineButton(
            splashColor: Colors.grey,
            onPressed: goToRegister,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Spacer(flex: 1),
        _signInButton(),
      ];
    } else {
      return [
        Container(
          width: size.width * 0.8,
          child: OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
              validateAndSubmit(context, false);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Spacer(flex: 1),
        Container(
          width: size.width * 0.8,
          child: OutlineButton(
            splashColor: Colors.grey,
            onPressed: goToLogin,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Already have an account?\nLogin',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ];
    }
  }

  Widget _signInButton() {
    return Container(
      width: size.width * 0.8,
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          validateAndSubmit(context, true);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
