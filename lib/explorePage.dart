import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/objectClasses.dart';
import 'package:HyperBeam/quizOverview.dart';
import 'package:HyperBeam/services/firebase_auth_service.dart';
import 'package:HyperBeam/services/firebase_module_service.dart';
import 'package:HyperBeam/services/firebase_quiz_service.dart';
import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  DataRepo quizRepository;
<<<<<<< HEAD
  String query;
  final searchKey = new GlobalKey<FormState>();

  Widget buildGrid(BuildContext context, String query) {
    var size = MediaQuery.of(context).size;
=======
  //List<Widget> argument = [Text("loading")];

  @override
  Widget build(BuildContext context) {
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    return StreamBuilder<QuerySnapshot>(
        stream: quizRepository.getStream(), //stream<QuerySnapshot>
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          final user = Provider.of<User>(context, listen: false);
<<<<<<< HEAD
          List<Widget> lst;
          if(query == null || query == "") {
            lst = snapshot.data.documents.toList()
                .where((element){
                  return element.data['private'] == false || element.data['private'] == null;
                })
                .toList()
                .where((element) => element.data['uid'] != user.id)
                .map((e) => _buildQuizCard(Quiz.fromSnapshot(e))).toList();
          } else {
            lst = snapshot.data.documents.toList()
                .where((element){
                  return element.data['private'] == false;
                })
                .toList()
                .where((element) => element.data['moduleName'].contains(query, 0))
                .toList()
                .where((element) => element.data['uid'] != user.id)
                .map((e) => _buildQuizCard(Quiz.fromSnapshot(e))).toList();
          }
          return Flexible(
            child: Container(
              height: size.height*0.8 - 36,
=======
          List<Widget> lst = snapshot.data.documents.toList()
              .where((element) => element.data['uid'] != user.id)
              .map((e) => _buildQuizCard(Quiz.fromSnapshot(e))).toList();
          print("begin building list of length ${lst.length}");
          return Scaffold(
            backgroundColor: Colors.transparent,
            body:
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 800,
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
              width: 500,
              child: Column(
                  children: [
                    Container(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.headline2,
                                children: [
                                  TextSpan(text: "Explore",
                                      style: TextStyle(fontWeight: FontWeight.bold, )
                                  )
                                ]
                            )
                        )
                    ),
                    Container(
                      height: 580,
                      width: 500,
                      child: CustomScrollView(
                      primary: false,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.all(20),
                          sliver: SliverGrid.count(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: lst,
                          ),
                        ),
                      ],
                    ),
                    ),
                  ]
              ),
            ),
          );
        });
  }
  /*
  @override
  void initState() {
    super.initState();
    generate(context).then((value){
      setState(() {
        print("HIT");
        argument = value;
        print("DONE");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();

    return Scaffold(
      backgroundColor: Colors.transparent,
<<<<<<< HEAD
      body:
      Center(
        child: Container(
          margin: EdgeInsets.only(top: 18),
          height: size.height,
          width: 500,
          child: Column(
              children: [
                Container(
=======
        body:
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 800,
              width: 500,
              child: Column(
                children: [
                  Container(
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: Theme.of(context).textTheme.headline2,
                            children: [
                              TextSpan(text: "Explore",
<<<<<<< HEAD
                                  style: TextStyle(fontWeight: FontWeight.bold,)
                              ),
                            ]
                        )
                    )
                ),
                Stack(
                  children: [
                    Card(
                      elevation: 2,
                      child: Container(
                        width: 280,
                        height: 36,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                validateAndSave();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Form(
                      key: searchKey,
                      autovalidate: true,
                      child: Container(
                        width: 280,
                        height: 56,
                        child: TextFormField(
                          onChanged: (text){
                            setState(() {
                              query = text.toUpperCase();
                            });
                          },
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 8, top: 8, right: 15),
                              hintText: "Search module"),
                          validator: (val){
                            if(!NUS_MODULES.containsCode(val.toUpperCase()) && val != "") {
                              return "Please input a valid module";
                            } else{
                              return null;
                            }
                          },
                          onSaved: (val){
                            setState(() {
                              query = val.toUpperCase();
                            });
                          },
                        ),
                      ),
                    ),
                  ]
                ),
                buildGrid(context, query),
              ]
          ),
        ),
      ),
    );
  }

=======
                                  style: TextStyle(fontWeight: FontWeight.bold, )
                              )
                            ]
                        )
                    )
                  ),
                  Container(
                    height: 600,
                    width: 500,
                    child: Column(
                      children: argument,
                    ),
                  ),
                ]
              ),
            ),
    );
  }
  
  Future<List<Widget>> generate(BuildContext context) async {
    CollectionReference userRepo = Firestore.instance.collection('users');
    Stream<QuerySnapshot> userStream = userRepo.snapshots();
    Future<List<Widget>> output;
    print("GENERATE");
    await userRepo.getDocuments().then((value) {
      print(value);
      output = buildQuizListFromUser(value.documents[0]);
      return 0;
    });
    print("GENERATE DONE");
    return output;
  }

  Widget _generateData(BuildContext context) {
    CollectionReference userRepo = Firestore.instance.collection('users');
    Stream<QuerySnapshot> userStream = userRepo.snapshots();
    final moduleRepo = Provider.of<FirebaseModuleService>(context).getRepo();
//both moduleRepo and userRepo are collections
    return StreamBuilder<QuerySnapshot> (
      stream: userStream,
      builder: (context, snapshot) { //snapshot.data.document is list of user docSnap
        if (!snapshot.hasData) return LinearProgressIndicator();
        //Module mod = Module.fromSnapshot(snapshot.data.documents[0]);
        return CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [Text("GG"), Text("GGGG")],
              ),
            ),
          ],
        );
      });
  }

  Widget buildQuizItem(DocumentReference docRef) { //convert docRef to docSnap in widget
    return StreamBuilder<DocumentSnapshot> (
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return LinearProgressIndicator();
          return Text(snapshot.data['name']);
        }
    );
  }


  List<Widget> buildQuizList(Module mod) {
    print(mod.quizList);
    return mod
            .quizList
            .map((e) => buildQuizItem(e))
            .toList();
  }

  Future<List<Widget>> buildQuizListFromUser(DocumentSnapshot userSnap) async{
    print("buildQuizListFromUser");
     final moduleRepo = Firestore.instance
         .collection('users')
         .document(userSnap.documentID)
         .collection('Modules');
     List<Widget> output;
     await moduleRepo.getDocuments().then((value){
       List<DocumentSnapshot> moduleLst = value.documents;
       Module mod = Module.fromSnapshot(moduleLst[0]);
       output = buildQuizList(mod);
     });
     return output;
  }
*/


