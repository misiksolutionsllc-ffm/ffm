import '../utils/constants.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final String customerId;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime createdAt;
  OrderStatus status;
  String? driverId;
  String? driverName;
  double? driverLat;
  double? driverLng;
  DateTime? estimatedDelivery;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    this.status = OrderStatus.pending,
    this.driverId,
    this.driverName,
    this.driverLat,
    this.driverLng,
    this.estimatedDelivery,
  });
}
