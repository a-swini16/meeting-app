import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JitsiMeetMethods {
  final JitsiMeet _jitsiMeet = JitsiMeet();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new meeting with minimal configuration
  void createNewMeeting({
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
      
      debugPrint("Creating meeting with room: $roomName, user: $name");
      
      // Minimal configuration to avoid lobby and authentication issues
      var options = JitsiMeetConferenceOptions(
        serverURL: "https://meet.jit.si",
        room: roomName,
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
          "requireDisplayName": false,
          "enableWelcomePage": false,
          "enableClosePage": false,
          "disableDeepLinking": true,
          "enableNoAudioDetection": false,
          "enableNoisyMicDetection": false,
          "enableTalkWhileMutedDetection": false,
          "disableModeratorIndicator": true,
          "startSilent": false,
          "enableLayerSuspension": false,
          "channelLastN": -1,
          "enableUserRolesBasedOnToken": false,
          "enableFeaturesBasedOnToken": false,
          "doNotStoreRoom": true,
          "disableAddingBackgroundImages": true,
          "disableVirtualBackground": true,
          "backgroundAlpha": 0.5,
        },
        featureFlags: {
          "unsaferoomwarning.enabled": false,
          "resolution": 720,
          "chat.enabled": true,
          "calendar.enabled": false,
          "call-integration.enabled": false,
          "close-captions.enabled": false,
          "invite.enabled": true,
          "android.screensharing.enabled": true,
          "add-people.enabled": false,
          "pip.enabled": true,
          "welcomepage.enabled": false,
          "prejoinpage.enabled": false,
          "lobby-mode.enabled": false,
          "recording.enabled": false,
          "live-streaming.enabled": false,
          "raise-hand.enabled": true,
          "security-options.enabled": false,
          "server-url-change.enabled": false,
          "tile-view.enabled": true,
          "toolbox.alwaysVisible": false,
          "video-share.enabled": false,
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