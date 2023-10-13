import 'package:cloud_firestore/cloud_firestore.dart';

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
      throw (e);
    }
    print(success);
    return success;
  }

  Future addUser({required String name,required String affilation, required String contact, required String plate})async{
    String plateNumber = plate.replaceAll(" ", "");
    final owners = FirebaseFirestore.instance.collection("registered_owner").doc(plateNumber.toUpperCase());
    try{
      final json = {
        "affiliation":affilation,
        "contact":contact,
        "name":name
      };
      await owners.set(json);
    }catch(e){
      throw e.toString();
    }
  }
}