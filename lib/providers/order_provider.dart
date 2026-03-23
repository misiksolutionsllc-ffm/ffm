import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../utils/constants.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final _uuid = const Uuid();

  List<Order> get orders => [..._orders];

  List<Order> get customerOrders => _orders.toList();

  List<Order> get availableDeliveries =>
      _orders.where((o) => o.status == OrderStatus.readyForPickup && o.driverId == null).toList();

  List<Order> get activeDriverOrders =>
      _orders.where((o) => o.driverId != null && o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).toList();

  List<Order> get farmerOrders => _orders.toList();

  List<Order> getOrdersByStatus(OrderStatus status) =>
      _orders.where((o) => o.status == status).toList();

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Order createOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
  }) {
    final order = Order(
      id: _uuid.v4().substring(0, 8).toUpperCase(),
      customerId: 'customer_1',
      customerName: 'John Doe',
      customerAddress: '123 Main St, Springfield',
      customerPhone: '(555) 123-4567',
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      createdAt: DateTime.now(),
      estimatedDelivery: DateTime.now().add(const Duration(minutes: 45)),
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final order = getOrderById(orderId);
    if (order != null) {
      order.status = status;
      notifyListeners();
    }
  }

  void assignDriver(String orderId, String driverId, String driverName) {
    final order = getOrderById(orderId);
    if (order != null) {
      order.driverId = driverId;
      order.driverName = driverName;
      order.status = OrderStatus.pickedUp;
      notifyListeners();
    }
  }

  void updateDriverLocation(String orderId, double lat, double lng) {
    final order = getOrderById(orderId);
    if (order != null) {
      order.driverLat = lat;
      order.driverLng = lng;
      notifyListeners();
    }
  }
}
