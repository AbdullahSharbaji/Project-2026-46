import 'package:flutter/material.dart';

class ProviderProfilePage extends StatelessWidget {
  final String name;
  final String imageUrl; // Kept for compatibility if we switch back to images, or use as icon color seed
  final double rating;
  final String profession;

  const ProviderProfilePage({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildPriceSection(),
            const SizedBox(height: 16),
            _buildReviewsSection(),
            const SizedBox(height: 24),
            _buildHireButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            profession,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 24),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                "(42 yorum)",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
      child: const Column(
        children: [
          Text(
            "Ortalama Piyasa Fiyatı",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            "750₺ - 1.500₺",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3C72),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "* Fiyatlar işin büyüklüğüne göre değişebilir.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviews = [
      {
        "user": "Mehmet K.",
        "date": "2 gün önce",
        "rating": 5,
        "comment": "Çok temiz çalıştı, işini hakkıyla yapıyor. Tavsiye ederim.",
      },
      {
        "user": "Selin A.",
        "date": "1 hafta önce",
        "rating": 4,
        "comment": "Zamanında geldi ama işlem beklediğimden uzun sürdü.",
      },
      {
        "user": "Caner T.",
        "date": "3 hafta önce",
        "rating": 5,
        "comment": "On numara beş yıldız hizmet.",
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Yorumlar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          ...reviews.map((r) => _buildReviewItem(r)).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['user'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                review['date'],
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 14,
                color: index < review['rating'] ? Colors.orange : Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            review['comment'],
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildHireButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Hook up to request creation logic
            print("Talep oluştur for ${name}");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3C72),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          child: const Text(
            "Teklif Al / Talep Oluştur",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
