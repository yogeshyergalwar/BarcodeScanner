import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  //final Uri _url=Uri.parse('result!.code!');

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      if (await Permission.camera.request().isGranted) {
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Camera permission is required to scan QR codes.')),
        );
      }
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Column(
                      children: [
                        Padding(padding: EdgeInsets.all(10.0)),
                        Text(
                          'Barcode Type: ${describeEnum(result!.format)}',
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Open Link: ${result!.code}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    )
                  : Text('Scan a code'),
            ),
          ),
          //Below Commented Code FOR click to lanch operation by inkwell
          // flex: 1,
          // child: Center(
          //   child: (result != null)
          //       ? InkWell(
          //     child: Column(
          //         children: [Padding(padding: EdgeInsets.all(10.0),),
          //           Text(
          //             'Barcode Type: ${describeEnum(result!.format)}   ',
          //
          //             style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
          //           ),
          //           SizedBox(height: 15.0),
          //           Text('Open Link: ${result!.code}' ,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueAccent,),)
          //           //TextButton(onPressed:(){}, child: Text('open link'))
          //         ]
          //     ),
          //
          //     onTap: () async {
          //       final url = result!.code!;
          //       //final Uri _url=Uri.parse('result!.code!');
          //
          //       if (await canLaunch(url)) {
          //         await launch(url );
          //       }else {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('Could not launch ${result!.code}')),
          //         );
          //       }
          //     },
          //
          //   )
          //       : Text('Scan a code'),
          // ),
        ],
      ),
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //     });
  //   });
  // }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      _launchURL(result!.code); //this function call or lanch qr automatically
    });
  }

  Future<void> _launchURL(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }


  // Future<void> _launchURL(BuildContext context, String? url) async {
  //   if (url != null) {
  //     // Check if the URL can be launched
  //     if (await canLaunch(url)) {
  //       await launch(url);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Could not launch $url')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Invalid URL')),
  //     );
  //   }
  // }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
/*
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRViewExample(),
    );
  }
}

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool flashOn = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      if (await Permission.camera.request().isGranted) {
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera permission is required to scan QR codes.'),
          ),
        );
      }
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            child: IconButton(
              icon: Icon(
                flashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {
                  flashOn = !flashOn;
                });
              },
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: IconButton(
              icon: Icon(
                Icons.photo,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                _scanFromGallery();
              },
            ),
          ),
          if (result != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white.withOpacity(0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Barcode Type: ${describeEnum(result!.format)}',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Open Link: ${result!.code}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      var url = scanData.code;
      print('Scanned URL: $url'); // Log the scanned URL

      if (url != null) {
        try {
          if (url.startsWith('upi://')) {
            // Ensure the UPI URL is correctly formatted and encoded
            final encodedUrl = Uri.encodeFull(url);
            print('Encoded URL: $encodedUrl');
            if (await canLaunch(encodedUrl)) {
              await launch(encodedUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No app found to handle UPI URL: $url')),
              );
            }
          } else if (url.startsWith('http://') || url.startsWith('https://')) {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not launch URL: $url')),
              );
            }
          } else {
            // Handle other types of URLs or invalid codes
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unsupported URL or invalid QR code: $url')),
            );
          }
        } catch (e) {
          print('Error launching URL: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error launching URL: $url')),
          );
        }
      }
    });
  }

  Future<void> _scanFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      try {
        final qrCodeData = await QrCodeToolsPlugin.decodeFrom(imageFile.path);
        if (qrCodeData != null) {
          var url = qrCodeData;
          print('Scanned URL from gallery: $url'); // Log the scanned URL from the gallery

          if (url != null) {
            try {
              if (url.startsWith('upi://')) {
                // Ensure the UPI URL is correctly formatted and encoded
                final encodedUrl = Uri.encodeFull(url);
                print('Encoded URL: $encodedUrl');
                if (await canLaunch(encodedUrl)) {
                  await launch(encodedUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No app found to handle UPI URL: $url')),
                  );
                }
              } else if (url.startsWith('http://') || url.startsWith('https://')) {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch URL: $url')),
                  );
                }
              } else {
                // Handle other types of URLs or invalid codes
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unsupported URL or invalid QR code: $url')),
                );
              }
            } catch (e) {
              print('Error launching URL: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error launching URL: $url')),
              );
            }
          }
        }
      } catch (e) {
        print('Error scanning QR code from gallery: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning QR code from gallery: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

*/
