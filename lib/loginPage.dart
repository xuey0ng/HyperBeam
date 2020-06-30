import 'package:HyperBeam/auth.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';

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
  String _firstName;
  String _lastName;
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
  void validateAndSubmit(BuildContext context) async {
    final auth = Provider.of<FirebaseAuthService>(context);
    if(validateAndSave()) {
      try{
        if(_formType == FormType.login){
          User user0 = await auth.signInWithEmailAndPassword(_email, _password);
          User user = await Firestore.instance.collection("users").document(user0.id).get().then((value){
            print("it is ${value.data.toString()}");
            return User(firstName: value.data['firstName'], lastName: value.data['lastName'],
            email: value.data['email'], id: user0.id);
          });
          print("Signed in: $user");
        } else {
          User user = await auth.createWithEmailAndPassword(_email, _password);
          user.firstName = _firstName;
          user.lastName = _lastName;
          user.email = _email;
          Firestore.instance.collection("users").document(user.id).setData({
            'firstName' : user.firstName,
            'lastName' : user.lastName,
            'email' : user.email,
          });
          print("Created user: ${user.id}");
        }
        //widget.onSignedIn(); //call back on handler
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
          decoration: InputDecoration(labelText: 'First name'),
          validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
          onSaved: (val) => _firstName = val,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Last name'),
          validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
          onSaved: (val) => _lastName = val,
        ),
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
  }

  List<Widget> buildButtons() {
    if(_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text('Login', style: style1),
          color: kAccentColor,
          onPressed: () => validateAndSubmit(context),
        ),
        Spacer(flex: 1),
        FlatButton(
          child: Text('Create an account', style: style1),
          color: kAccentColor,
          onPressed: goToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text('Create an account', style: style1),
          color: kAccentColor,
          onPressed: () {
            validateAndSubmit(context);
          }
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
