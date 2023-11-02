import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_reporting/model/logs.dart';

class SecurityServices {
  static final SecurityServices _instance = SecurityServices();
  static SecurityServices get instance => _instance;

  Future<bool> securityLogin(
      {required String username,
      required String password,
      required String type}) async {
    final collectionRef = FirebaseFirestore.instance.collection("users");
    bool success = false;
    try {
      QuerySnapshot query = await collectionRef
          .where("username", isEqualTo: username.toLowerCase())
          .where("password", isEqualTo: password.toLowerCase())
          .where("type", isEqualTo: type)
          .get();

      if (query.docs.isNotEmpty) {
        success = true;
      }
    } catch (e) {
      throw (e);
    }
    print(success);
    return success;
  }

  Future<VehicleLogs> postLogs({required String plate}) async {
    String plateNumber = plate.replaceAll(' ', '');
    VehicleLogs log;
    final logsCollection =
        FirebaseFirestore.instance.collection("vehicle_logs").doc();
    try {
      final owner = await FirebaseFirestore.instance
          .collection('registered_vehicle')
          .doc(plateNumber)
          .get();

      if (!owner.exists) {
        log = VehicleLogs(
            affiliation: "Visitor",
            datetime: DateTime.now(),
            ownerName: "Visitor",
            plateNumber: plateNumber);
      } else {
        log = VehicleLogs(
            affiliation: owner.get("applying_for"),
            datetime: DateTime.now(),
            ownerName: owner.get('owner_name'),
            plateNumber: plateNumber);
      }

      final json = {
        "owner_name": log.ownerName,
        "plate_number": log.plateNumber,
        "datetime": log.datetime,
        "affiliation": log.affiliation
      };
      await logsCollection.set(json);
    } catch (e) {
      throw e.toString();
    }
    return log;
  }
}
