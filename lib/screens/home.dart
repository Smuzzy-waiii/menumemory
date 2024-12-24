import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:menumemory/models/visit.dart';
import 'package:menumemory/widgets/visit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  late Query<Map<String, dynamic>> visitsQuery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visitsQuery = FirebaseFirestore.instance.collection('users/${user.uid}/visits').orderBy('datetime', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MenuMemory"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FirestoreListView<Map<String, dynamic>>(
          query: visitsQuery,
          itemBuilder: (context, snapshot) {
            Map<String, dynamic> visitSnapshot = snapshot.data();
            Visit visit = Visit.fromJson(visitSnapshot);

            return VisitCard(visit: visit);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add Visit"),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addvisit');
        },
      )
    );
  }
}
