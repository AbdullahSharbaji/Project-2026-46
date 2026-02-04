import 'package:flutter/material.dart';
import 'package:project46/Pages/Kategorik_temp.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extended list of categories
    final List<Map<String, dynamic>> categories = [
      {'id': 1, 'icon': Icons.flash_on, 'name': 'Elektrikçi'},
      {'id': 2, 'icon': Icons.water_drop, 'name': 'Tesisatçı'},
      {'id': 3, 'icon': Icons.ac_unit, 'name': 'Klima Tamiri'},
      {'id': 4, 'icon': Icons.kitchen, 'name': 'Beyaz Eşya'},
      {'id': 5, 'icon': Icons.handyman, 'name': 'Marangoz'},
      {'id': 6, 'icon': Icons.format_paint, 'name': 'Boyacı'},
      {'id': 7, 'icon': Icons.cleaning_services, 'name': 'Temizlik'},
      {'id': 8, 'icon': Icons.local_shipping, 'name': 'Nakliyat'},
      {'id': 9, 'icon': Icons.pest_control, 'name': 'İlaçlama'},
      {'id': 10, 'icon': Icons.lock, 'name': 'Çilingir'},
      {'id': 11, 'icon': Icons.computer, 'name': 'Bilgisayar'},
      {'id': 12, 'icon': Icons.tv, 'name': 'Televizyon'},
      {'id': 13, 'icon': Icons.yard, 'name': 'Bahçıvan'},
      {'id': 14, 'icon': Icons.pool, 'name': 'Havuz Bakımı'},
      {'id': 15, 'icon': Icons.roofing, 'name': 'Çatı Tamiri'},
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
                    builder: (context) => KategorikTemp(
                      categoryId: cat['id'],
                      categoryName: cat['name'],
                    ),
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
              color: Colors.black.withValues(alpha: 0.03),
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
