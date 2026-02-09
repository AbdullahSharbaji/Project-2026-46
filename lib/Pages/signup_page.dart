import 'package:flutter/material.dart';
import 'package:project46/services/api_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final ApiService _api = ApiService();

  String? secilenSirketTuru;
  String? secilenKategori;

  final List<String> sirketTurleri = ["Şahıs Şirketi", "Limited (Ltd. Şti.)", "Anonim (A.Ş.)"];

  final List<String> kategoriler = [
    "Elektrikçi","Tesisatçı","Klima Tamiri","Beyaz Eşya","Marangoz","Boyacı",
    "Temizlik","Nakliyat","İlaçlama","Çilingir","Bilgisayar","Televizyon",
    "Bahçıvan","Havuz Bakımı","Çatı Tamiri"
  ];

  final _ad = TextEditingController();
  final _soyad = TextEditingController();
  final _dukkan = TextEditingController();
  final _vergi = TextEditingController();
  final _sirketAdi = TextEditingController();
  final _telefon = TextEditingController();
  final _sifre = TextEditingController();
  final _sifre2 = TextEditingController();

  bool _loading = false;

  Future<void> _register() async {
    if (_ad.text.trim().isEmpty ||
        _soyad.text.trim().isEmpty ||
        _dukkan.text.trim().isEmpty ||
        _vergi.text.trim().isEmpty ||
        _sirketAdi.text.trim().isEmpty ||
        _telefon.text.trim().isEmpty ||
        _sifre.text.trim().isEmpty ||
        _sifre2.text.trim().isEmpty ||
        secilenSirketTuru == null ||
        secilenKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    if (_sifre.text.trim() != _sifre2.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifreler eşleşmiyor")),
      );
      return;
    }

    setState(() => _loading = true);

    final ok = await _api.registerWorker(
      firstName: _ad.text.trim(),
      lastName: _soyad.text.trim(),
      shopName: _dukkan.text.trim(),
      taxNumber: _vergi.text.trim(),
      companyName: _sirketAdi.text.trim(),
      companyType: secilenSirketTuru!,
      category: secilenKategori!,
      phoneNumber: _telefon.text.trim(),
      password: _sifre.text.trim(),
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarılı! Giriş yapabilirsiniz."), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarısız (API)"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _ad.dispose();
    _soyad.dispose();
    _dukkan.dispose();
    _vergi.dispose();
    _sirketAdi.dispose();
    _telefon.dispose();
    _sifre.dispose();
    _sifre2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1E3C72);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Usta Kayıt"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _field("Ad", Icons.person, controller: _ad),
            _field("Soyad", Icons.person_outline, controller: _soyad),
            _field("Dükkan Adı", Icons.storefront, controller: _dukkan),
            _field("Vergi Numarası", Icons.description, controller: _vergi, isNumber: true),
            _field("Şirket İsmi", Icons.business, controller: _sirketAdi),

            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Şirket Türü",
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: sirketTurleri.map((tur) => DropdownMenuItem(value: tur, child: Text(tur))).toList(),
                onChanged: (val) => setState(() => secilenSirketTuru = val),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Hizmet Kategorisi",
                  prefixIcon: Icon(Icons.build_circle_outlined),
                ),
                hint: const Text("Şirket ne üzerine?"),
                items: kategoriler.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                onChanged: (val) => setState(() => secilenKategori = val),
              ),
            ),

            _field("Telefon Numarası", Icons.phone, controller: _telefon, isNumber: true),
            _field("Şifre", Icons.lock, controller: _sifre, isPassword: true),
            _field("Şifre Tekrar", Icons.lock_clock, controller: _sifre2, isPassword: true),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("KAYDI TAMAMLA"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      String label,
      IconData icon, {
        required TextEditingController controller,
        bool isPassword = false,
        bool isNumber = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
