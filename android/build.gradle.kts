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
    // plugins.withId fires at plugin-application time (before project evaluation
    // completes), so it is safe with Gradle 8+ and AGP 8+.
    // This forces compileSdk >= 31 on all library subprojects so that resources
    // referencing android:attr/lStar (introduced in API 31) compile correctly.
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            compileSdk = 34
            if (namespace == null) {
                namespace = group.toString()
            }
        }
    }
}

tasks.register<Delete>("clean") { delete(rootProject.layout.buildDirectory) }
