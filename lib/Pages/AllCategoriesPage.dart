import 'package:flutter/material.dart';
import 'package:project46/Pages/Kategorik_temp.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extended list of categories
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.flash_on, 'name': 'Elektrikçi'},
      {'icon': Icons.water_drop, 'name': 'Tesisatçı'},
      {'icon': Icons.ac_unit, 'name': 'Klima Tamiri'},
      {'icon': Icons.kitchen, 'name': 'Beyaz Eşya'},
      {'icon': Icons.handyman, 'name': 'Marangoz'},
      {'icon': Icons.format_paint, 'name': 'Boyacı'},
      {'icon': Icons.cleaning_services, 'name': 'Temizlik'},
      {'icon': Icons.local_shipping, 'name': 'Nakliyat'},
      {'icon': Icons.pest_control, 'name': 'İlaçlama'},
      {'icon': Icons.lock, 'name': 'Çilingir'},
      {'icon': Icons.computer, 'name': 'Bilgisayar'},
      {'icon': Icons.tv, 'name': 'Televizyon'},
      {'icon': Icons.yard, 'name': 'Bahçıvan'},
      {'icon': Icons.pool, 'name': 'Havuz Bakımı'},
      {'icon': Icons.roofing, 'name': 'Çatı Tamiri'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tüm Hizmetler"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return _CategoryItem(
              cat['icon'],
              cat['name'],
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KategorikTemp(categoryName: cat['name']),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CategoryItem(this.icon, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
