# Firebase Setup Guide for Sales Bets

This guide outlines the steps to configure Firebase for real-time updates and notifications in the Sales Bets app.

## Prerequisites

- Flutter SDK installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- Google account for Firebase Console access

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `sales-bets-app`
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Add Firebase to Flutter App

### For Android:

1. In Firebase Console, click "Add app" and select Android
2. Enter package name: `com.example.sales_bets`
3. Download `google-services.json`
4. Place it in `android/app/` directory
5. Add to `android/build.gradle`:
   ```gradle
   buildscript {
     dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
     }
   }
   ```
6. Add to `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

### For iOS:

1. In Firebase Console, click "Add app" and select iOS
2. Enter bundle ID: `com.example.salesBets`
3. Download `GoogleService-Info.plist`
4. Add it to `ios/Runner/` in Xcode
5. Add to `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLName</key>
       <string>REVERSED_CLIENT_ID</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```

## Step 3: Enable Firebase Services

### Firestore Database:
1. Go to Firestore Database in Firebase Console
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location close to your users

### Authentication:
1. Go to Authentication in Firebase Console
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" provider

### Cloud Messaging:
1. Go to Cloud Messaging in Firebase Console
2. No additional setup required for basic functionality

## Step 4: Firestore Security Rules

Add these rules to `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Bets are readable by all authenticated users, writable by owner
    match /bets/{betId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    // Challenges are readable by all authenticated users
    match /challenges/{challengeId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Admin only in production
    }
    
    // Teams are readable by all authenticated users
    match /teams/{teamId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Admin only in production
    }
    
    // Chat messages are readable by all authenticated users
    match /chat_messages/{messageId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Streams are readable by all authenticated users
    match /streams/{streamId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Admin only in production
    }
  }
}
```

## Step 5: Deploy Firestore Rules

```bash
firebase deploy --only firestore:rules
```

## Step 6: Test Real-time Features

The app includes the following real-time features:

### Real-time Betting Results:
- Bet status updates are synchronized across all clients
- Win/loss notifications are pushed in real-time
- Wallet updates are reflected immediately

### Real-time Chat:
- Chat messages appear instantly for all stream viewers
- Message history is preserved and synchronized
- User presence and typing indicators (future enhancement)

### Real-time Notifications:
- Push notifications for bet results
- Team activity notifications
- Challenge completion alerts

## Step 7: Production Considerations

### Security:
- Update Firestore rules for production
- Implement proper user roles and permissions
- Add data validation and sanitization

### Performance:
- Implement pagination for large datasets
- Use Firestore offline persistence
- Optimize queries with proper indexing

### Monitoring:
- Set up Firebase Analytics
- Monitor Firestore usage and costs
- Implement error tracking with Crashlytics

## Troubleshooting

### Common Issues:

1. **Firebase not initialized**: Ensure `FirebaseConfig.initialize()` is called in `main()`
2. **Permission denied**: Check Firestore security rules
3. **Network errors**: Verify internet connection and Firebase project configuration
4. **Authentication issues**: Ensure Firebase Auth is properly configured

### Debug Mode:
Enable debug logging by adding to `main.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable debug mode
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  await FirebaseConfig.initialize();
  runApp(const SalesBetsApp());
}
```

## Next Steps

1. **Authentication Integration**: Replace mock authentication with Firebase Auth
2. **Data Migration**: Move mock data to Firestore collections
3. **Push Notifications**: Implement FCM for real-time notifications
4. **Offline Support**: Add offline data persistence
5. **Analytics**: Integrate Firebase Analytics for user behavior tracking

## Support

For Firebase-related issues:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Support](https://firebase.google.com/support)
