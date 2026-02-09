import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:photo_view/photo_view.dart';
import 'offers_page.dart';


class AktifTalepler extends StatefulWidget {
  final int userId;

  const AktifTalepler({super.key, required this.userId});

  @override
  State<AktifTalepler> createState() => _AktifTaleplerState();
}

class _AktifTaleplerState extends State<AktifTalepler> {
  final ApiService _apiService = ApiService();

  bool _loading = true;
  List<dynamic> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final data = await _apiService.getActiveRequests(widget.userId);
    if (!mounted) return;
    setState(() {
      _requests = data;
      _loading = false;
    });
  }

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
    return Scaffold(
      appBar: AppBar(title: const Text('Aktif Talepler')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
          ? const Center(child: Text("Aktif talep yok."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final r = _requests[index];
          return _requestCard(r);
        },
      ),
    );
  }

  Widget _requestCard(dynamic r) {
    final String raw = (r["imageUrl"] ?? "").toString().trim();

    // ApiService.baseUrl örn: http://37.140.242.178/api
    final String base = ApiService.baseUrl;

    // baseUrl sonunda /api varsa kaldır (uploads kökte)
    final String root = base.replaceAll(RegExp(r'/api/?$'), '');

    final String? fullImageUrl =
    raw.isEmpty ? null : (raw.startsWith('http') ? raw : '$root$raw');

    final int requestId = int.tryParse((r["id"] ?? "").toString()) ?? 0;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: requestId == 0
          ? null
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OffersPage(
              requestId: requestId,
              title: (r["category"] ?? "").toString(),
            ),
          ),
        );
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Fotoğraf
            if (fullImageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: GestureDetector(
                    // Foto tıklanınca büyüt (kartın onTap'ini tetiklemesin)
                    onTap: () => _openImageViewer(context, fullImageUrl),
                    child: Image.network(
                      fullImageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stack) {
                        debugPrint("IMAGE ERROR: $fullImageUrl -> $error");
                        return Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image,
                              size: 40, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ✅ Başlık + durum
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    (r["category"] ?? "").toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (r["status"] ?? "").toString(),
                    style: const TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ✅ Açıklama
            Text(
              (r["description"] ?? "").toString(),
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 8),

            // ✅ teklif sayısı
            Row(
              children: [
                const Icon(Icons.local_offer, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "${r["offerCount"] ?? 0} teklif",
                  style: const TextStyle(color: Colors.grey),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
