import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryMeetingScreen extends StatelessWidget {
  const HistoryMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('meetings')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading meeting history'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No meetings found'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var snap = snapshot.data!.docs[index].data();
            var date = snap['createdAt'] != null 
                ? (snap['createdAt'] as Timestamp).toDate()
                : DateTime.now();
            var formattedDate = DateFormat.yMMMd().format(date);
            var formattedTime = DateFormat.Hm().format(date);

            return ListTile(
              title: Text(
                'Room Name: ${snap['meetingName'] ?? 'Unknown'}',
              ),
              subtitle: Text(
                'Joined on $formattedDate at $formattedTime',
              ),
            );
          },
        );
      },
    );
  }
}