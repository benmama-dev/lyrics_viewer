import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';

class ShowDetial extends StatelessWidget {
  final ProfileModel entriess;
  const ShowDetial({Key? key, required this.entriess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // ignore: prefer_interpolation_to_compose_strings
        title: Text(entriess.nameSoung + ' - ' + entriess.name),
      ),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                'เนื้อเพลง/คอร์ดเพลง',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue)),
                child: Image.memory(
                  base64Decode(entriess.image),
                  fit: BoxFit.fill,
                ),
              )
            ],
          )),
    );
  }
}
