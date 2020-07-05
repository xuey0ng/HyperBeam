import 'package:HyperBeam/dataRepo.dart';
import 'package:flutter/foundation.dart';

class FirebaseUserService {
  final String id;
  final lastName;
  final firstName;
  final email;
  List<String> friendList;
  FirebaseUserService({@required this.id, this.lastName, this.firstName, this.email, this.friendList}) : assert(id != null);

  DataRepo getRepo() {
    return DataRepo(id, "users");
  }
}