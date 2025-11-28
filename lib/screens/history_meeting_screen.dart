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

        return ListView.builder(
          itemCount: (snapshot.data! as dynamic).docs.length,
          itemBuilder: (context, index) {
            var snap = (snapshot.data! as dynamic).docs[index].data();
            var date = (snap['createdAt'] as Timestamp).toDate();
            var formattedDate = DateFormat.yMMMd().format(date);
            var formattedTime = DateFormat.Hm().format(date);

            return ListTile(
              title: Text(
                'Room Name: ${snap['meetingName']}',
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