plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flower_app"
    compileSdk = 36 

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.flower_app"
        minSdk = flutter.minSdkVersion 
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
    }
} // این آکولاد برای بستن بخش android بود که جا افتاده بود

dependencies {
    constraints {
        implementation("androidx.annotation:annotation:1.7.0")
        implementation("androidx.annotation:annotation-jvm:1.7.0")
    }
}
