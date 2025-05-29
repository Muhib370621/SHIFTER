plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // ✅ Add this line for Firebase
//    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.shifter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.shifter"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ✅ Add this if you're using Firebase and your app has many dependencies
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // ✅ Required for Firebase with minSdk < 26
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")

    // ✅ Optional: if using multidex (recommended for Firebase)
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
