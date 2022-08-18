import 'package:flutter/material.dart';
import 'package:newsheadlines/headline_card.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 48, 42, 42),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'H E A D L I N E S',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'RobotoSlab',
          ),
        ),
        centerTitle: true,
      ),
      body: Headlinecard(),
    );
  }
}
