import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'config/theme/theme_constants.dart';
import 'providers/menu_provider.dart';
import 'providers/events_provider.dart';
import 'providers/app_config_provider.dart';
import 'utils/router.dart';
import 'firebase_options.dart';
import 'core/scroll/smooth_scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 ENABLE HISTORY MODE (REMOVE # FROM URL)
  usePathUrlStrategy();

  // Initialize Firebase with proper configuration
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
    
    // 🔥 ENABLE FIRESTORE NETWORK FOR WEB
    // This fixes the "offline" error during development
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false, // Disable offline persistence for web
    );
    
    // Enable network (important for web)
    await FirebaseFirestore.instance.enableNetwork();
    debugPrint('✅ Firestore network enabled');

    // ✅ CHECK RTDB CONNECTIVITY
    FirebaseDatabase.instance.ref('.info/connected').onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        debugPrint('✅ Realtime Database CONNECTED');
      } else {
        debugPrint('⚠️ Realtime Database DISCONNECTED');
      }
    });

  } catch (e) {
    debugPrint('❌ Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Router now handles auth loading state internally via AuthNotifier
    // No FutureBuilder needed - the redirect function returns null while loading
    return MultiProvider(
      providers: [
        // App Config Provider - Pakistan only
        ChangeNotifierProvider(
          create: (_) => AppConfigProvider(),
        ),

        // Menu Provider - Manages menu items
        ChangeNotifierProvider(
          create: (_) => MenuProvider(),
        ),

        // Events Provider - Manages event categories
        ChangeNotifierProvider(
          create: (_) => EventsProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'MAMA EVENTS',
        debugShowCheckedModeBanner: false,
        theme: ThemeConstants.lightTheme,
        routerConfig: AppRouter.router,
        
        // 🚀 HIGH-PERFORMANCE SCROLLING ARCHITECTURE
        scrollBehavior: const HighPerformanceScrollBehavior(),
      ),
    );
  }
}

/// Simple splash screen while loading region preference
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Changed to non-const to allow for onPressed
      backgroundColor: const Color(0xFF0B0B0B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant,
              size: 80,
              color: Color(0xFFC6A869),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Color(0xFFC6A869),
            ),
          ],
        ),
      ),
    );
  }
}
