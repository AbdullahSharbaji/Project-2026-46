import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AktifTalepler extends StatefulWidget {
  final int userId; // ✅ GERÇEK ALAN

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
    setState(() {
      _requests = data;
      _loading = false;
    });
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r["category"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r["status"],
                  style: const TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            r["description"] ?? "",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.local_offer, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "${r["offerCount"]} teklif",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

