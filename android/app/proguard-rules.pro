# Keep all classes for Jitsi Meet
-keep class org.jitsi.** { *; }
-keep class com.facebook.react.** { *; }
-keep class com.facebook.imagepipeline.** { *; }
-keep class com.giphy.** { *; }

# Keep WebRTC classes
-keep class org.webrtc.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Kotlin Parcelize
-keep class kotlinx.parcelize.** { *; }

# Keep React Native classes
-keep class com.facebook.react.bridge.** { *; }
-keep class com.facebook.react.uimanager.** { *; }

# Disable obfuscation for debugging
-dontobfuscate

# Keep line numbers for debugging
-keepattributes SourceFile,LineNumberTable