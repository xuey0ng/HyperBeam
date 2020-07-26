import 'package:HyperBeam/main.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        showDialog(
            context: context,
            builder: (BuildContext context) {
              final dialogContext = context;
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(20.0)
                  ),
                  backgroundColor: kSecondaryColor,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    height: 200,
                    child: Column(
                        children: [
                          Spacer(),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                              text: "Unable to log in with the chosen Gmail\n Please try login with HyperBeam account instead",
                            ),
                          ),
                          Spacer(),
                          RaisedButton(
                            child: Text("Ok"),
                            color: kAccentColor,
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                          ),
                          Spacer(),
                        ]
                    ),
                  )
              );
            }
        );
        print("Error: $err");
      }
<<<<<<< HEAD
    } else {
      if(validateAndSave()) {
        try{
          if (_formType == FormType.login) {
            try {
              User user0 = await auth.signInWithEmailAndPassword(_email, _password);
              if(!user0.verified) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final dialogContext = context;
                      return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:  BorderRadius.circular(20.0)
                          ),
                          backgroundColor: kSecondaryColor,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 200,
                            child: Column(
                                children: [
                                  Spacer(),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                                      text: "Please verify your email",
                                    ),
                                  ),
                                  Spacer(),
                                  RaisedButton(
                                    child: Text("Ok"),
                                    color: kAccentColor,
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      goToLogin();
                                    },
                                  ),
                                  Spacer(),
                                ]
                            ),
                          )
                      );
                    }
                );
              }
              User user = await Firestore.instance.collection("users").document(user0.id).get().then((value){
                return User(name: value.data['name'],
                    email: value.data['email'], id: user0.id);
              });
              print("Signed in: $user");
            } on PlatformException {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final dialogContext = context;
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(20.0)
                        ),
                        backgroundColor: kSecondaryColor,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          height: 200,
                          child: Column(
                              children: [
                                Spacer(),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                                    text: "Incorrect email / password",
                                  ),
                                ),
                                Spacer(),
                                RaisedButton(
                                  child: Text("Ok"),
                                  color: kAccentColor,
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                ),
                                Spacer(),
                              ]
                          ),
                        )
                    );
                  }
              );
            }
          } else {
            try {
              User user = await auth.createWithEmailAndPassword(_email, _password);
              user.name = _name;
              user.email = _email;
              Firestore.instance.collection("users").document(user.id).setData({
                'name' : user.name,
                'email' : user.email,
              });
              goToLogin();
              FirebaseAuth.instance.signOut();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final dialogContext = context;
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(20.0)
                        ),
                        backgroundColor: kSecondaryColor,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          height: 200,
                          child: Column(
                              children: [
                                Spacer(),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                                    text: "A verification email will be sent to the email",
                                  ),
                                ),
                                Spacer(),
                                RaisedButton(
                                  child: Text("Ok"),
                                  color: kAccentColor,
                                  onPressed: () async {
                                        Navigator.pop(context);

                                  },
                                ),
                                Spacer(),
                              ]
                          ),
                        )
                    );
                  }
              );
            } on PlatformException {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final dialogContext = context;
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(20.0)
                        ),
                        backgroundColor: kSecondaryColor,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          height: 200,
                          child: Column(
                              children: [
                                Spacer(),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                                    text: "Account already in use",
                                  ),
                                ),
                                Spacer(),
                                RaisedButton(
                                  child: Text("Ok"),
                                  color: kAccentColor,
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                ),
                                Spacer(),
                              ]
                          ),
                        )
                    );
                  }
              );
            }
          }
        } catch (err) {
          print("Error: $err");
        }
      }
=======
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
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
<<<<<<< HEAD
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Center(child: Text("Hyper Beam", style: TextStyle(fontSize: kExtraBigText),))),
=======
      appBar: AppBar(title: Text("Login")),
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
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
<<<<<<< HEAD
        Spacer(flex: 1),
        _signInButton(),
        Spacer(flex: 1),
        Container(
          width: size.width * 0.8,
          child: OutlineButton(
            splashColor: Colors.grey,
            onPressed: () async {
              final emailFormKey = new GlobalKey<FormState>();
              final auth = Provider.of<FirebaseAuthService>(context);
              String email2;
              BuildContext dialogContext;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    dialogContext = context;
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(20.0)
                      ),
                      backgroundColor: kSecondaryColor,
                      child: Container(
                        height: 264,
                        child: SingleChildScrollView(
                          child: Column(
                              children: [
                                Form(
                                    key: emailFormKey,
                                    autovalidate: true,
                                    child: Container(
                                      height: 264,
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Spacer(),
                                          RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: TextStyle(color: Colors.black, fontSize: kExtraBigText),
                                                text: "Reset password",
                                              )
                                          ),
                                          Spacer(),
                                          TextFormField(
                                            autofocus: true,
                                            autovalidate: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Enter your email",
                                            ),
                                            validator: (val) => val.isEmpty ? 'Please fill in this field' : null,
                                            onSaved: (text) {
                                              setState(() {
                                                email2 = text;
                                              });
                                            },
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              FlatButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }
                                              ),
                                              RaisedButton(
                                                child: Text("Reset"),
                                                color: kAccentColor,
                                                onPressed: () async {
                                                  final auth = Provider.of<FirebaseAuthService>(context);
                                                  emailFormKey.currentState.save();
                                                  if(emailFormKey.currentState.validate()){
                                                    auth.resetPassword(email2);
                                                  }
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    )
                                ),
                              ]
                          ),
                        ),
                      ),
                    );
                  }
              );
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
                      'Reset password',
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
=======
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
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
