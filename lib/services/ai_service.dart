import 'dart:math';
import '../models/product.dart';
import '../models/order.dart';
import '../utils/constants.dart';

/// Simulated AI service providing smart insights, predictions, and recommendations.
class AIService {
  static final _random = Random(42);

  // --- FARMER AI FEATURES ---

  static Map<String, dynamic> getDemandForecast(List<Product> products) {
    final forecasts = <Map<String, dynamic>>[];
    for (final p in products) {
      final trend = _random.nextDouble() * 0.4 - 0.1; // -10% to +30%
      final predicted = (p.stockQuantity * (1 + trend)).round().clamp(5, 200);
      forecasts.add({
        'product': p.name,
        'currentStock': p.stockQuantity,
        'predictedDemand': predicted,
        'trend': trend,
        'action': trend > 0.15
            ? 'Increase stock'
            : trend < 0
                ? 'Reduce stock'
                : 'Maintain',
      });
    }
    return {'forecasts': forecasts};
  }

  static Map<String, dynamic> getPricingSuggestions(List<Product> products) {
    final suggestions = <Map<String, dynamic>>[];
    for (final p in products) {
      final marketAvg = p.price * (0.85 + _random.nextDouble() * 0.3);
      final suggestedPrice = (marketAvg * 100).round() / 100;
      final diff = ((suggestedPrice - p.price) / p.price * 100);
      suggestions.add({
        'product': p.name,
        'currentPrice': p.price,
        'marketAverage': marketAvg,
        'suggestedPrice': suggestedPrice,
        'percentDiff': diff,
        'action': diff > 5
            ? 'Consider raising'
            : diff < -5
                ? 'Consider lowering'
                : 'Price is competitive',
      });
    }
    return {'suggestions': suggestions};
  }

  static List<Map<String, dynamic>> getAIInsights(
      List<Product> products, List<Order> orders) {
    final insights = <Map<String, dynamic>>[];

    // Low stock alerts
    for (final p in products) {
      if (p.stockQuantity < 20) {
        insights.add({
          'type': 'warning',
          'icon': 'inventory_2',
          'title': 'Low Stock Alert',
          'message':
              '${p.name} has only ${p.stockQuantity} units left. Based on sales velocity, consider restocking within 3 days.',
          'priority': 'high',
        });
      }
    }

    // Revenue insight
    if (orders.isNotEmpty) {
      final totalRev = orders.fold<double>(0, (s, o) => s + o.total);
      final avgOrder = totalRev / orders.length;
      insights.add({
        'type': 'success',
        'icon': 'trending_up',
        'title': 'Revenue Trend',
        'message':
            'Average order value is \$${avgOrder.toStringAsFixed(2)}. Organic products drive 40% higher basket size.',
        'priority': 'medium',
      });
    }

    // Seasonal suggestion
    insights.add({
      'type': 'info',
      'icon': 'auto_awesome',
      'title': 'Seasonal Opportunity',
      'message':
          'Spring produce demand is rising 25%. Consider adding asparagus and spring onions to capture seasonal buyers.',
      'priority': 'medium',
    });

    // Customer pattern
    insights.add({
      'type': 'info',
      'icon': 'people',
      'title': 'Customer Pattern',
      'message':
          'Peak ordering hours are 10AM-12PM and 5PM-7PM. Schedule fresh stock arrivals before these windows.',
      'priority': 'low',
    });

    // Pricing AI
    final organicProducts = products.where((p) => p.isOrganic).toList();
    if (organicProducts.isNotEmpty) {
      insights.add({
        'type': 'success',
        'icon': 'price_change',
        'title': 'Pricing Insight',
        'message':
            'Your organic products are priced 12% below market average. A 5-8% increase could boost revenue without impacting demand.',
        'priority': 'high',
      });
    }

    return insights;
  }

  static List<double> getRevenueTimeline(int days) {
    final data = <double>[];
    double base = 45.0;
    for (int i = 0; i < days; i++) {
      base += (_random.nextDouble() - 0.35) * 20;
      base = base.clamp(15.0, 120.0);
      data.add((base * 100).round() / 100);
    }
    return data;
  }

  static List<Map<String, dynamic>> getCategorySales() {
    return [
      {'category': 'Vegetables', 'sales': 35.0, 'color': 0xFF4CAF50},
      {'category': 'Fruits', 'sales': 25.0, 'color': 0xFFFF9800},
      {'category': 'Dairy & Eggs', 'sales': 15.0, 'color': 0xFF2196F3},
      {'category': 'Herbs', 'sales': 10.0, 'color': 0xFF9C27B0},
      {'category': 'Baked Goods', 'sales': 8.0, 'color': 0xFFFF5722},
      {'category': 'Other', 'sales': 7.0, 'color': 0xFF607D8B},
    ];
  }

  static List<double> getOrderVolume(int days) {
    final data = <double>[];
    for (int i = 0; i < days; i++) {
      data.add((_random.nextInt(15) + 3).toDouble());
    }
    return data;
  }

  // --- CUSTOMER AI FEATURES ---

  static List<Product> getPersonalizedRecommendations(
      List<Product> allProducts) {
    final shuffled = [...allProducts]..shuffle(_random);
    return shuffled.take(min(6, shuffled.length)).toList();
  }

  static List<Product> getTrendingProducts(List<Product> allProducts) {
    final sorted = [...allProducts]
      ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return sorted.take(min(4, sorted.length)).toList();
  }

  static List<Product> getSeasonalPicks(List<Product> allProducts) {
    final seasonal = allProducts
        .where((p) =>
            p.category == 'Vegetables' ||
            p.category == 'Fruits' ||
            p.category == 'Herbs & Spices')
        .toList();
    seasonal.shuffle(_random);
    return seasonal.take(min(4, seasonal.length)).toList();
  }

