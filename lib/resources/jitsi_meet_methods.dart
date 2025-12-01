import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JitsiMeetMethods {
  final JitsiMeet _jitsiMeet = JitsiMeet();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      String name;
      if (username.isEmpty) {
        name = _auth.currentUser?.displayName ?? 'User';
      } else {
        name = username;
      }
      
      var options = JitsiMeetConferenceOptions(
        serverURL: "https://meet.jit.si",
        room: roomName,
        configOverrides: {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
          "startScreenSharing": false,
          "enableEmailInStats": false,
        },
        featureFlags: {
          "unsaferoomwarning.enabled": false,
          "resolution": 720,
        },
        userInfo: JitsiMeetUserInfo(
          displayName: name,
          email: _auth.currentUser?.email ?? '',
        ),
      );

      await _addMeetingToHistory(roomName);
      await _jitsiMeet.join(options);
    } catch (error) {
      debugPrint("Jitsi Meet error: $error");
    }
  }

  Future<void> _addMeetingToHistory(String roomName) async {
    try {
      if (_auth.currentUser != null) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('meetings')
            .add({
          'meetingName': roomName,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint("Error adding meeting to history: $e");
    }
  }
}