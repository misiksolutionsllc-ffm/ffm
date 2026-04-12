import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../services/ai_service.dart';
import '../../utils/constants.dart';
import '../../widgets/order_status_badge.dart';
import '../../widgets/dashboard_charts.dart';
import '../agents/agent_hub_screen.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final availableOrders = orderProvider.availableDeliveries;
    final activeOrders = orderProvider.activeDriverOrders;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.delivery_dining, color: Colors.white),
              SizedBox(width: 8),
              Text('Driver Portal'),
            ],
          ),
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: 'AI Agents',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const AgentHubScreen(userRole: 'driver')),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.accent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(icon: Icon(Icons.dashboard, size: 18), text: 'Dashboard'),
              Tab(icon: Icon(Icons.local_shipping, size: 18), text: 'Available'),
              Tab(icon: Icon(Icons.assignment, size: 18), text: 'Active'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DriverDashboardTab(),
            // Available deliveries
            availableOrders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No deliveries available',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text('New orders will appear here',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: availableOrders.length,
                    itemBuilder: (context, index) {
                      final order = availableOrders[index];
                      return _DeliveryCard(
                        order: order,
                        isAvailable: true,
                        onAccept: () {
                          orderProvider.assignDriver(
                              order.id, 'driver_1', 'Mike Driver');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Delivery #${order.id} accepted!'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                  ),
            // Active deliveries
            activeOrders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined,
                            size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No active deliveries',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text('Accept a delivery to get started',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activeOrders.length,
                    itemBuilder: (context, index) {
                      final order = activeOrders[index];
                      return _DeliveryCard(
                        order: order,
                        isAvailable: false,
                        onUpdateStatus: () {
                          _showStatusUpdateDialog(
                              context, orderProvider, order.id, order.status);
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context,
      OrderProvider orderProvider, String orderId, OrderStatus currentStatus) {
    final nextStatuses = <OrderStatus>[];
    switch (currentStatus) {
      case OrderStatus.pickedUp:
        nextStatuses.add(OrderStatus.inTransit);
        break;
      case OrderStatus.inTransit:
        nextStatuses.add(OrderStatus.delivered);
        break;
      default:
        break;
    }

    if (nextStatuses.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Delivery Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: nextStatuses
              .map(
                (status) => ListTile(
                  leading: Icon(status.icon, color: status.color),
                  title: Text(status.label),
                  onTap: () {
                    orderProvider.updateOrderStatus(orderId, status);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Status updated to ${status.label}'),
                        backgroundColor: status.color,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ============================================================
// DRIVER DASHBOARD TAB
// ============================================================
class _DriverDashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = AIService.getDriverStats();
    final earningsTimeline = AIService.getDriverEarningsTimeline(14);
    final weeklyEarnings = AIService.getDriverEarningsTimeline(7);
    final insights = AIService.getDriverInsights();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Earnings Summary Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.account_balance_wallet,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text("Today's Earnings",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '\$${(stats['todayEarnings'] as double).toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.trending_up,
                      color: Colors.greenAccent, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '+18% vs yesterday',
                    style: TextStyle(
                        color: Colors.greenAccent.shade100, fontSize: 12),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${stats['todayDeliveries']} deliveries',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Key Stats
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.attach_money,
                label: 'This Week',
                value:
                    '\$${(stats['weekEarnings'] as double).toStringAsFixed(0)}',
                subtitle: '${stats['weekDeliveries']} deliveries',
                color: AppColors.success,
                sparkline: weeklyEarnings,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                icon: Icons.calendar_month,
                label: 'This Month',
                value:
                    '\$${(stats['monthEarnings'] as double).toStringAsFixed(0)}',
                subtitle: 'On track for \$1,500',
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.speed,
                label: 'Avg Delivery',
                value: '${stats['avgDeliveryTime']} min',
                subtitle: '2 min faster than avg',
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                icon: Icons.star,
                label: 'Rating',
                value: '${stats['rating']}',
                subtitle: '${stats['completionRate']}% completion',
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Earnings Chart
        RevenueLineChart(
          data: earningsTimeline,
          title: 'Earnings Trend',
          color: Colors.blue,
        ),
        const SizedBox(height: 20),

        // Performance Metrics
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Performance',
                        style: AppTextStyles.heading3),
                  ],
                ),
                const SizedBox(height: 16),
                _PerformanceBar(
                  label: 'On-Time Rate',
                  value: stats['onTimeRate'] as double,
                  color: AppColors.success,
                ),
                const SizedBox(height: 12),
                _PerformanceBar(
                  label: 'Completion Rate',
                  value: stats['completionRate'] as double,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                _PerformanceBar(
                  label: 'Customer Satisfaction',
                  value: (stats['rating'] as double) / 5 * 100,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // AI Insights
        const Text('AI Insights', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        ...insights.map((insight) {
          IconData iconData;
          switch (insight['icon']) {
            case 'speed':
              iconData = Icons.speed;
              break;
            case 'star':
              iconData = Icons.star;
              break;
            case 'local_gas_station':
              iconData = Icons.local_gas_station;
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
      ],
    );
  }
}

class _PerformanceBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _PerformanceBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('${value.toStringAsFixed(1)}%',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey.shade200,
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DELIVERY CARD
// ============================================================
class _DeliveryCard extends StatelessWidget {
  final dynamic order;
  final bool isAvailable;
  final VoidCallback? onAccept;
  final VoidCallback? onUpdateStatus;

  const _DeliveryCard({
    required this.order,
    required this.isAvailable,
    this.onAccept,
    this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order.id}', style: AppTextStyles.heading3),
                OrderStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(order.customerName, style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(order.customerAddress,
                      style: AppTextStyles.caption),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(order.customerPhone, style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.shopping_bag,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${order.items.length} items',
                    style: AppTextStyles.caption),
                const Spacer(),
                Text(
                  '${AppConstants.currency}${order.total.toStringAsFixed(2)}',
                  style: AppTextStyles.price,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isAvailable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check),
                  label: const Text('Accept Delivery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening navigation...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.navigation),
                      label: const Text('Navigate'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onUpdateStatus,
                      icon: const Icon(Icons.update),
                      label: const Text('Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
