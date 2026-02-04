import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:project46/Pages/ProviderProfilePage.dart';
=======
import '../services/api_service.dart';
>>>>>>> 10a107fd6f2e02be8affded6c854583a0b6f96c1

class KategorikTemp extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const KategorikTemp({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<KategorikTemp> createState() => _KategorikTempState();
}

class _KategorikTempState extends State<KategorikTemp> {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
<<<<<<< HEAD
      body: Container(
        color: const Color(0xFFF5F7FA),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _dummyProviders.length,
          itemBuilder: (context, index) {
            return _buildProviderCard(context, _dummyProviders[index]);
          },
        ),
=======
      body: FutureBuilder<List<dynamic>>(
        future: api.getProvidersByCategory(widget.categoryId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snap.data ?? [];

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "${widget.categoryName} kategorisinde henüz usta yok.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final p = items[i];
              final name = (p["fullName"] ?? "-").toString();
              final city = (p["city"] ?? "-").toString();
              final phone = (p["phone"] ?? "").toString();
              final rating = (p["rating"] ?? 0).toString();
              final priceNote = (p["priceNote"] ?? "").toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "U",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$city • ⭐ $rating",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          if (priceNote.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              priceNote,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                          if (phone.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              phone,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      onPressed: () {
                        // İstersen buradan provider detail sayfasına gidebiliriz
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
>>>>>>> 10a107fd6f2e02be8affded6c854583a0b6f96c1
      ),
    );
  }

  Widget _buildProviderCard(BuildContext context, _ServiceProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          // Info & Action
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            provider.rating.toString(),
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.categoryName, // Profession matches category
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProviderProfilePage(
                            name: provider.name,
                            imageUrl: provider.imageUrl,
                            rating: provider.rating,
                            profession: widget.categoryName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3C72), // Matches theme color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text("İncele"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy Data Model
class _ServiceProvider {
  final String name;
  final String imageUrl;
  final double rating;

  _ServiceProvider({
    required this.name,
    required this.imageUrl,
    required this.rating,
  });
}

// Dummy Data List
List<_ServiceProvider> _dummyProviders = [
  _ServiceProvider(
    name: "Ahmet Yılmaz",
    imageUrl: "https://i.pravatar.cc/150?img=11",
    rating: 4.8,
  ),
  _ServiceProvider(
    name: "Ayşe Kaya",
    imageUrl: "https://i.pravatar.cc/150?img=5",
    rating: 4.9,
  ),
  _ServiceProvider(
    name: "Mehmet Demir",
    imageUrl: "https://i.pravatar.cc/150?img=13",
    rating: 4.5,
  ),
  _ServiceProvider(
    name: "Fatma Çelik",
    imageUrl: "https://i.pravatar.cc/150?img=9",
    rating: 4.7,
  ),
  _ServiceProvider(
    name: "Ali Vural",
    imageUrl: "https://i.pravatar.cc/150?img=3",
    rating: 4.6,
  ),
];
