/// Dashboard Statistics Model
/// Real-time metrics for the admin dashboard
class DashboardStats {
  // Revenue metrics
  final double totalRevenue;
  final double todayRevenue;
  final double weekRevenue;
  final double monthRevenue;
  final double revenueGrowth; // Percentage
  
  // Order metrics
  final int totalOrders;
  final int activeOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int todayOrders;
  
  // Quote metrics
  final int totalQuotes;
  final int pendingQuotes;
  final int quotedQuotes;
  final int closedQuotes;
  final double quoteConversionRate; // Percentage
  
  // Event metrics
  final int upcomingEvents;
  final int todayEvents;
  final int weekEvents;
  final int monthEvents;
  
  // Regional metrics
  final Map<String, double> revenueByRegion;
  final Map<String, int> ordersByRegion;
  
  // Payment metrics
  final double totalReceived;
  final double totalPending;
  final double averageOrderValue;
  
  // Customer metrics
  final int totalCustomers;
  final int newCustomersToday;
  final int newCustomersWeek;
  final int repeatCustomers;

  DashboardStats({
    this.totalRevenue = 0,
    this.todayRevenue = 0,
    this.weekRevenue = 0,
    this.monthRevenue = 0,
    this.revenueGrowth = 0,
    this.totalOrders = 0,
    this.activeOrders = 0,
    this.completedOrders = 0,
    this.cancelledOrders = 0,
    this.todayOrders = 0,
    this.totalQuotes = 0,
    this.pendingQuotes = 0,
    this.quotedQuotes = 0,
    this.closedQuotes = 0,
    this.quoteConversionRate = 0,
    this.upcomingEvents = 0,
    this.todayEvents = 0,
    this.weekEvents = 0,
    this.monthEvents = 0,
    this.revenueByRegion = const {},
    this.ordersByRegion = const {},
    this.totalReceived = 0,
    this.totalPending = 0,
    this.averageOrderValue = 0,
    this.totalCustomers = 0,
    this.newCustomersToday = 0,
    this.newCustomersWeek = 0,
    this.repeatCustomers = 0,
  });

  // Calculate key metrics
  String get totalRevenueFormatted => _formatCurrency(totalRevenue);
  String get monthRevenueFormatted => _formatCurrency(monthRevenue);
  String get averageOrderValueFormatted => _formatCurrency(averageOrderValue);
  
  String get revenueGrowthFormatted => '${revenueGrowth >= 0 ? '+' : ''}${revenueGrowth.toStringAsFixed(1)}%';
  String get quoteConversionRateFormatted => '${quoteConversionRate.toStringAsFixed(1)}%';
  
  bool get isGrowing => revenueGrowth > 0;
  
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  // Create empty stats
  factory DashboardStats.empty() => DashboardStats();
}

/// Revenue Trend Item
class RevenueTrendItem {
  final DateTime date;
  final double amount;
  final String currency;

  RevenueTrendItem({
    required this.date,
    required this.amount,
    required this.currency,
  });
}

/// Order Status Distribution
class OrderStatusDistribution {
  final Map<String, int> distribution;

  OrderStatusDistribution({required this.distribution});

  int get pending => distribution['pending'] ?? 0;
  int get confirmed => distribution['confirmed'] ?? 0;
  int get preparing => distribution['preparing'] ?? 0;
  int get completed => distribution['completed'] ?? 0;
  int get cancelled => distribution['cancelled'] ?? 0;
  
  int get total => distribution.values.fold(0, (sum, count) => sum + count);
}
