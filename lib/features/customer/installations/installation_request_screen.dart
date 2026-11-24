
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

class InstallationRequestScreen extends StatefulWidget {
  const InstallationRequestScreen({super.key});

  @override
  State<InstallationRequestScreen> createState() =>
      _InstallationRequestScreenState();
}

class _InstallationRequestScreenState
    extends State<InstallationRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final detailAddressController = TextEditingController();
  final descriptionController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final List<XFile> photos = [];

  String? selectedInstallation;
  String? selectedService;
  bool isSubmitting = false;

  final installationTypes = [
    'Instalasi Jaringan Internet',
    'Instalasi LAN',
    'Instalasi WiFi',
    'Instalasi CCTV',
    'Instalasi Perangkat',
    'Lainnya',
  ];

  final serviceOptions = [
    'Rumah',
    'Sekolah',
    'Kantor',
    'Gedung',
    'Area Umum',
    'Lainnya',
  ];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    detailAddressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickPhotos() async {
  try {
    final selected = await picker.pickMultiImage(
      imageQuality: 80,
    );

    if (selected.isEmpty) return;

    final remaining = 5 - photos.length;

    setState(() {
      photos.addAll(selected.take(remaining));
    });

    if (selected.length > remaining) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maksimal 5 foto lokasi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gagal memilih foto.')),
    );
  }
}

  void removePhoto(int index) {
    setState(() {
      photos.removeAt(index);
    });
  }

  String? validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return "$label wajib diisi";
    }
    return null;
  }

  Future<void> submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedInstallation == null || selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi jenis instalasi dan lokasi layanan.'),
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    // Simulasi proses pengiriman ke server.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => isSubmitting = false);

    final ticketNumber =
        'INS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F6EE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF32A879),
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pengajuan Berhasil!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF244A7C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pengajuan instalasi kamu berhasil dibuat. Simpan nomor tiket untuk melihat progres.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'NOMOR TIKET',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ticketNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF244A7C),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF244A7C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Kembali ke Dashboard'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF244A7C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon == null ? null : Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: Color(0xFF4479C5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF244A7C),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
            ),
          ),
          decoration: InputDecoration(
            prefixIcon: icon == null ? null : Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0),
              ),
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? 'Pilih salah satu opsi' : null,
        ),
      ],
    );
  }

  Widget sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF244A7C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget photoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Lokasi (Opsional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF244A7C),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tambahkan foto lokasi pemasangan agar petugas lebih mudah memahami kondisi lokasi.',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF718096),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...photos.asMap().entries.map((entry) {
              final index = entry.key;
              final photo = entry.value;

              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(photo.path),
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 3,
                    top: 3,
                    child: GestureDetector(
                      onTap: () => removePhoto(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            if (photos.length < 5)
              InkWell(
                onTap: pickPhotos,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Color(0xFF4479C5),
                        size: 26,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Tambah Foto',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${photos.length}/5 foto',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF244A7C),
        elevation: 0,
        title: const Text(
          'Pengajuan Instalasi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EFF8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF4479C5),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Isi formulir pengajuan instalasi dengan lengkap agar petugas dapat menindaklanjuti permintaan kamu.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF244A7C),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              sectionTitle(
                'Informasi Pelanggan',
                'Data pemohon layanan',
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: 'Nama Lengkap *',
                hint: 'Masukkan nama lengkap',
                controller: nameController,
                icon: Icons.person_outline_rounded,
                validator: (v) => validateRequired(v, 'Nama'),
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: 'Nomor Telepon *',
                hint: 'Contoh: 081234567890',
                controller: phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nomor telepon wajib diisi';
                  }
                  if (v.trim().length < 9) {
                    return 'Nomor telepon tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              sectionTitle(
                'Detail Instalasi',
                'Pilih jenis layanan yang dibutuhkan',
              ),
              const SizedBox(height: 16),
              buildDropdown(
                label: 'Jenis Instalasi *',
                hint: 'Pilih jenis instalasi',
                value: selectedInstallation,
                options: installationTypes,
                icon: Icons.build_rounded,
                onChanged: (value) {
                  setState(() => selectedInstallation = value);
                },
              ),
              const SizedBox(height: 16),
              buildDropdown(
                label: 'Lokasi Layanan *',
                hint: 'Pilih lokasi layanan',
                value: selectedService,
                options: serviceOptions,
                icon: Icons.business_outlined,
                onChanged: (value) {
                  setState(() => selectedService = value);
                },
              ),
              const SizedBox(height: 24),
              sectionTitle(
                'Alamat Pemasangan',
                'Lokasi instalasi akan dilakukan',
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: 'Alamat Lengkap *',
                hint: 'Nama jalan, nomor bangunan, RT/RW',
                controller: addressController,
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator: (v) => validateRequired(v, 'Alamat'),
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: 'Detail Lokasi',
                hint: 'Patokan lokasi, lantai, ruangan, dan lainnya',
                controller: detailAddressController,
                icon: Icons.place_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              sectionTitle(
                'Deskripsi Kebutuhan',
                'Jelaskan kebutuhan instalasi kamu',
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: 'Detail Permintaan *',
                hint: 'Contoh: membutuhkan pemasangan 2 titik WiFi di lantai 2...',
                controller: descriptionController,
                icon: Icons.description_outlined,
                maxLines: 5,
                validator: (v) => validateRequired(v, 'Deskripsi'),
              ),
              const SizedBox(height: 24),
              photoSection(),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF244A7C),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF94A3B8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Kirim Pengajuan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  '* Wajib diisi',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
