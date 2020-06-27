import 'package:HyperBeam/dataRepo.dart';
import 'package:HyperBeam/objectClasses.dart';
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
  //List<Widget> argument = [Text("loading")];

  @override
  Widget build(BuildContext context) {
    final quizRepository = Provider.of<FirebaseQuizService>(context).getRepo();
    return StreamBuilder<QuerySnapshot>(
        stream: quizRepository.getStream(), //stream<QuerySnapshot>
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          List<Widget> lst = snapshot.data.documents.toList().map((e) => _buildQuizCard(Quiz.fromSnapshot(e))).toList();

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
    return Stack(
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
                    text: "Ratings: NA",
                  )
              ),
            ),
          ],
        )
      ]
    );
  }

}