>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
  Widget _buildQuizCard(Quiz quiz) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("users").document(quiz.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
<<<<<<< HEAD
        num quizRating = 0 ;
        if(quiz.reviewers != null){
          for(int i = 1; i < quiz.reviewers.length; i = i + 2) {
            quizRating += num.parse(quiz.reviewers[i]);
          }
          quizRating = quizRating*2 / quiz.reviewers.length;
        }
        return GestureDetector(
          onTap: () async {
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
                          height: 180,
                          child: Column(
                            children: [
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    color: kPrimaryColor,
                                    child: Text('View Quiz'),
                                    onPressed: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context){
                                            return QuizOverview(quiz: quiz, fullScore: quiz.fullScore);
                                          })
                                      );
                                    },
                                  ),
                                  RaisedButton(
                                    color: kAccentColor,
                                    child: Text('Add Quiz'),
                                    onPressed: () async {
                                      final userRepo = Provider.of<User>(context);
                                      final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();
                                      User user = Provider.of<User>(context);
                                      final quizRepo  = Provider.of<FirebaseQuizService>(context).getRepo();
                                      quizRepo.incrementList(quiz.reference.documentID, "users", user.id);
                                      int result = await moduleRepository.incrementList(
                                          quiz.moduleName, "quizzes", quiz.reference
                                      ); // add to user's repo
                                      if(result == 1) {
                                        Navigator.pop(dialogContext);
                                      } else {
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
                                                    padding: EdgeInsets.all(16),
                                                    height: 320,
                                                    child: Column(
                                                        children: [
                                                          Spacer(),
                                                          RichText(
                                                            textAlign: TextAlign.center,
                                                            text: TextSpan(
                                                              style: TextStyle(color: Colors.black, fontSize: kBigText, fontWeight: FontWeight.bold),
                                                              text: "Please create the module at home page first",
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
                                    },
                                  ),
                                ],
                              ),
                              Spacer(),
                            ],
                          )
                      )
                  );
                }
            );
          },
          child: Stack(
              children: [
                Opacity(
                    opacity: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: kBigText),
                              text: "${quiz.moduleName ?? "???"}",
                            )
                        ),
                      ),
                      Container(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: kMediumText),
                              text: "${quiz.name}",
                            )
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: kSmallText),
                              text: "No. of questions: ${quiz.fullScore}",
                            )
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: kSmallText),
                              text: "Rating: $quizRating",
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: kSmallText),
                              text: "Made by: ${snapshot.data['name'] ?? "Anon"}",
                            )
                        ),
                      ),
                    ],
=======
        return Stack(
            children: [
              GestureDetector(
                onTap: () async {
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
                                height: 160,
                                child: Column(
                                  children: [
                                    SizedBox(height: 24,),
                                    RaisedButton(
                                      color: kPrimaryColor,
                                      child: Text('View Quiz'),
                                      onPressed: (){
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context){
                                            return Scaffold(
                                              body: Column(
                                                children: <Widget>[
                                                  Text("test"),
                                                ],
                                              )
                                            );
                                          })
                                        );
                                      },
                                    ),
                                    SizedBox(height: 12,),
                                    RaisedButton(
                                      color: kAccentColor,
                                      child: Text('Add Quiz'),
                                      onPressed: () async {
                                        final userRepo = Provider.of<User>(context);
                                        final moduleRepository = Provider.of<FirebaseModuleService>(context).getRepo();

                                         DocumentSnapshot quizLst = await moduleRepository
                                            .getCollectionRef()
                                             .where('name',isEqualTo: quiz.moduleName)
                                             .getDocuments()
                                             .then((value) => value.documents[0]);
                                         Module mod = Module.fromSnapshot(quizLst);
                                        var newList = mod.quizList.toList(growable: true);
                                        newList.add(quiz.reference);
                                        mod.quizList = newList;
                                        moduleRepository.updateDoc(mod);
                                                  //reference.updateData({data})
                                      },
                                    ),
                                  ],
                                )
                            )
                        );
                      }
                  );
                },
                child: Opacity(
                  opacity: 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: kBigText),
                          text: "${quiz.moduleName ?? "???"}",
                        )
                    ),
                  ),
                  Container(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: kMediumText),
                          text: "${quiz.name}",
                        )
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: kSmallText),
                          text: "No. of questions: ${quiz.fullScore}",
                        )
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: kSmallText),
                          text: "Ratings: NA",
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: kSmallText),
                          text: "Made by: ${snapshot.data['lastName'] ?? "Anon"}",
                        )
                    ),
>>>>>>> 363688c2edba0b457ebe4d9e93a3b87204bc0eb3
                  ),
              ]
          ),
        );
      }
    );
  }
}