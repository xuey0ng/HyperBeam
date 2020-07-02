import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/objectClasses.dart';
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
  String query;
  final searchKey = new GlobalKey<FormState>();
  //List<Widget> argument = [Text("loading")];

  Widget buildGrid(BuildContext context, String query) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    return StreamBuilder<QuerySnapshot>(
        stream: quizRepository.getStream(), //stream<QuerySnapshot>
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          final user = Provider.of<User>(context, listen: false);
          List<Widget> lst;
          if(query == null || query == "") {
            lst = snapshot.data.documents.toList()
                .where((element) => element.data['uid'] != user.id)
                .map((e) => _buildQuizCard(Quiz.fromSnapshot(e))).toList();
          } else {
            lst = snapshot.data.documents.toList()
                .where((element) => element.data['moduleName'] == query)
                .toList()
                .where((element) => element.data['uid'] != user.id)
                .map((e) => _buildQuizCard(Quiz.fromSnapshot(e))).toList();
          }
          print("begin building list of length ${lst.length}");
          return Container(
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
          );
        });
  }
  void validateAndSave() {
    final form = searchKey.currentState;
    if(form.validate()) {
      form.save();
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
      Container(
        margin: EdgeInsets.only(top: 20),
        height: 800,
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
                            ),
                          ]
                      )
                  )
              ),
              Form(
                key: searchKey,
                autovalidate: true,
                child: Container(
                  width: 280,
                  height: 48,
                  child: Card(
                    elevation: 2,
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            onChanged: (text){
                              setState(() {
                                query = text;
                              });
                            },
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Search module"),
                              validator: (val){
                                print(val);
                                if(!MODULE_CODES.contains(val) && val != "") {
                                  return "Please input a valid module";
                                } else{
                                  return null;
                                }
                              },
                              onSaved: (val){
                                setState(() {
                                  query = val;
                                });
                              },

                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              validateAndSave();
                            },
                        ),
                      ]
                    ),
                  ),
                ),
              ),
              buildGrid(context, query),
            ]
        ),
      ),
    );
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
        body:
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 800,
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


  Widget _buildQuizCard(Quiz quiz) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("users").document(quiz.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
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
                  ),
                ],
              )
            ]
        );
      }
    );
  }
}