import 'package:flutter/material.dart';
import 'package:project46/Pages/ProviderProfilePage.dart';
import '../services/api_service.dart';

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
      body: Container(
        color: const Color(0xFFF5F7FA),
        child: FutureBuilder<List<dynamic>>(
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
                return _buildProviderCardFromData(context, items[i]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProviderCardFromData(BuildContext context, dynamic p) {
    final name = (p["fullName"] ?? "-").toString();
    final city = (p["city"] ?? "-").toString();
    final phone = (p["phone"] ?? "").toString();
    final rating = double.tryParse((p["rating"] ?? 0).toString()) ?? 0.0;
    final priceNote = (p["priceNote"] ?? "").toString();
    final imageUrl = (p["imageUrl"] ?? "https://via.placeholder.com/150").toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: imageUrl.isEmpty ? const Icon(Icons.person, size: 40, color: Colors.grey) : null,
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
                    Expanded(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
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
                  "$city • $phone",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                if (priceNote.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    priceNote,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProviderProfilePage(
                            name: name,
                            imageUrl: imageUrl,
                            rating: rating,
                            profession: widget.categoryName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3C72),
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
