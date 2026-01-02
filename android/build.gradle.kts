// فایل اصلاح شده: android/build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
        // میرورهای کمکی برای سرعت بیشتر
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
    }
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            
            // کاهش نسخه به 34 برای پایداری بیشتر و حل تداخل با کاتلین
            android.compileSdkVersion(34)
            
            android.defaultConfig {
                targetSdkVersion(34)
                minSdkVersion(23)
            }

            // اضافه کردن این بخش برای حل ارور Unresolved reference در کاتلین
            android.compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}