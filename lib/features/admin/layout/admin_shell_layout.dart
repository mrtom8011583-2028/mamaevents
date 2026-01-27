import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../admin/widgets/notification_bell.dart';

class AdminShellLayout extends StatelessWidget {
  final Widget child;

  const AdminShellLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.dashboard, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              'MAMA EVENTS - Admin',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
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
            backgroundColor: const Color(0xFF2C2C2C),
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
                   context.go('/'); // View Website
                   break;
              }
            },
            labelType: NavigationRailLabelType.all,
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
    if (location == '/admin') return 0;
    return 0;
  }
}
