import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};
  List<CartItem> get itemsList => _items.values.toList();
  int get itemCount => _items.length;

  int get totalQuantity {
    int total = 0;
    _items.forEach((key, item) => total += item.quantity);
    return total;
  }

  double get subtotal {
    double total = 0.0;
    _items.forEach((key, item) => total += item.totalPrice);
    return total;
  }

  double get deliveryFee {
    if (_items.isEmpty) return 0.0;
    return subtotal >= AppConstants.freeDeliveryThreshold
        ? 0.0
        : AppConstants.deliveryFee;
  }

  double get total => subtotal + deliveryFee;

  bool isInCart(String productId) => _items.containsKey(productId);

  int getQuantity(String productId) {
    return _items.containsKey(productId) ? _items[productId]!.quantity : 0;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decrementItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (!_items.containsKey(productId)) return;
    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity = quantity;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
