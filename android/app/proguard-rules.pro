# Flutter: Avoid R8 crashing on Android 14+ API calls
-keep class io.flutter.embedding.android.FlutterActivity { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.plugin.** { *; }

# Prevent R8 from removing or optimizing android.window.BackEvent
-keep class android.window.BackEvent { *; }
-dontwarn android.window.BackEvent
-assumenosideeffects class android.window.BackEvent { *; }

# In case you are using WebView or Razorpay
-keep class com.razorpay.** { *; }
-keepclassmembers class com.razorpay.** { *; }

# Optional: suppress other known warnings
-dontwarn androidx.webkit.**
-dontwarn android.net.http.**