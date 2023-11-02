import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StudentServices {
  static final StudentServices _instance = StudentServices();
  static StudentServices get instance => _instance;

  Future<void> reportVehicle(
      {required String plateNumber,
      required String studentId,
      required String url}) async {
    final docUser =
        FirebaseFirestore.instance.collection('reported_vehicles').doc();

    try {
      // ignore: prefer_interpolation_to_compose_strings
      plateNumber = plateNumber.replaceAll(' ', '');
      DocumentSnapshot owner = await FirebaseFirestore.instance
          .collection('registered_vehicle')
          .doc(plateNumber.toString().toUpperCase())
          .get();
      if (owner.exists) {
        final json = {
          "owner_contact": owner.get('owner_contact'),
          'owner_affiliation': owner.get('applying_for'),
          "student_number": studentId,
          "plate_number": plateNumber,
          "image_link": url,
          "datetime": DateTime.now(),
          "status": false,
        };

        await docUser.set(json);
      } else {
        final json = {
          "owner_contact": "N/A",
          'owner_affiliation': "N/A",
          "student_number": studentId,
          "plate_number": plateNumber,
          "image_link": url,
          "datetime": DateTime.now(),
          "status": false,
        };

        await docUser.set(json);
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> getDownLoadUrl({required XFile file}) async {
    String uploadUrl;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirectory = referenceRoot.child('images');
    Reference imageToUpload =
        referenceDirectory.child(DateTime.now().toString());
    try {
      await imageToUpload.putFile(File(file.path));
      String url = await imageToUpload.getDownloadURL();
      uploadUrl = url;
    } catch (e) {
      throw e.toString();
    }
    return uploadUrl;
  }
}
