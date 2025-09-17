#!/bin/bash

echo "🔑 Getting Android Debug SHA-1 Fingerprint..."
echo ""

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo "❌ keytool not found. Make sure Java JDK is installed and in your PATH."
    echo "   You can install it with: brew install openjdk"
    exit 1
fi

# Get the SHA-1 fingerprint
echo "📱 Debug keystore SHA-1 fingerprint:"
echo ""

keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1

echo ""
echo "✅ Copy the SHA-1 fingerprint above and add it to your Firebase project:"
echo "   1. Go to Firebase Console → Project Settings → Your apps"
echo "   2. Select your Android app"
echo "   3. Add this SHA-1 fingerprint to 'SHA certificate fingerprints'"
echo ""
echo "🔧 If you get 'keystore not found' error, run:"
echo "   flutter build apk --debug"
echo "   (This will create the debug keystore)"
