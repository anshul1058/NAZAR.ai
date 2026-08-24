import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ─── Secrets: baca dari local.properties (gitignored) atau env var (CI) ───
// Native butuh SUPABASE_URL + SERVICE_ROLE_KEY untuk insert deteksi & upload
// screenshot. JANGAN hardcode di source. Isi di android/local.properties:
//   SUPABASE_URL=https://xxx.supabase.co
//   SUPABASE_SERVICE_ROLE_KEY=eyJ...
//   AI_SERVER_URL=https://.../predict
val localProps = Properties().apply {
    val f = rootProject.file("local.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
fun secret(key: String, default: String = ""): String =
    (localProps.getProperty(key) ?: System.getenv(key) ?: default)

android {
    namespace = "com.nazar.ai"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.nazar.ai"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Expose secrets ke Kotlin via BuildConfig.*
        buildConfigField("String", "SUPABASE_URL", "\"${secret("SUPABASE_URL")}\"")
        buildConfigField(
            "String",
            "SUPABASE_SERVICE_ROLE_KEY",
            "\"${secret("SUPABASE_SERVICE_ROLE_KEY")}\"",
        )
        buildConfigField(
            "String",
            "AI_SERVER_URL",
            "\"${secret("AI_SERVER_URL", "https://api-judol.habibdev.site/predict")}\"",
        )
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
