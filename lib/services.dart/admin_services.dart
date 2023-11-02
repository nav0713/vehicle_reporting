import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_reporting/model/vehicle.dart';

class AdminServices {
  static final AdminServices _instance = AdminServices();
  static AdminServices get instance => _instance;
  Future<bool> adminLogin(
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
      throw (e.toString());
    }
    return success;
  }

  Future addUser(
      {required String name,
      required String affilation,
      required String contact,
      required String plate}) async {
    String plateNumber = plate.replaceAll(" ", "");
    final owners = FirebaseFirestore.instance
        .collection("registered_owner")
        .doc(plateNumber.toUpperCase());
    try {
      final json = {
        "affiliation": affilation,
        "contact": contact,
        "name": name
      };
      await owners.set(json);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateRegistration({
    required Vehicle vehicle,
  }) async {
    final docVehicle =
        FirebaseFirestore.instance.collection('registered_vehicle');
    try {
      final jsonVehicle = {
        "applying_for": vehicle.applyingFor,
        "brand": vehicle.brand,
        "color": vehicle.color,
        "images": vehicle.images,
        "owner_id": vehicle.ownerId,
        "owner_name": vehicle.ownerName,
        "owner_address": vehicle.ownerAddress,
        "owner_contact": vehicle.ownerContact,
        "plate": vehicle.plate.toUpperCase(),
        "relationship": vehicle.relationship,
        "remarks": vehicle.remarks,
        "status": vehicle.status,
        "vehicle_type": vehicle.type
      };
      await docVehicle.doc(vehicle.plate).delete();
      await docVehicle.doc(vehicle.plate).set(jsonVehicle);
    } catch (e) {
      throw e.toString();
    }
  }
}
