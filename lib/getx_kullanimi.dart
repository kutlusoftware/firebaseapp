import 'package:flutter/material.dart';

class GetxKullanimi extends StatefulWidget {
  const GetxKullanimi({super.key});

  @override
  State<GetxKullanimi> createState() => _GetxKullanimiState();
}

class _GetxKullanimiState extends State<GetxKullanimi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Getx Sepet Uygulaması"),
        backgroundColor: Colors.deepPurple.shade300,
        foregroundColor: Colors.white,
      ),
    );
  }
}
