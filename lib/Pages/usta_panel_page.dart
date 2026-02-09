import 'package:flutter/material.dart';
import 'package:project46/services/api_service.dart';
import 'package:photo_view/photo_view.dart';
import 'teklif_ver_page.dart';
import 'profil_page.dart';
import 'bildirimler_page.dart';

class UstaPanelPage extends StatefulWidget {
  final int workerId;
  final String category;

  const UstaPanelPage({
    super.key,
    required this.workerId,
    required this.category,
  });

  @override
  State<UstaPanelPage> createState() => _UstaPanelPageState();
}

class _UstaPanelPageState extends State<UstaPanelPage> {
  final ApiService _api = ApiService();

  List<dynamic> talepler = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _loading = true);

    final list = await _api.getRequestsForWorkerCategory(widget.category);

    if (!mounted) return;

    setState(() {
      talepler = list;
      _loading = false;
    });
  }

  // ✅ Fotoğraf büyütme
  void _openImageViewer(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ImageViewerPage(imageUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1E3C72);
    const Color secondaryBlue = Color(0xFF2A5298);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Usta Paneli (${widget.category})",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, secondaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BildirimlerPage())),
            icon: const Stack(
              children: [
                Icon(Icons.notifications, size: 28),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.red,
                    child: Text("2", style: TextStyle(fontSize: 9, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilPage())),
            icon: const Icon(Icons.account_circle, size: 30),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadRequests,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderStats(primaryBlue),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Yeni Talepler",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBlue),
                ),
              ),
              if (talepler.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Bu kategori için yeni talep yok."),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: talepler.length,
                  itemBuilder: (context, index) => _buildTalepKarti(talepler[index], primaryBlue),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStats(Color color) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _statItem("Yeni", talepler.length.toString(), Colors.orange),
          const SizedBox(width: 10),
          _statItem("Biten", "0", Colors.green),
          const SizedBox(width: 10),
          _statItem("Puan", "4.9", color),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTalepKarti(dynamic veri, Color color) {
    final String category = (veri["category"] ?? "").toString();
    final String desc = (veri["description"] ?? "").toString();
    final String createdAt = (veri["createdAt"] ?? "").toString();
    final int offerCount = (veri["offerCount"] ?? 0) as int;

    // ✅ Foto URL ("/uploads/..") -> full url
    final String rawImage = (veri["imageUrl"] ?? "").toString().trim();
    final String base = ApiService.baseUrl; // http://37.140.242.178/api
    final String root = base.replaceAll(RegExp(r'/api/?$'), '');
    final String? fullImageUrl =
    rawImage.isEmpty ? null : (rawImage.startsWith('http') ? rawImage : '$root$rawImage');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // ✅ FOTO (varsa) + tıklayınca büyüt
          if (fullImageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: () => _openImageViewer(context, fullImageUrl),
                  child: Image.network(
                    fullImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stack) {
                      debugPrint("USTA IMAGE ERROR: $fullImageUrl -> $error");
                      return Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(Icons.build, color: color),
            ),
            title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(desc.isEmpty ? "-" : desc, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(createdAt, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              Text("Teklif: $offerCount", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Divider(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeklifVerPage(
                      talepBasligi: category,
                      requestId: int.parse(veri["id"].toString()), // ✅ talep id
                      workerId: widget.workerId,                   // ✅ usta id
                    ),
                  ),
                );
              },
              child: const Text("TEKLİF VER"),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Viewer Page
class _ImageViewerPage extends StatelessWidget {
  final String imageUrl;
  const _ImageViewerPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Fotoğraf", style: TextStyle(color: Colors.white)),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3.0,
      ),
    );
  }
}
