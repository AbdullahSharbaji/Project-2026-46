import 'package:flutter/material.dart';
import 'package:project46/services/api_service.dart';

class TeklifVerPage extends StatefulWidget {
  final String talepBasligi;
  final int requestId; // ✅ talep id
  final int workerId;  // ✅ usta id

  const TeklifVerPage({
    super.key,
    required this.talepBasligi,
    required this.requestId,
    required this.workerId,
  });

  @override
  State<TeklifVerPage> createState() => _TeklifVerPageState();
}

class _TeklifVerPageState extends State<TeklifVerPage> {
  final ApiService _api = ApiService();

  final Color primaryBlue = const Color(0xFF1E3C72);

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? _selectedDate;
  bool _submitting = false;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _submitOffer() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen bir tarih seçin")),
      );
      return;
    }

    final timeRange = _timeController.text.trim();
    if (timeRange.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen saat aralığı girin")),
      );
      return;
    }

    final priceText = _priceController.text.trim().replaceAll(",", ".");
    final price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen geçerli bir fiyat girin")),
      );
      return;
    }

    final note = _noteController.text.trim();

    setState(() => _submitting = true);

    final ok = await _api.createOffer(
      requestId: widget.requestId,
      workerId: widget.workerId,
      visitDateIso: _selectedDate!.toIso8601String(), // backend DateTime parse eder
      timeRange: timeRange,
      price: price,
      note: note,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teklifiniz başarıyla iletildi!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teklif gönderilemedi. (API Hatası)")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teklif Oluştur", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.talepBasligi,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryBlue),
            ),
            const SizedBox(height: 8),
            const Text("Müşteriye iletilecek iş detaylarını belirleyin.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            // ✅ Tarih (picker)
            const Text("Geleceğiniz Tarih", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                hintText: "Tarih seçin",
                prefixIcon: Icon(Icons.calendar_today, color: primaryBlue),
              ),
            ),
            const SizedBox(height: 20),

            // Saat
            _buildInputField(
              label: "Saat Aralığı",
              hint: "Örn: 10:00 - 12:00",
              icon: Icons.access_time,
              controller: _timeController,
            ),
            const SizedBox(height: 20),

            // Fiyat
            _buildInputField(
              label: "Ortalama Fiyat (₺)",
              hint: "Örn: 1500",
              icon: Icons.payments,
              isNumber: true,
              controller: _priceController,
            ),
            const SizedBox(height: 20),

            // Not
            const Text("Müşteriye Notunuz", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Yapılacak işlem hakkında kısa bilgi verin...",
                fillColor: Colors.grey.shade100,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submitOffer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _submitting
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text("TEKLİFİ GÖNDER", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: primaryBlue),
          ),
        ),
      ],
    );
  }
}
