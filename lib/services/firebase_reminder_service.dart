import 'package:HyperBeam/dataRepo.dart';
import 'package:flutter/foundation.dart';

class FirebaseReminderService {
  final String id;
  FirebaseReminderService({@required this.id}) : assert(id != null);

  DataRepo getRepo() {
    return DataRepo.fromRepo("Reminders");
  }
}