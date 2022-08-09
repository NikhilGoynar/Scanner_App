import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowQr extends StatefulWidget {
  const ShowQr({Key? key}) : super(key: key);

  @override
  State<ShowQr> createState() => _ShowQrState();
}

class _ShowQrState extends State<ShowQr> {
  final CollectionReference Qrs =
      FirebaseFirestore.instance.collection('Qrcodes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: Qrs.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> Snapshot) {
                if (Snapshot.connectionState == ConnectionState.active) {
                  if (Snapshot.hasData) {
                    return ListView.builder(
                        itemCount: Snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          Map<String, dynamic> userMap = Snapshot.data!.docs[i]
                              .data() as Map<String, dynamic>;

                          return Container(
                            child: Text(userMap['name']),
                          );
                        });
                  } else if (Snapshot.hasError) {}
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              })),
    );
  }
}