  static Map<String, dynamic> getSmartSearchSuggestions(String query) {
    final suggestions = <String>[
      'organic vegetables',
      'fresh fruit basket',
      'farm eggs near me',
      'artisan bread',
      'local honey',
      'grass-fed meat',
    ];
    if (query.isEmpty) {
      return {'suggestions': suggestions.take(4).toList()};
    }
    final filtered =
        suggestions.where((s) => s.contains(query.toLowerCase())).toList();
    return {'suggestions': filtered};
  }

  static String getMealSuggestion(List<Product> cartProducts) {
    if (cartProducts.isEmpty) return '';
    final names = cartProducts.map((p) => p.name.toLowerCase()).toList();
    if (names.any((n) => n.contains('tomato')) &&
        names.any((n) => n.contains('basil'))) {
      return 'Try making Caprese Salad with your tomatoes and basil!';
    }
    if (names.any((n) => n.contains('egg'))) {
      return 'These farm-fresh eggs are perfect for a veggie frittata!';
    }
    if (names.any((n) => n.contains('strawberr'))) {
      return 'Pair your strawberries with honey for a quick dessert!';
    }
    return 'You have great ingredients for a farm-fresh meal!';
  }

  // --- DRIVER AI FEATURES ---

  static Map<String, dynamic> getDriverStats() {
    return {
      'todayEarnings': 67.50,
      'weekEarnings': 342.75,
      'monthEarnings': 1245.80,
      'todayDeliveries': 8,
      'weekDeliveries': 34,
      'avgDeliveryTime': 28,
      'rating': 4.9,
      'completionRate': 98.5,
      'onTimeRate': 96.2,
    };
  }

  static List<double> getDriverEarningsTimeline(int days) {
    final data = <double>[];
    for (int i = 0; i < days; i++) {
      data.add((_random.nextInt(60) + 20).toDouble());
    }
    return data;
  }

  static List<Map<String, dynamic>> getOptimizedRoute(List<Order> orders) {
    final routes = <Map<String, dynamic>>[];
    for (int i = 0; i < orders.length; i++) {
      routes.add({
        'order': orders[i],
        'estimatedMinutes': 12 + _random.nextInt(20),
        'distance': (1.5 + _random.nextDouble() * 5).toStringAsFixed(1),
        'priority': i == 0 ? 'Next' : 'Queue',
      });
    }
    return routes;
  }

  static List<Map<String, dynamic>> getDriverInsights() {
    return [
      {
        'icon': 'speed',
        'title': 'Peak Hours Ahead',
        'message': 'Lunch rush expected 11:30AM-1PM. Stay in downtown area for more orders.',
        'type': 'info',
      },
      {
        'icon': 'star',
        'title': 'Great Performance',
        'message': 'Your on-time rate is 96.2%! Keep it up to unlock priority deliveries.',
        'type': 'success',
      },
      {
        'icon': 'local_gas_station',
        'title': 'Fuel Optimization',
        'message': 'Batch nearby deliveries to save 15% on fuel costs this week.',
        'type': 'info',
      },
    ];
  }

  // --- AI CHATBOT ---

  static String getCropAdvice(String question) {
    final q = question.toLowerCase();
    if (q.contains('tomato')) {
      return 'Tomatoes thrive in full sun (6-8 hours). Plant after last frost. '
          'Space 24-36 inches apart. Water deeply but infrequently. '
          'Mulch to retain moisture. Expect harvest in 60-85 days from transplant. '
          'Current market price trend: +8% this month.';
    }
    if (q.contains('price') || q.contains('pricing')) {
      return 'Based on current market analysis:\n'
          '- Organic vegetables: \$3-8/lb (trending up 5%)\n'
          '- Fruits: \$4-7/pint (seasonal peak)\n'
          '- Eggs: \$5-7/dozen (stable)\n'
          '- Herbs: \$2-4/bunch (high demand)\n\n'
          'Tip: Bundle organic products for 15-20% premium pricing.';
    }
    if (q.contains('organic') || q.contains('certification')) {
      return 'To get USDA Organic certification:\n'
          '1. Maintain organic practices for 3+ years\n'
          '2. Submit application to USDA-accredited agent\n'
          '3. Pass annual inspections\n\n'
          'Benefits: 20-40% price premium, access to organic marketplace channels. '
          'Your current organic products already show 35% higher sales velocity.';
    }
    if (q.contains('season') || q.contains('plant') || q.contains('grow')) {
      return 'Spring planting guide (March-May):\n'
          '- Early spring: Lettuce, peas, spinach, radishes\n'
          '- Mid spring: Tomatoes, peppers, squash\n'
          '- Late spring: Corn, beans, melons\n\n'
          'AI prediction: Leafy greens demand will increase 30% in the next 4 weeks.';
    }
    if (q.contains('pest') || q.contains('disease')) {
      return 'Common organic pest management:\n'
          '- Aphids: Neem oil spray or ladybug release\n'
          '- Tomato hornworm: Hand-pick or BT spray\n'
          '- Fungal diseases: Copper-based fungicide, proper spacing\n\n'
          'Preventive tip: Companion planting with marigolds and basil reduces pest pressure by 40%.';
    }
    return 'I can help with:\n'
        '- Crop planning and planting schedules\n'
        '- Pricing strategies and market trends\n'
        '- Organic certification guidance\n'
        '- Pest and disease management\n'
        '- Demand forecasting for your products\n\n'
        'Try asking about a specific crop or topic!';
  }
}
