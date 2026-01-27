import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/home_screen.dart';
import '../screens/gallery_screen.dart';
import '../screens/contact_screen_enhanced.dart';
import '../screens/services_screen.dart';
import '../screens/about_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/terms_of_service_screen.dart';
import '../admin/screens/enhanced_admin_dashboard.dart';
import '../admin/screens/events/admin_events_screen.dart';
import '../admin/screens/events/admin_sub_categories_screen.dart';
import '../admin/screens/events/admin_packages_list_screen.dart';
import '../admin/screens/events/admin_packages_list_screen.dart';
import '../admin/screens/events/admin_package_editor_screen.dart';
import '../screens/event_packages_screen.dart';
import '../screens/event_details_screen.dart';
import '../screens/quote_management_dashboard.dart';
import '../screens/admin_login_screen.dart';
import '../screens/customer_menu_screen.dart';
import '../admin/screens/activity_log_screen.dart';

// Admin Screens
import '../features/admin/layout/admin_shell_layout.dart' as new_admin;
import '../features/admin/screens/content/edit_menu_screen.dart';
import '../features/admin/screens/orders/booking_dashboard_screen.dart';

/// Auth state notifier that tracks loading state
/// CRITICAL: isLoading starts as TRUE and becomes FALSE only after first auth emission
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    // Start listening to auth state changes
    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      
      // CRITICAL: Only set isLoading to false AFTER first emission
      if (_isLoading) {
        _isLoading = false;
        debugPrint('🔐 Auth initialized: user=${user?.email ?? "null"}');
        
        // 🔥 BACKGROUND ANONYMOUS SIGN-IN for public visibility if not logged in
        // This ensures public forms (Quotes) have write permission without forcing a UI login
        if (user == null) {
          debugPrint('👤 No user detected - signing in anonymously for background session...');
          FirebaseAuth.instance.signInAnonymously()
              .then((_) => debugPrint('✅ Anonymous sign-in successful'))
              .catchError((e) {
            debugPrint('⚠️ Anonymous sign-in failed: $e');
            // Informative note: This usually means Anonymous Auth is disabled in Firebase Console
            return null; // Return null to match Future<UserCredential?>
          });
        }
      }
      
      notifyListeners();
    });
  }

  User? _user;
  bool _isLoading = true; // ✅ STARTS AS TRUE
  late final StreamSubscription<User?> _subscription;

  /// Current user (null if not logged in OR still loading)
  User? get user => _user;
  
  /// TRUE while waiting for Firebase to restore auth state
  bool get isLoading => _isLoading;
  
  /// TRUE if auth has been checked AND user is logged in
  bool get isAuthenticated => !_isLoading && _user != null;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  // Singleton auth notifier
  static final AuthNotifier _authNotifier = AuthNotifier();
  
  static GoRouter? _router;
  
  /// Get or create the router instance
  static GoRouter get router {
    _router ??= _createRouter();
    return _router!;
  }
  
  /// Create the router with proper auth-aware redirect
  static GoRouter _createRouter() {
    return GoRouter(
      // Force start at browser URL to avoid routing issues on refresh
      initialLocation: _getInitialLocation(),
      
      // ✅ CRITICAL: refreshListenable uses our AuthNotifier
      refreshListenable: _authNotifier,
      
      redirect: (context, state) {
        final isLoading = _authNotifier.isLoading;
        final user = _authNotifier.user;
        final isLoggingIn = state.matchedLocation == '/admin/login';
        final isAdmin = state.matchedLocation.startsWith('/admin');

        // ✅ CRITICAL FIX: If auth is still loading, DO NOTHING
        // Return null to stay on current URL while Firebase initializes
        if (isLoading) {
          debugPrint('⏳ Auth loading - staying on ${state.matchedLocation}');
          return null; // DO NOT REDIRECT
        }

        // Auth is ready - now apply redirect logic
        debugPrint('🔐 Auth ready: user=${user?.email ?? "null"}, path=${state.matchedLocation}');

        // If trying to access admin without login, redirect to login
        if (isAdmin && !isLoggingIn && user == null) {
          debugPrint('🚫 Not authenticated - redirecting to /admin/login');
          return '/admin/login';
        }

        // If logged in and on login page, redirect to admin
        if (isLoggingIn && user != null) {
          debugPrint('✅ Already authenticated - redirecting to /admin');
          return '/admin';
        }

        return null; // No redirect needed
      },
      
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/our-menu',
          builder: (context, state) => const CustomerMenuScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesScreen(),
        ),
        GoRoute(
          path: '/gallery',
          builder: (context, state) => const GalleryScreen(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactScreenEnhanced(),
        ),
        GoRoute(
          path: '/privacy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: '/terms',
          builder: (context, state) => const TermsOfServiceScreen(),
        ),
        
        // Customer Package Routes
        GoRoute(
          path: '/event-packages',
          builder: (context, state) => const EventPackagesScreen(),
          routes: [
            GoRoute(
               path: ':eventId',
               builder: (context, state) => EventDetailsScreen(eventId: state.pathParameters['eventId']!),
            ),
          ],
        ),

        GoRoute(
          path: '/admin/login',
          builder: (context, state) => const AdminLoginScreen(),
        ),
        
        // 🛡️ ADMIN SHELL ROUTE
        ShellRoute(
          builder: (context, state, child) {
            return new_admin.AdminShellLayout(child: child); 
          },
          routes: [
            // Admin Routes
            GoRoute(
              path: '/admin',
              builder: (context, state) => const _AdminAuthWrapper(child: EnhancedAdminDashboard()),
              routes: [
                GoRoute(
                  path: 'quotes',
                  builder: (context, state) => const _AdminAuthWrapper(child: QuoteManagementDashboard()),
                ),
                GoRoute(
                  path: 'events',
                  builder: (context, state) => const _AdminAuthWrapper(child: AdminEventsScreen()),
                  routes: [
                    GoRoute(
                      path: ':eventId/sub-events',
                      builder: (context, state) => _AdminAuthWrapper(
                        child: AdminSubCategoriesScreen(eventId: state.pathParameters['eventId']!),
                      ),
                      routes: [
                        GoRoute(
                           path: ':subId/packages',
                           builder: (context, state) => _AdminAuthWrapper(
                              child: AdminPackagesListScreen(
                                eventId: state.pathParameters['eventId']!,
                                subId: state.pathParameters['subId']!,
                              ),
                           ),
                           routes: [
                              GoRoute(
                                path: 'edit/:packageId', // /admin/events/:eventId/sub-events/:subId/packages/edit/:packageId
                                builder: (context, state) => _AdminAuthWrapper(
                                   child: AdminPackageEditorScreen(
                                     eventId: state.pathParameters['eventId']!,
                                     subId: state.pathParameters['subId']!,
                                     packageId: state.pathParameters['packageId']!,
                                   ),
                                ),
                              ),
                             GoRoute(
                                path: 'new',
                                builder: (context, state) => _AdminAuthWrapper(
                                   child: AdminPackageEditorScreen(
                                     eventId: state.pathParameters['eventId']!,
                                     subId: state.pathParameters['subId']!,
                                     packageId: 'new', // Flag for new package
                                   ),
                                ),
                              ),
                           ]
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '/admin/orders',
              builder: (context, state) => const BookingDashboardScreen(),
            ),
            GoRoute(
              path: '/admin/menu',
              builder: (context, state) => const EditMenuScreen(),
            ),
            GoRoute(
              path: '/admin/activity',
              builder: (context, state) => const ActivityLogScreen(),
            ),
          ],
        ),
      ],

      // Error page
      errorBuilder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Page Not Found'),
        ),
      ),
    );
  }
  
  /// Get the initial location from the browser URL
  static String _getInitialLocation() {
    try {
      final uri = Uri.base;
      final path = uri.path.isEmpty ? '/' : uri.path;
      debugPrint('🔗 Initial location from URL: $path');
      return path;
    } catch (e) {
      return '/';
    }
  }
}

class _AdminAuthWrapper extends StatelessWidget {
  final Widget child;
  const _AdminAuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // This wrapper ensures we don't flash content before auth is ready
    final auth = AppRouter._authNotifier;
    
    // Uses the listenable to rebuild
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return child;
      },
    );
  }
}
