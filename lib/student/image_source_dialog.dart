import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:vehicle_reporting/style.dart';

void imagePickerModal({required BuildContext context, void Function()? cameraOnTap, void Function()? galleryOntap}){
  showModalBottomSheet(context: context, builder: (context){
    return SizedBox(
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: cameraOnTap,
            child:  SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton.icon(
                style: mainBtnStyle(Colors.deepOrange, Colors.transparent, Colors.white10),
                icon:const Icon(FontAwesome5.camera) , onPressed: cameraOnTap,label: const Text("Camera"),)),),
            const SizedBox(height: 20,),
                 GestureDetector(
            onTap: cameraOnTap,
            child:  SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton.icon(
                style: mainBtnStyle(Colors.cyanAccent, Colors.transparent, Colors.white10),
                icon:const Icon(Icons.image,color: Colors.black,) , onPressed: galleryOntap,label: const Text("Gallery",style: TextStyle(color: Colors.black),),)),),
        ],
    ),);
  });
}