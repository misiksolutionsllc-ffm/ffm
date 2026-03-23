import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/ai_service.dart';
import '../../utils/constants.dart';
import '../../widgets/order_status_badge.dart';
import '../../widgets/dashboard_charts.dart';
import 'product_management_screen.dart';
import 'add_product_screen.dart';
import 'ai_crop_advisor_screen.dart';

class FarmerHomeScreen extends StatelessWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final myProducts = productProvider.getProductsByFarmer('f1');
    final orders = orderProvider.farmerOrders;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.agriculture, color: Colors.white),
              SizedBox(width: 8),
              Text('Farmer Portal'),
            ],
          ),
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.smart_toy),
              tooltip: 'AI Crop Advisor',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AICropAdvisorScreen()),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.accent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.dashboard, size: 18), text: 'Dashboard'),
              Tab(icon: Icon(Icons.auto_awesome, size: 18), text: 'AI Insights'),
              Tab(icon: Icon(Icons.inventory_2, size: 18), text: 'Products'),
              Tab(icon: Icon(Icons.receipt_long, size: 18), text: 'Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DashboardTab(
              products: myProducts,
              orders: orders,
              revenue: orders.fold<double>(0, (sum, o) => sum + o.total),
            ),
            _AIInsightsTab(products: myProducts, orders: orders),
            _ProductsTab(products: myProducts),
            _OrdersTab(orders: orders),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Add Product'),
        ),
      ),
    );
  }
}

// ============================================================
// PROFESSIONAL DASHBOARD TAB
// ============================================================
class _DashboardTab extends StatelessWidget {
  final List<Product> products;
  final List<dynamic> orders;
  final double revenue;

  const _DashboardTab({
    required this.products,
    required this.orders,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    final revenueTimeline = AIService.getRevenueTimeline(14);
    final orderVolume = AIService.getOrderVolume(7);
    final categorySales = AIService.getCategorySales();
    final earningsSparkline = AIService.getRevenueTimeline(7);
    final ordersSparkline = AIService.getOrderVolume(7);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good morning!',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Green Valley Farm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome,
                              size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${products.length} products active',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.agriculture,
                    color: Colors.white, size: 36),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Key Metrics Grid
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.attach_money,
                label: 'Revenue',
                value: '\$${revenue.toStringAsFixed(2)}',
                subtitle: '+12.5% this week',
                color: AppColors.success,
                sparkline: earningsSparkline,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                icon: Icons.shopping_bag,
                label: 'Orders',
                value: '${orders.length}',
                subtitle: orders.isEmpty ? 'No orders yet' : '+3 today',
                color: Colors.blue,
                sparkline: ordersSparkline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.inventory_2,
                label: 'Products',
                value: '${products.length}',
                subtitle: '${products.where((p) => p.stockQuantity < 20).length} low stock',
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                icon: Icons.star,
                label: 'Rating',
                value: '4.8',
                subtitle: '124 reviews',
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Revenue Chart
        RevenueLineChart(
          data: revenueTimeline,
          title: 'Revenue Trend',
          color: AppColors.success,
        ),
        const SizedBox(height: 16),

        // Order Volume + Category Sales side by side on wider screens
        OrderVolumeBarChart(data: orderVolume),
        const SizedBox(height: 16),
        CategoryPieChart(data: categorySales),
        const SizedBox(height: 16),

        // Quick Actions
        const Text('Quick Actions', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add_circle,
                label: 'Add Product',
                color: AppColors.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddProductScreen()),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.inventory,
                label: 'Inventory',
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProductManagementScreen()),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.smart_toy,
                label: 'AI Advisor',
                color: Colors.purple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AICropAdvisorScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// AI INSIGHTS TAB
// ============================================================
class _AIInsightsTab extends StatelessWidget {
  final List<Product> products;
  final List<dynamic> orders;

  const _AIInsightsTab({required this.products, required this.orders});

