import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final double deviceHeight;
  final double deviceWidth;
  const Header(
      {super.key, required this.deviceHeight, required this.deviceWidth});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.deviceHeight * .50,
        width: widget.deviceHeight,
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/car.jpeg"),fit: BoxFit.cover))));
  }
}
