import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_reporting/model/vehicle.dart';

class VehicleServices {
  static final VehicleServices _instance = VehicleServices();
  static VehicleServices get instance => _instance;
  final docVehicle =
      FirebaseFirestore.instance.collection('registered_vehicle');
  Future<void> addVehicle({
    required Vehicle vehicle,
    required List<XFile> images,
  }) async {
    try {
      for (var image in images) {
        String url = await getDownLoadUrl(file: image);
        vehicle.images.add(url);
      }
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

  Future<void> update({
    required Vehicle vehicle,
    required List<XFile> images,
  }) async {
    try {
      if (images.isNotEmpty) {
        for (var image in images) {
          String url = await getDownLoadUrl(file: image);
          vehicle.images.add(url);
        }
      }

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
