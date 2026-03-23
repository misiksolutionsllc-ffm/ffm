import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/order_status_badge.dart';
import 'product_management_screen.dart';
import 'add_product_screen.dart';

class FarmerHomeScreen extends StatelessWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final myProducts = productProvider.getProductsByFarmer('f1');
    final orders = orderProvider.farmerOrders;

    return DefaultTabController(
      length: 3,
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
          bottom: const TabBar(
            indicatorColor: AppColors.accent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: 'Dashboard'),
              Tab(text: 'Products'),
              Tab(text: 'Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Dashboard
            _DashboardTab(
              productCount: myProducts.length,
              orderCount: orders.length,
              revenue: orders.fold<double>(0, (sum, o) => sum + o.total),
            ),
            // Products
            _ProductsTab(products: myProducts),
            // Orders
            _OrdersTab(orders: orders),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          ),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final int productCount;
  final int orderCount;
  final double revenue;

  const _DashboardTab({
    required this.productCount,
    required this.orderCount,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Overview', style: AppTextStyles.heading2),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.inventory_2,
                label: 'Products',
                value: '$productCount',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.shopping_bag,
                label: 'Orders',
                value: '$orderCount',
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.attach_money,
                label: 'Revenue',
                value: '${AppConstants.currency}${revenue.toStringAsFixed(2)}',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.star,
                label: 'Rating',
                value: '4.8',
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Quick Actions', style: AppTextStyles.heading3),
        const SizedBox(height: 12),
        _ActionTile(
          icon: Icons.add_circle,
          title: 'Add New Product',
          subtitle: 'List a new product for sale',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          ),
        ),
        _ActionTile(
          icon: Icons.inventory,
          title: 'Manage Inventory',
          subtitle: 'Update stock levels and prices',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ProductManagementScreen()),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

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
            Text('No products yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.eco, color: AppColors.primary),
                  ),
                ),
              ),
            ),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              '${AppConstants.currency}${product.price.toStringAsFixed(2)}/${product.unit} — Stock: ${product.stockQuantity}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (product.isOrganic)
                  const Icon(Icons.eco, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: product.inStock ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProductManagementScreen(),
              ),
            ),
          ),
        );
      },
    );
  }
}

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
            Text('No orders yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
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
                const SizedBox(height: 8),
                Text(
                  '${order.items.length} items — ${AppConstants.currency}${order.total.toStringAsFixed(2)}',
                  style: AppTextStyles.caption,
                ),
                Text(
                  DateFormat('MMM dd, yyyy — hh:mm a').format(order.createdAt),
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 12),
                if (order.status == OrderStatus.pending ||
                    order.status == OrderStatus.confirmed ||
                    order.status == OrderStatus.preparing)
                  Row(
                    children: _getActionButtons(context, order, orderProvider),
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
