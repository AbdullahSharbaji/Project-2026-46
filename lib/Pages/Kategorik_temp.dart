import 'package:flutter/material.dart';
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
      ),
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
      ),
    );
  }
}
