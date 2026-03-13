allprojects {
    repositories {
        google()
        mavenCentral()
        jcenter() // required for isar_flutter_libs which uses AGP 4.1.0
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects { project.evaluationDependsOn(":app") }

subprojects {
    afterEvaluate {
        // Force compileSdk >= 31 on ALL library subprojects so that resources
        // referencing android:attr/lStar (introduced in API 31 / Android 12)
        // compile successfully.  This is required for isar_flutter_libs which
        // ships with AGP 4.1.0 and ignores plugins.withId() hooks.
        if (plugins.hasPlugin("com.android.library")) {
            extensions.configure<com.android.build.gradle.LibraryExtension> {
                compileSdk = 34
                if (namespace == null) {
                    namespace = group.toString()
                }
            }
        }
    }
}

tasks.register<Delete>("clean") { delete(rootProject.layout.buildDirectory) }
