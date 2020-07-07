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
    var size = MediaQuery.of(context).size;
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
            height: size.height*0.78,
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body:
      Container(
        margin: EdgeInsets.only(top: 18),
        height: size.height,
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
                      child: Flexible(
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
                              //contentPadding: EdgeInsets.only(left: 8,bottom: 12),
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 8, top: 8, right: 15),
                              hintText: "Search module"),
                          validator: (val){
                            if(!NUS_MODULES.containsCode(val) && val != "") {
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
                    ),
                  ),
                ]
              ),
              buildGrid(context, query),
            ]
        ),
      ),
    );
  }

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