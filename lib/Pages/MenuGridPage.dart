import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'CartPage.dart';
import 'ItemDetailPage.dart';

class MenuGridPage extends StatefulWidget {
  final String pageTitle;
  
  const MenuGridPage({super.key, required this.pageTitle});

  @override
  State<MenuGridPage> createState() => _MenuGridPageState();
}

class _MenuGridPageState extends State<MenuGridPage> {
  // Config
  int _selectedIndex = 0;
  
  // Dummy Data
  final List<String> categories = ["Meyve & Sebze", "Atıştırmalık", "İçecekler", "Temel Gıda", "Süt Ürünleri"];
  
  final Map<String, List<Map<String, String>>> itemsData = {
    "Meyve & Sebze": [
      {"name": "Elma", "price": "₺25.00", "image": "assets/apple.png"},
      {"name": "Muz", "price": "₺45.00", "image": "assets/banana.png"},
      {"name": "Domates", "price": "₺30.00", "image": "assets/tomato.png"},
      {"name": "Salatalık", "price": "₺20.00", "image": "assets/cucumber.png"},
    ],
    "Atıştırmalık": [
      {"name": "Cips", "price": "₺35.00", "image": "assets/chips.png"},
      {"name": "Çikolata", "price": "₺15.00", "image": "assets/chocolate.png"},
    ],
    "İçecekler": [
      {"name": "Su (1.5L)", "price": "₺10.00", "image": "assets/water.png"},
      {"name": "Kola", "price": "₺40.00", "image": "assets/cola.png"},
      {"name": "Meyve Suyu", "price": "₺35.00", "image": "assets/juice.png"},
    ],
    // Default fallback
    "Temel Gıda": [],
    "Süt Ürünleri": [],
  };

  @override
  Widget build(BuildContext context) {
    // Get items for current category
    final currentCategory = categories[_selectedIndex];
    final currentItems = itemsData[currentCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.pageTitle),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3C72),
        elevation: 0,
        actions: [
          // Cart Icon with Badge
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: CartService().itemsNotifier,
            builder: (context, items, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_basket_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                  ),
                  if (items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${items.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. TOP CATEGORY MENU
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E3C72) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 2. ITEM GRID
          Expanded(
            child: currentItems.isEmpty 
            ? Center(child: Text("$currentCategory kategorisinde ürün bulunamadı.")) 
            : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                childAspectRatio: 0.75, // Height > Width
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: currentItems.length,
              itemBuilder: (context, index) {
                final item = currentItems[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to Details
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => ItemDetailPage(item: item))
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                         BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Placeholder
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            width: double.infinity,
                            child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 40),
                          ),
                        ),
                        // Info
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['price']!,
                                    style: const TextStyle(
                                      color: Color(0xFF1E3C72),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Add Button (Quick Add)
                                  GestureDetector(
                                    onTap: () {
                                      CartService().addToCart(item);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("${item['name']} sepete eklendi!"),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8), // Increased touch area
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1E3C72),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
