import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/order_status_badge.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final availableOrders = orderProvider.availableDeliveries;
    final activeOrders = orderProvider.activeDriverOrders;

    return DefaultTabController(
      length: 2,
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
          bottom: const TabBar(
            indicatorColor: AppColors.accent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: 'Available Deliveries'),
              Tab(text: 'My Deliveries'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
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
                            style:
                                TextStyle(fontSize: 18, color: Colors.grey)),
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
                              content: Text(
                                  'Delivery #${order.id} accepted!'),
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
                            style:
                                TextStyle(fontSize: 18, color: Colors.grey)),
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
                        content:
                            Text('Status updated to ${status.label}'),
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
                const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(order.customerName, style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
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
                const Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(order.customerPhone, style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.shopping_bag, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${order.items.length} items', style: AppTextStyles.caption),
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
