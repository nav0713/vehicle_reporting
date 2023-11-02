import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final String url;
  const MyWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }
}
