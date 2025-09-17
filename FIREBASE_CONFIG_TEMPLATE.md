# Firebase Configuration Template

## 🔑 **Replace the dummy values in `lib/core/config/firebase_options.dart` with your real Firebase configuration:**

### **Step 1: Get Your Firebase Configuration**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click the **Web icon** (`</>`) to add a web app
4. Copy the configuration values

### **Step 2: Update firebase_options.dart**

Replace the dummy values in `lib/core/config/firebase_options.dart` with your real values:

```dart
// Replace these dummy values with your real Firebase configuration:

static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_REAL_API_KEY_HERE',                    // ← Replace this
  appId: 'YOUR_REAL_APP_ID_HERE',                      // ← Replace this
  messagingSenderId: 'YOUR_REAL_SENDER_ID_HERE',       // ← Replace this
  projectId: 'YOUR_REAL_PROJECT_ID_HERE',              // ← Replace this
  authDomain: 'YOUR_REAL_PROJECT_ID.firebaseapp.com',  // ← Replace this
  storageBucket: 'YOUR_REAL_PROJECT_ID.appspot.com',   // ← Replace this
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_REAL_API_KEY_HERE',                    // ← Replace this
  appId: 'YOUR_REAL_ANDROID_APP_ID_HERE',              // ← Replace this
  messagingSenderId: 'YOUR_REAL_SENDER_ID_HERE',       // ← Replace this
  projectId: 'YOUR_REAL_PROJECT_ID_HERE',              // ← Replace this
  storageBucket: 'YOUR_REAL_PROJECT_ID.appspot.com',   // ← Replace this
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_REAL_API_KEY_HERE',                    // ← Replace this
  appId: 'YOUR_REAL_IOS_APP_ID_HERE',                  // ← Replace this
  messagingSenderId: 'YOUR_REAL_SENDER_ID_HERE',       // ← Replace this
  projectId: 'YOUR_REAL_PROJECT_ID_HERE',              // ← Replace this
  storageBucket: 'YOUR_REAL_PROJECT_ID.appspot.com',   // ← Replace this
  iosBundleId: 'com.example.salesBets',                // ← Keep this or change to your bundle ID
);

static const FirebaseOptions macos = FirebaseOptions(
  apiKey: 'YOUR_REAL_API_KEY_HERE',                    // ← Replace this
  appId: 'YOUR_REAL_MACOS_APP_ID_HERE',                // ← Replace this
  messagingSenderId: 'YOUR_REAL_SENDER_ID_HERE',       // ← Replace this
  projectId: 'YOUR_REAL_PROJECT_ID_HERE',              // ← Replace this
  storageBucket: 'YOUR_REAL_PROJECT_ID.appspot.com',   // ← Replace this
  iosBundleId: 'com.example.salesBets',                // ← Keep this or change to your bundle ID
);
```

### **Step 3: Example with Real Values**

Here's what it should look like with real values:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyC1234567890abcdefghijklmnopqrstuvwxyz',
  appId: '1:123456789012:web:abcdef1234567890abcdef',
  messagingSenderId: '123456789012',
  projectId: 'my-sales-bets-project',
  authDomain: 'my-sales-bets-project.firebaseapp.com',
  storageBucket: 'my-sales-bets-project.appspot.com',
);
```

### **Step 4: Enable Authentication**

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** provider
3. Click **Save**

### **Step 5: Test Your Configuration**

After updating the configuration, run:
```bash
flutter clean
flutter pub get
flutter run
```

## 🚨 **Important Security Notes:**

- **Never commit real API keys to public repositories**
- **Use environment variables for production**
- **The web API key is safe to expose in client-side code**
- **For production, consider using Firebase App Check for additional security**

## 📱 **For Mobile Apps (Android/iOS):**

If you want to add mobile support later:

1. **Android**: Add your app in Firebase Console → Project Settings → Your apps → Add app → Android
2. **iOS**: Add your app in Firebase Console → Project Settings → Your apps → Add app → iOS

You'll get separate configuration files for each platform.
