
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackGroundGradient extends StatelessWidget {
    final double deviceHeight;
  final double deviceWidth;
  const BackGroundGradient({super.key, required this.deviceHeight, required this.deviceWidth});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: deviceHeight * .80 ,
      width: deviceWidth,
      decoration: const  BoxDecoration(
        gradient: LinearGradient(colors: [Color.fromRGBO(35, 45, 59, 1),Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.65,1.0]),
        
      ),

    );
  }
}