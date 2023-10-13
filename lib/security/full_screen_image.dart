import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FullScreenImage extends StatelessWidget {
  final String imageLink;
  const FullScreenImage({super.key,required this.imageLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Image.network(
        width:double.maxFinite,
        height:MediaQuery.of(context).size.height,
        imageLink,fit: BoxFit.cover,filterQuality: FilterQuality.medium,));
  }
}