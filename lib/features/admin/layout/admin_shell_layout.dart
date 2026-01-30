import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../admin/widgets/notification_bell.dart';
import '../../../../config/theme/colors.dart';

class AdminShellLayout extends StatelessWidget {
  final Widget child;

  const AdminShellLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'MAMA EVENTS',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          NotificationBell(),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go('/admin/login');
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Persistent Sidebar
          NavigationRail(
            backgroundColor: Colors.black,
            extended: MediaQuery.of(context).size.width > 1200,
            leading: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGoldGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/logo_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
            selectedIndex: _calculateSelectedIndex(context),
            onDestinationSelected: (int index) {
              switch (index) {
                case 0:
                  context.go('/admin');
                  break;
                case 1:
                  context.go('/admin/orders');
                  break;
                case 2:
                  context.go('/admin/menu');
                  break;
                case 3:
                  context.go('/admin/events');
                  break;
                case 4:
                  context.go('/admin/quotes');
                  break;
                case 5:
                  context.go('/admin/activity');
                  break;
                case 6: 
                   context.go('/'); // View Website
                   break;
              }
            },
            labelType: MediaQuery.of(context).size.width > 1200 
                ? NavigationRailLabelType.none 
                : NavigationRailLabelType.all,
            selectedLabelTextStyle: GoogleFonts.inter(
              color: const Color(0xFFD4AF37), 
              fontWeight: FontWeight.bold
            ),
            unselectedLabelTextStyle: GoogleFonts.inter(
              color: Colors.white70
            ),
            useIndicator: true,
            indicatorColor: const Color(0xFFD4AF37).withOpacity(0.2),
            selectedIconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
            unselectedIconTheme: const IconThemeData(color: Colors.white70),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag),
                label: Text('Orders'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                selectedIcon: Icon(Icons.restaurant_menu),
                label: Text('Menu'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.celebration_outlined),
                selectedIcon: Icon(Icons.celebration),
                label: Text('Events'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.format_quote_outlined),
                selectedIcon: Icon(Icons.format_quote),
                label: Text('Quotes'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history_rounded),
                label: Text('Activity'),
              ),
               NavigationRailDestination(
                icon: Icon(Icons.public),
                selectedIcon: Icon(Icons.public),
                label: Text('Website'),
              ),
            ],
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/admin/orders')) return 1;
    if (location.startsWith('/admin/menu')) return 2;
    if (location.startsWith('/admin/events')) return 3;
    if (location.startsWith('/admin/quotes')) return 4;
    if (location.startsWith('/admin/activity')) return 5;
    if (location == '/admin') return 0;
    return 0;
  }
}
