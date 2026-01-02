// فایل: android/build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
        // میرورهای کمکی برای سرعت بیشتر و دور زدن تحریم
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
    }
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            
            // تحمیل نسخه 36 به تمام پکیج‌ها (حتی پکیج‌های قدیمی)
            android.compileSdkVersion(36)
            android.ndkVersion = "26.3.11579264"

            android.defaultConfig {
                // حل مشکل ارور 'unknown property flutter' در پکیج‌ها
                targetSdkVersion(36)
                minSdkVersion(21)
            }
        }
    }
}

// ثبت تسک clean برای پاکسازی بیلد
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}