  @override
  Widget build(BuildContext context) {
    final insights = AIService.getAIInsights(products, orders.cast());
    final demandForecast = AIService.getDemandForecast(products);
    final pricingSuggestions = AIService.getPricingSuggestions(products);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AI Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.blue.shade600],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Business Intelligence',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Smart insights powered by machine learning',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Smart Insights
        const Text('Smart Insights', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        ...insights.map((insight) {
          IconData iconData;
          switch (insight['icon']) {
            case 'trending_up':
              iconData = Icons.trending_up;
              break;
            case 'auto_awesome':
              iconData = Icons.auto_awesome;
              break;
            case 'people':
              iconData = Icons.people;
              break;
            case 'price_change':
              iconData = Icons.price_change;
              break;
            case 'inventory_2':
              iconData = Icons.inventory_2;
              break;
            default:
              iconData = Icons.lightbulb;
          }
          return AIInsightCard(
            type: insight['type'] as String,
            icon: iconData,
            title: insight['title'] as String,
            message: insight['message'] as String,
          );
        }),
        const SizedBox(height: 20),

        // Demand Forecast
        const Text('Demand Forecast', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          size: 16, color: Colors.purple),
                    ),
                    const SizedBox(width: 8),
                    const Text('AI Predicted Demand',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                ...(demandForecast['forecasts'] as List).map((f) {
                  final trend = f['trend'] as double;
                  final isUp = trend > 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(f['product'] as String,
                              style: const TextStyle(fontSize: 13)),
                        ),
                        Expanded(
                          flex: 2,
                          child: LinearProgressIndicator(
                            value: ((f['predictedDemand'] as int) / 200)
                                .clamp(0.0, 1.0),
                            backgroundColor: Colors.grey.shade200,
                            color: isUp ? AppColors.success : AppColors.warning,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isUp ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 14,
                          color: isUp ? AppColors.success : AppColors.warning,
                        ),
                        SizedBox(
                          width: 45,
                          child: Text(
                            '${(trend * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  isUp ? AppColors.success : AppColors.warning,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Pricing Intelligence
        const Text('Pricing Intelligence', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.price_change,
                          size: 16, color: Colors.blue),
                    ),
                    const SizedBox(width: 8),
                    const Text('Market Price Comparison',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
                const Divider(height: 20),
                ...(pricingSuggestions['suggestions'] as List).map((s) {
                  final diff = s['percentDiff'] as double;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s['product'] as String,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                'Your: \$${(s['currentPrice'] as double).toStringAsFixed(2)} → Suggested: \$${(s['suggestedPrice'] as double).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: diff.abs() < 5
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            s['action'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: diff.abs() < 5
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ============================================================
// PRODUCTS TAB
// ============================================================
class _ProductsTab extends StatelessWidget {
  final List<Product> products;

  const _ProductsTab({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No products yet',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isLowStock = product.stockQuantity < 20;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child:
                            const Icon(Icons.eco, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ),
                          if (product.isOrganic)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Organic',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppConstants.currency}${product.price.toStringAsFixed(2)}/${product.unit}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isLowStock
                                  ? AppColors.warning.withOpacity(0.1)
                                  : AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isLowStock)
                                  const Icon(Icons.warning_amber,
                                      size: 12, color: AppColors.warning),
                                if (isLowStock) const SizedBox(width: 3),
                                Text(
                                  'Stock: ${product.stockQuantity}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isLowStock
                                        ? AppColors.warning
                                        : AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: product.inStock
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProductManagementScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// ORDERS TAB
// ============================================================
class _OrdersTab extends StatelessWidget {
  final List<dynamic> orders;

  const _OrdersTab({required this.orders});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No orders yet',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order #${order.id}',
                        style: AppTextStyles.heading3),
                    OrderStatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${order.items.length} items — ${AppConstants.currency}${order.total.toStringAsFixed(2)}',
                  style: AppTextStyles.caption,
                ),
                Text(
                  DateFormat('MMM dd, yyyy — hh:mm a')
                      .format(order.createdAt),
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 12),
                if (order.status == OrderStatus.pending ||
                    order.status == OrderStatus.confirmed ||
                    order.status == OrderStatus.preparing)
                  Row(
                    children:
                        _getActionButtons(context, order, orderProvider),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _getActionButtons(
      BuildContext context, dynamic order, OrderProvider orderProvider) {
    switch (order.status) {
      case OrderStatus.pending:
        return [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                orderProvider.updateOrderStatus(
                    order.id, OrderStatus.cancelled);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                orderProvider.updateOrderStatus(
                    order.id, OrderStatus.confirmed);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ),
        ];
      case OrderStatus.confirmed:
        return [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                orderProvider.updateOrderStatus(
                    order.id, OrderStatus.preparing);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Start Preparing'),
            ),
          ),
        ];
      case OrderStatus.preparing:
        return [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                orderProvider.updateOrderStatus(
                    order.id, OrderStatus.readyForPickup);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ready for Pickup'),
            ),
          ),
        ];
      default:
        return [];
    }
  }
}
