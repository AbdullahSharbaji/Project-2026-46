import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OffersPage extends StatefulWidget {
  final int requestId;
  final String title;

  const OffersPage({super.key, required this.requestId, required this.title});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final ApiService _api = ApiService();
  bool _loading = true;
  List<dynamic> _offers = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _api.getOffersByRequest(widget.requestId);
    if (!mounted) return;
    setState(() {
      _offers = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1E3C72);

    return Scaffold(
      appBar: AppBar(
        title: Text("Teklifler", style: const TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _offers.isEmpty
          ? const Center(child: Text("Bu talep için henüz teklif yok."))
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _offers.length,
          itemBuilder: (context, i) {
            final o = _offers[i];
            return _offerCard(o);
          },
        ),
      ),
    );
  }

  Widget _offerCard(dynamic o) {
    final visitDate = (o["visitDate"] ?? "").toString();
    final timeRange = (o["timeRange"] ?? "").toString();
    final price = (o["price"] ?? 0).toString();
    final note = (o["note"] ?? "").toString();
    final workerId = (o["workerId"] ?? "").toString();

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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Usta: #$workerId", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(child: Text(visitDate, style: const TextStyle(color: Colors.grey))),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(child: Text(timeRange, style: const TextStyle(color: Colors.grey))),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.payments, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text("$price ₺", style: const TextStyle(color: Colors.grey)),
            ],
          ),

          if (note.trim().isNotEmpty) ...[
            const Divider(height: 20),
            Text(note),
          ],

          const SizedBox(height: 12),

          // ✅ Şimdilik sadece görüntüleme. İstersen kabul/ret ekleriz.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sonraki adım: Teklifi kabul et / reddet")),
                );
              },
              child: const Text("KABUL ET (sonraki adım)"),
            ),
          )
        ],
      ),
    );
  }
}
