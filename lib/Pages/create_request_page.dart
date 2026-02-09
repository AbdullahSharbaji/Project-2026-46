import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project46/services/api_service.dart';
import 'package:project46/Pages/aktif_talepler.dart';
import 'package:flutter/foundation.dart';

class CreateRequestPage extends StatefulWidget {
  final int userId;
  const CreateRequestPage({super.key, required this.userId});

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  XFile? _image;
  List<dynamic> _categories = [];
  int? _selectedCategoryId;
  bool _loadingCategories = true;
  bool _submitting = false;

  final List<String> _preSavedAddresses = [
    "Ev: Kemalpaşa Mah. 7048. Sk. No:15, İzmir",
    "İş: Adalet Mah. Anadolu Cad. No:41, İzmir",
    "Diğer: Mevlana Mah. 1742. Sk. No:5, İzmir",
  ];
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await _apiService.getCategories();
    setState(() {
      _categories = cats;
      _loadingCategories = false;
    });
  }

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() {
        _image = selected;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir kategori seçin')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen sorunu açıklayın')),
      );
      return;
    }

    setState(() => _submitting = true);

    final success = await _apiService.createRequest(
      userId: widget.userId,
      categoryId: _selectedCategoryId!,
      description: _descriptionController.text.trim(),
      image: _image, // ✅ direkt XFile gönder
    );

    setState(() => _submitting = false);

    if (success) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AktifTalepler(userId: widget.userId),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Talep oluşturulurken bir hata oluştu')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talep Oluştur'),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Picker Section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  image: _image != null
                      ? DecorationImage(
                    image: FileImage(File(_image!.path)),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _image == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Fotoğraf Ekle', style: TextStyle(color: Colors.grey)),
                  ],
                )
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Category Picker
            const Text(
              'Kategori Seçin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _loadingCategories
                ? const Center(child: CircularProgressIndicator())
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedCategoryId,
                  hint: const Text('Kategori Seçiniz'),
                  isExpanded: true,
                  items: _categories.map((cat) {
                    return DropdownMenuItem<int>(
                      value: cat['id'],
                      child: Text(cat['name'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _selectedCategoryId = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pre-saved Address Selection
            const Text(
              'Adres Seçin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAddress,
                  hint: const Text('Kayıtlı Adresleriniz'),
                  isExpanded: true,
                  items: _preSavedAddresses.map((address) {
                    return DropdownMenuItem<String>(
                      value: address,
                      child: Text(address, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _selectedAddress = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description Section
            const Text(
              'Sorununuzu Açıklayın',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Ustayla paylaşmak istediğiniz detayları yazın...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _submitting ? null : _submitRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3C72),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _submitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                'TALEBİ GÖNDER',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
