import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Aplikasi Kasir"),
          centerTitle: true,
          ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red
            ),
child: Column(
children: [
  
],
),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue
            ),
child: Column(children: [

]),
          )
        ],
      ),
      ),
    );
  }
}
