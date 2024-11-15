import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailDashboard extends StatelessWidget {
  const DetailDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    
    Future<void> _fetchDataFromFirebase() async{
      DocumentSnapshot snapshot  = await FirebaseFirestore.instance
          .collection("podomoroapp")
          .doc("5Z1axeBfpxb2CzviJYlu")
          .get();
    }
    return const Placeholder();
  }
}
