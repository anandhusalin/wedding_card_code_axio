plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.weddingcards.wedding_cards"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.weddingcards.wedding_cards"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // ─── Product flavors: dev / prod ───────────────────────────────
    // Dev uses a .dev applicationId suffix and a different app name so
    // it can coexist on the same device with the production build.
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            // Dev builds default to the local backend (10.0.2.2:3000 is
            // the Android emulator alias for the host machine's localhost).
            // Override at run time with: --dart-define=API_BASE_URL=...
            resValue("string", "default_api_base_url", "http://10.0.2.2:3000")
        }
        create("prod") {
            dimension = "env"
            // Production keeps the default applicationId and points at
            // the deployed Railway API by default.
            resValue(
                "string",
                "default_api_base_url",
                "https://wedding-cards-api-production.up.railway.app"
            )
        }
    }
}

flutter {
    source = "../.."
}
