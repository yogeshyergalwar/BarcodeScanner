import 'package:barcodescanner/ButonofCode/bar_qr_button.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('DECODE APP'),
      ),
      body: const ButtonCode(),
    ),
  ));
}

