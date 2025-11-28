# Flutter Zoom Clone

A comprehensive video calling application built with Flutter and Firebase, similar to Zoom. This app allows users to create and join video meetings with real-time communication features.

## Features

- **User Authentication**: Email/password and Google Sign-in
- **Video Calling**: Create and join video meetings using Jitsi Meet
- **Meeting History**: Track previous meetings
- **Real-time Communication**: Audio and video controls
- **Cross-platform**: Works on Android, iOS, and Web
- **Firebase Integration**: User management and meeting history storage

## Screenshots

[Add screenshots of your app here]

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Firebase project setup
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd flutter-zoom-clone
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google Sign-in)
   - Enable Firestore Database
   - Download and replace the configuration files:
     - `android/app/google-services.json` (Android)
     - `ios/Runner/GoogleService-Info.plist` (iOS)
     - Update `lib/firebase_options.dart` with your config

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── login.dart               # Login screen
├── signup.dart              # Signup screen
├── resources/
│   ├── auth_methods.dart    # Authentication logic
│   └── jitsi_meet_methods.dart # Video calling logic
├── screens/
│   ├── auth_wrapper.dart    # Authentication state management
│   ├── home_screen.dart     # Main navigation
│   ├── meeting_screen.dart  # Meeting controls
│   ├── video_call_screen.dart # Join meeting screen
│   └── history_meeting_screen.dart # Meeting history
├── widgets/
│   ├── custom_button.dart   # Reusable button component
│   ├── meeting_option.dart  # Meeting settings toggle
│   └── home_meeting_button.dart # Home screen buttons
└── utils/
    ├── colors.dart          # App color scheme
    └── utils.dart           # Utility functions
```

## Key Dependencies

- `firebase_core` & `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `jitsi_meet_flutter_sdk` - Video calling
- `google_sign_in` - Google authentication
- `permission_handler` - Device permissions

## Configuration

### Android Permissions

The app requires the following permissions (already configured in `android/app/src/main/AndroidManifest.xml`):

- Camera access
- Microphone access
- Internet access
- Network state access
- Audio settings modification

### Firebase Rules

Set up Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /meetings/{meetingId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

## Usage

1. **Sign Up/Login**: Create an account or sign in with existing credentials
2. **Create Meeting**: Tap "New Meeting" to start an instant meeting
3. **Join Meeting**: Enter a meeting ID to join an existing meeting
4. **Meeting Controls**: Toggle audio/video before joining
5. **History**: View your meeting history in the "Meetings" tab

## Features in Detail

### Authentication
- Email/password registration and login
- Google Sign-in integration
- Automatic user profile creation in Firestore

### Video Calling
- Powered by Jitsi Meet for reliable video communication
- Audio/video mute controls
- Random meeting ID generation
- Custom meeting room names

### Meeting Management
- Meeting history tracking
- Timestamp recording
- User-specific meeting lists

## Customization

### Colors
Modify `lib/utils/colors.dart` to change the app's color scheme:

```dart
const backgroundColor = Color.fromRGBO(19, 28, 33, 1);
const buttonColor = Color.fromRGBO(31, 44, 52, 1);
// Add your custom colors
```

### Branding
- Update app name in `pubspec.yaml`
- Replace app icons in `android/app/src/main/res/` and `ios/Runner/Assets.xcassets/`
- Modify the login screen title and branding

## Troubleshooting

### Common Issues

1. **Firebase Configuration Error**
   - Ensure `google-services.json` is in the correct location
   - Verify Firebase project settings match your app

2. **Permission Denied**
   - Check Android permissions in manifest
   - Test on physical device for camera/microphone access

3. **Build Errors**
   - Run `flutter clean && flutter pub get`
   - Check Flutter and Dart SDK versions

### Debug Mode

Run with verbose logging:
```bash
flutter run --verbose
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Jitsi Meet](https://jitsi.org/) for video calling infrastructure
- [Firebase](https://firebase.google.com/) for backend services
- [Flutter](https://flutter.dev/) for the amazing framework

## Support

If you encounter any issues or have questions:

1. Check the [Issues](../../issues) section
2. Create a new issue with detailed information
3. Include device information and error logs

---

**Note**: This is a demo application. For production use, implement additional security measures, error handling, and testing.