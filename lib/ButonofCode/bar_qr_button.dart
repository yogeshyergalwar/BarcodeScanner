import 'package:barcodescanner/Barcode/barcodehomepage.dart';
import 'package:barcodescanner/HomeWidget/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonCode extends StatefulWidget {
  const ButtonCode({Key? key}) : super(key: key);

  @override
  State<ButtonCode> createState() => _ButtonCodeState();
}

class _ButtonCodeState extends State<ButtonCode> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.qr_code_scanner, //barcode
            //color: Colors.pink,
            size: 45.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Text('Qrcode Scanner'),
          ),
          const SizedBox(height: 10.0),
          const Icon(
            Icons.barcode_reader, //barcode
            //color: Colors.pink,
            size: 45.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarCode(),
                ),
              );
            },
            child: Text('Barcode Scanner'),
          ),
        ],
      ),
    );
  }
}
