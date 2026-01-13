
allprojects {
    repositories {
        maven(url = "https://developer.huawei.com/repo/")
        google()
        mavenCentral()
    }
}

buildscript {
    repositories {
        maven(url = "https://developer.huawei.com/repo/")
        
        
        
        
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    dependencies {
        classpath("com.huawei.agconnect:agcp:1.9.1.303")
                                        classpath("com.android.tools.build:gradle:8.11.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.2.20")
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}









// Fix for Huawei Ads AIDL compilation per hms-flutter-plugin/#396
subprojects {
    if (project.name == "huawei_ads" || project.group.toString() == "com.huawei.hms.flutter.ads") {
        val configureAidl = {
            val android = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
            android?.buildFeatures?.aidl = true
        }
        if (project.state.executed) {
            configureAidl()
        } else {
            project.afterEvaluate { configureAidl() }
        }
    }
}
