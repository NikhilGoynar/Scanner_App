import 'package:barcode_scan/model/scan_result.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scanner_app/show_qrs.dart';

class Myhome extends StatefulWidget {
  const Myhome({Key? key}) : super(key: key);

  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  updateData(String id) async {
    String obj = DateTime.now().toString();
    await FirebaseFirestore.instance.collection("Qrcodes").doc('$id').update({
      "DateTime": FieldValue.arrayUnion([obj])
    });
  }

  addData(String id) async {
    String obj = DateTime.now().toString();
    await FirebaseFirestore.instance.collection('Qrcodes').add({
      'name': '$id',
      'DateTime': [obj]
    });
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef =
          FirebaseFirestore.instance.collection('collectionName');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future _scanQr() async {
    try {
      ScanResult qrResult = await BarcodeScanner.scan();
      String a = qrResult.toString();

      bool temp = await checkIfDocExists(a);
      if (temp) {
        await updateData(a);
      } else {
        addData(a);
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Qr Scanner")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => ShowQr())));
          },
          child: const Text('Disabled'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _scanQr();
        },
        label: Text("Scan"),
        icon: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
