import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarCode extends StatefulWidget {
  const BarCode({Key? key}) : super(key: key);

  @override
  State<BarCode> createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  String _scanResult = 'Unknown';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonWidth = screenWidth * 0.7;
    final buttonHeight = screenHeight * 0.1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
            ),
            Row(
              children: const [
                Icon(
                  Icons.add_a_photo,
                  //color: Colors.pink,
                  size: 45.0,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Scan The Code Below:',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(buttonWidth, buttonHeight),
                shadowColor: Colors.black,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: scanBarCodeNormal,
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    const Text(
                      'SCANNER ->',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 25),
                    Container(
                      width: buttonHeight * 0.7,
                      height: buttonHeight * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('Assets/images/download.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: InkWell(
                child: Text(
                  'Scan resuilt:$_scanResult,  ',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
                onTap: () {},
              ),
            ),
            //Text('Scan resuilt:$_scanResult,  ',style: TextStyle(fontSize:18.0,fontWeight: FontWeight.bold,color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<void> scanBarCodeNormal() async {
    String barCodeScan;
    try {
      barCodeScan = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", 'Cancel', true, ScanMode.BARCODE);
      debugPrint(barCodeScan);
    } on PlatformException {
      barCodeScan = 'Failed to get barcode version';
    }

    if (!mounted) return;
    setState(() {
      _scanResult = barCodeScan;
    });
  }
}
