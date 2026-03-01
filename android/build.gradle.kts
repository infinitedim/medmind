allprojects {
    repositories {
        google()
        mavenCentral()
        jcenter() // required for isar_flutter_libs which uses AGP 4.1.0
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

subprojects {
    plugins.withId("com.android.library") {
        try {
            extensions.configure<com.android.build.gradle.LibraryExtension> {
                if (namespace == null) {
                    namespace = group.toString()
                }
            }
        } catch (_: Throwable) {
            // Older AGP versions (e.g. isar_flutter_libs uses 4.1.0) may not support namespace
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
