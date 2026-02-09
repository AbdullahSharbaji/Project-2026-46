import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project46/services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  final int userId;

  // ✅ ProfilePage'den dolu gelecek alanlar
  final String firstName;
  final String lastName;
  final String phone;
  final String? address;
  final String? profileImageUrl;

  const EditProfilePage({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.address,
    this.profileImageUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.firstName;
    _surnameController.text = widget.lastName;
    _phoneController.text = widget.phone;
    _addressController.text = widget.address ?? "";
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    if (_saving) return;

    final first = _nameController.text.trim();
    final last = _surnameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (first.isEmpty || last.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ad ve soyad alanlarını doldurun.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      // 1) Profil bilgilerini güncelle
      final ok = await _apiService.updateProfile(
        userId: widget.userId,
        firstName: first,
        lastName: last,
        phoneNumber: phone,
        address: address,
      );

      if (!ok) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil güncellenemedi (API hatası)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 2) Foto varsa upload et (opsiyonel)
      if (_image != null) {
        final url = await _apiService.uploadProfilePhoto(
          userId: widget.userId,
          imagePath: _image!.path,
        );

        if (url == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fotoğraf yüklenemedi'),
              backgroundColor: Colors.red,
            ),
          );
          // İstersen burada return yapıp sayfada kalabilir.
          // Şimdilik: sayfada kalalım ki kullanıcı tekrar denesin.
          return;
        }
      }

      // 3) Başarılı
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil başarıyla güncellendi!'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.pop(context, true); // ✅ ProfilePage refresh tetikler
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Profili Düzenle"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildProfileImage(),
              const SizedBox(height: 32),
              _buildTextField("Ad", _nameController, Icons.person),
              const SizedBox(height: 16),
              _buildTextField("Soyad", _surnameController, Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField(
                "Telefon Numarası",
                _phoneController,
                Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                "Adres",
                _addressController,
                Icons.location_on,
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3C72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: _saving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Kaydet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              color: Colors.grey.shade200,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: _image != null
                  ? Image.file(_image!, width: 120, height: 120, fit: BoxFit.cover)
                  : (widget.profileImageUrl != null && widget.profileImageUrl!.isNotEmpty)
                  ? Image.network(
                "http://37.140.242.178${widget.profileImageUrl}",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.person, size: 60, color: Colors.grey),
              )
                  : const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: _saving ? null : _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3C72),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
