# 📱 Android Firebase Configuration Guide

## **Step 1: Create Firebase Project (if not done already)**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or select existing project
3. Enter project name: `sales-bets` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

## **Step 2: Add Android App to Firebase Project**

1. In Firebase Console, click the **Android icon** (`🤖`)
2. **Android package name**: `com.example.sales_bets` (from your build.gradle.kts)
3. **App nickname**: `sales-bets-android`
4. **Debug signing certificate SHA-1** (optional for now):
   ```bash
   # Get your debug SHA-1 fingerprint
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
5. Click "Register app"

## **Step 3: Download google-services.json**

1. **Download** the `google-services.json` file
2. **Place it** in: `android/app/google-services.json`

## **Step 4: Update Android Build Files**

### **4.1 Update Project-level build.gradle.kts**

Add Google Services plugin to `android/build.gradle.kts`:

```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Add this buildscript block
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
```

### **4.2 Update App-level build.gradle.kts**

Update `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Add Google Services plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.sales_bets"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.sales_bets"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    // Add Firebase BOM for version management
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    // Add Firebase services you need
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-messaging")
}
```

## **Step 5: Enable Firebase Services**

### **5.1 Authentication**
1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** provider
3. Click **Save**

### **5.2 Firestore Database**
1. Go to **Firestore Database** → **Create database**
2. Start in **test mode** (for development)
3. Choose location (closest to you)

### **5.3 Cloud Messaging (Optional)**
1. Go to **Cloud Messaging** → **Get started**

## **Step 6: Update firebase_options.dart**

Replace the dummy Android configuration in `lib/core/config/firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_REAL_ANDROID_API_KEY',           // ← From google-services.json
  appId: 'YOUR_REAL_ANDROID_APP_ID',             // ← From google-services.json
  messagingSenderId: 'YOUR_REAL_SENDER_ID',      // ← From google-services.json
  projectId: 'YOUR_REAL_PROJECT_ID',             // ← From google-services.json
  storageBucket: 'YOUR_REAL_PROJECT_ID.appspot.com', // ← From google-services.json
);
```

## **Step 7: Test Configuration**

```bash
# Clean and rebuild
flutter clean
flutter pub get

# Run on Android
flutter run -d android
```

## **Step 8: Get Configuration Values from google-services.json**

Open `android/app/google-services.json` and find these values:

```json
{
  "project_info": {
    "project_id": "your-project-id",           // ← Use this for projectId
    "storage_bucket": "your-project.appspot.com" // ← Use this for storageBucket
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789:android:abcdef123456" // ← Use this for appId
      },
      "api_key": [
        {
          "current_key": "AIzaSyC..." // ← Use this for apiKey
        }
      ]
    }
  ],
  "configuration_version": "1"
}
```

## **🔧 Troubleshooting**

### **Common Issues:**

1. **Build Error**: Make sure `google-services.json` is in `android/app/` directory
2. **Plugin Error**: Ensure Google Services plugin is added to both build.gradle files
3. **API Key Error**: Verify the API key in firebase_options.dart matches google-services.json
4. **Package Name Mismatch**: Ensure package name in Firebase Console matches `applicationId` in build.gradle.kts

### **Verify Setup:**

1. Check that `google-services.json` exists in `android/app/`
2. Verify Google Services plugin is applied
3. Confirm Firebase services are enabled in console
4. Test authentication in your app

## **📱 Next Steps**

After Android setup:
1. Test authentication (login/register)
2. Test Firestore operations
3. Configure push notifications (if needed)
4. Set up release signing for production

Your Android app should now be properly configured for Firebase! 🚀
