import 'package:flutter/material.dart';
import 'package:project46/Creds/profile_page.dart';
import 'package:project46/Pages/Bildirimler.dart';
import 'package:project46/Pages/Kategorik_temp.dart';
import 'package:project46/Pages/aktif_talepler.dart';
<<<<<<< HEAD
import 'package:project46/Pages/AllCategoriesPage.dart';
=======
import 'package:project46/services/api_service.dart';
>>>>>>> ba38d49357f640475cd3aa04e861d7a947eb3839

class HizmetPage extends StatelessWidget {
  final int userId;
  const HizmetPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildCategories(context),
            const SizedBox(height: 24),
            _buildActiveRequests(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // HEADER
  // ======================================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merhaba 👋',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Hangi hizmete ihtiyacınız var?',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _iconButton(Icons.notifications, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Bildirimler(),
                      ),
                    );
                  }),
                  const SizedBox(width: 12),
                  _iconButton(Icons.person, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(userId: userId),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  // ======================================================
  // CATEGORIES (DB'DEN)
  // ======================================================
  Widget _buildCategories(BuildContext context) {
    final api = ApiService();

    IconData iconFromKey(String key) {
      switch (key) {
        case "flash_on":
          return Icons.flash_on;
        case "water_drop":
          return Icons.water_drop;
        case "ac_unit":
          return Icons.ac_unit;
        case "kitchen":
          return Icons.kitchen;
        case "handyman":
          return Icons.handyman;
        case "format_paint":
          return Icons.format_paint;
        default:
          return Icons.category;
      }
    }

    void goToCategory(int id, String name) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KategorikTemp(
            categoryId: id,
            categoryName: name,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Kategoriler'),
            const SizedBox(height: 16),

            FutureBuilder<List<dynamic>>(
              future: api.getCategories(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final items = snap.data ?? [];

                if (items.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: const Text("Kategori bulunamadı."),
                  );
                }

                return GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: items.map((c) {
                    final id = c["id"] ?? 0;
                    final name = (c["name"] ?? "-").toString();
                    final iconKey = (c["iconKey"] ?? "category").toString();

                    return _CategoryItem(
                      iconFromKey(iconKey),
                      name,
                          () => goToCategory(id, name),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllCategoriesPage(),
                    ),
                  );
                },
                child: const Text(
                  "Hepsini Göster",
                  style: TextStyle(color: Color(0xFF1E3C72), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // ACTIVE REQUESTS (DB'DEN)
  // ======================================================
  Widget _buildActiveRequests(BuildContext context) {
    final api = ApiService();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionHeader(title: 'Aktif Talepler'),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AktifTalepler(userId: userId),
                  ),
                ),
                child: const Text(
                  'Tümünü Gör →',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          FutureBuilder<List<dynamic>>(
            future: api.getActiveRequests(userId),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final items = snap.data ?? [];

              if (items.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: const Text("Aktif talep yok."),
                );
              }

              final showList = items.take(2).toList();

              return Column(
                children: showList.map((r) {
                  final title = (r["category"] ?? "-").toString();
                  final desc = (r["description"] ?? "Açıklama yok").toString();
                  final status = (r["status"] ?? "-").toString();
                  final offers = (r["offerCount"] ?? 0).toString();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _requestCard(
                      title: title,
                      description: desc,
                      status: "$status • $offers teklif",
                      statusColor: Colors.orange,
                      time: "",
                      onTap: () {},
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _requestCard({
    required String title,
    required String description,
    required String status,
    required Color statusColor,
    required String time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(color: Colors.grey)),
            if (time.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(time, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  // ======================================================
  // STYLES
  // ======================================================
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ======================================================
// CUSTOM WIDGETS
// ======================================================
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
