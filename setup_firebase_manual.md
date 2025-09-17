# 🔥 Firebase Manual Setup Guide

## **Quick Setup Steps:**

### **1. Create Firebase Project**
- Go to: https://console.firebase.google.com/
- Click "Create a project"
- Name: `sales-bets` (or your preferred name)
- Enable Google Analytics: Optional
- Click "Create project"

### **2. Add Web App**
- In Firebase Console, click the **Web icon** (`</>`)
- App nickname: `sales-bets-web`
- **Copy the config object** (you'll need these values)

### **3. Enable Authentication**
- Go to **Authentication** → **Sign-in method**
- Click **Email/Password** → **Enable** → **Save**

### **4. Enable Firestore**
- Go to **Firestore Database** → **Create database**
- Start in **test mode** (for development)
- Choose location (closest to you)

### **5. Update Your App**
Replace the dummy values in `lib/core/config/firebase_options.dart` with your real Firebase config.

### **6. Test**
```bash
flutter clean
flutter pub get
flutter run
```

## **Your Firebase Config Will Look Like:**
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyC...", // ← Copy this
  authDomain: "your-project.firebaseapp.com", // ← Copy this
  projectId: "your-project-id", // ← Copy this
  storageBucket: "your-project.appspot.com", // ← Copy this
  messagingSenderId: "123456789", // ← Copy this
  appId: "1:123456789:web:abcdef123456" // ← Copy this
};
```

## **Replace in firebase_options.dart:**
- `apiKey` → Your real API key
- `projectId` → Your real project ID
- `authDomain` → Your real auth domain
- `storageBucket` → Your real storage bucket
- `messagingSenderId` → Your real sender ID
- `appId` → Your real app ID

That's it! Your authentication should work after this.
