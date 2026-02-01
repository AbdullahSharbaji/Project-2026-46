import 'package:flutter/foundation.dart';

class CartService {
  // Singleton pattern
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // State
  final ValueNotifier<List<Map<String, dynamic>>> itemsNotifier = ValueNotifier([]);

  List<Map<String, dynamic>> get items => itemsNotifier.value;

  // Add Item
  void addToCart(Map<String, dynamic> item) {
    final currentItems = List<Map<String, dynamic>>.from(itemsNotifier.value);
    
    // Check if item already exists to update quantity (optional logic, for now just add)
    // Simple implementation: Add as new entry or update quantity if we had ID
    // For this demo, we'll just add it to the list.
    
    // We might want to make a copy to ensure immutability for the notifier
    /* 
       If we wanted to handle quantity:
       int index = currentItems.indexWhere((element) => element['name'] == item['name']);
       if (index != -1) {
         currentItems[index]['quantity'] = (currentItems[index]['quantity'] ?? 1) + 1;
       } else { ... }
    */
    
    // Adding quantity field if not present
    var itemToAdd = Map<String, dynamic>.from(item);
    if (!itemToAdd.containsKey('quantity')) {
      itemToAdd['quantity'] = 1;
    }

    // Check availability
    int index = currentItems.indexWhere((e) => e['name'] == itemToAdd['name']);
    if (index != -1) {
       currentItems[index]['quantity'] += 1;
    } else {
       currentItems.add(itemToAdd);
    }
    
    itemsNotifier.value = currentItems;
  }

  // Remove Item (Decrease quantity or remove)
  void removeFromCart(Map<String, dynamic> item) {
    final currentItems = List<Map<String, dynamic>>.from(itemsNotifier.value);
    
    int index = currentItems.indexWhere((e) => e['name'] == item['name']);
    if (index != -1) {
      if (currentItems[index]['quantity'] > 1) {
        currentItems[index]['quantity'] -= 1;
      } else {
        currentItems.removeAt(index);
      }
    }
    
    itemsNotifier.value = currentItems;
  }

  // Get Total Price
  double getTotalPrice() {
    double total = 0;
    for (var item in items) {
      String priceStr = item['price'] ?? "0";
      // Clean string "₺25.00" -> 25.00
      priceStr = priceStr.replaceAll('₺', '').replaceAll(' ', '');
      double price = double.tryParse(priceStr) ?? 0;
      int quantity = item['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }

  // Clear Cart
  void clearCart() {
    itemsNotifier.value = [];
  }
}
