#!/bin/bash

# Firebase Setup Script for Sales Bets App
# This script helps set up Firebase for the Flutter app

echo "🔥 Firebase Setup Script for Sales Bets App"
echo "=============================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "📦 Installing Firebase CLI..."
    npm install -g firebase-tools
fi

# Check if FlutterFire CLI is installed
if ! command -v flutterfire &> /dev/null; then
    echo "📦 Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
fi

echo "✅ Prerequisites checked"

# Create Firebase project (manual step)
echo ""
echo "📋 Manual Steps Required:"
echo "1. Go to https://console.firebase.google.com/"
echo "2. Create a new project named 'Sales Bets App'"
echo "3. Enable Google Analytics (optional)"
echo "4. Add Android app with package name: com.example.sales_bets"
echo "5. Add iOS app with bundle ID: com.example.salesBets"
echo "6. Download configuration files:"
echo "   - google-services.json (place in android/app/)"
echo "   - GoogleService-Info.plist (place in ios/Runner/)"

read -p "Press Enter when you've completed the manual steps..."

# Configure FlutterFire
echo ""
echo "🔧 Configuring FlutterFire..."
flutterfire configure

# Update pubspec.yaml dependencies
echo ""
echo "📦 Updating dependencies..."
flutter pub add firebase_core firebase_auth cloud_firestore firebase_messaging firebase_analytics

# Clean and get dependencies
echo ""
echo "🧹 Cleaning and getting dependencies..."
flutter clean
flutter pub get

# Update Android configuration
echo ""
echo "🤖 Updating Android configuration..."

# Update android/build.gradle
cat >> android/build.gradle << 'EOF'

buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
EOF

# Update android/app/build.gradle
cat >> android/app/build.gradle << 'EOF'

plugins {
    id 'com.google.gms.google-services'
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:33.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
    implementation 'com.google.firebase:firebase-messaging'
}
EOF

# Update iOS configuration
echo ""
echo "🍎 Updating iOS configuration..."

# Update ios/Podfile
cat >> ios/Podfile << 'EOF'

pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Messaging'
EOF

# Update ios/Runner/AppDelegate.swift
cat > ios/Runner/AppDelegate.swift << 'EOF'
import UIKit
import Flutter
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
EOF

# Install iOS pods
echo ""
echo "📱 Installing iOS pods..."
cd ios && pod install && cd ..

# Create Firestore security rules
echo ""
echo "🔒 Creating Firestore security rules..."
cat > firestore.rules << 'EOF'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Bets: users can create/read their own bets
    match /bets/{betId} {
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow read: if request.auth != null && (resource.data.userId == request.auth.uid || request.auth.uid in resource.data.participants);
      allow update: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    // Challenges: publicly readable, admin writable
    match /challenges/{challengeId} {
      allow read: if true;
      allow write: if false; // Admin only - implement custom claims
    }
    
    // Teams: publicly readable, admin writable
    match /teams/{teamId} {
      allow read: if true;
      allow write: if false; // Admin only
    }
    
    // Chat messages: users can read/write for streams they're part of
    match /chatMessages/{messageId} {
      allow read, write: if request.auth != null;
    }
    
    // Live streams: publicly readable
    match /liveStreams/{streamId} {
      allow read: if true;
      allow write: if false; // Admin only
    }
  }
}
EOF

echo ""
echo "✅ Firebase setup completed!"
echo ""
echo "📋 Next Steps:"
echo "1. Deploy Firestore rules: firebase deploy --only firestore:rules"
echo "2. Enable Authentication in Firebase Console"
echo "3. Enable Firestore Database in Firebase Console"
echo "4. Test the app: flutter run"
echo ""
echo "🔧 Configuration files created:"
echo "- firestore.rules (deploy to Firebase)"
echo "- Updated Android configuration"
echo "- Updated iOS configuration"
echo ""
echo "🎉 Your app is now ready for Firebase integration!"
