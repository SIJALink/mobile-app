
import 'dart:io';
import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

class CustomerComplaintScreen extends StatefulWidget {
  const CustomerComplaintScreen({super.key});

  @override
  State<CustomerComplaintScreen> createState() =>
      _CustomerComplaintScreenState();
}

class _CustomerComplaintScreenState extends State<CustomerComplaintScreen> {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  String? selectedCategory;
  String selectedPriority = 'Normal';
  bool isSubmitting = false;

  final List<ComplaintAttachment> attachments = [];

  final categories = [
    'Internet / Jaringan',
    'WiFi',
    'Perangkat Hardware',
    'Software / Aplikasi',
    'Kabel / Koneksi',
    'Kelistrikan',
    'Lainnya',
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> pickPhotos() async {
    try {
      final remaining = 5 - attachments.length;
      if (remaining <= 0) {
        showMessage('Maksimal 5 media.');
        return;
      }

      final files = await picker.pickMultiImage(imageQuality: 80);
      if (files.isEmpty) return;

      setState(() {
        attachments.addAll(
          files.take(remaining).map(
            (file) => ComplaintAttachment(file: file, isVideo: false),
          ),
        );
      });

      if (files.length > remaining) {
        showMessage('Lampiran dibatasi maksimal 5 media.');
      }
    } catch (_) {
      showMessage('Gagal memilih foto.');
    }
  }

  Future<void> pickVideo() async {
    if (attachments.length >= 5) {
      showMessage('Maksimal 5 media.');
      return;
    }

    try {
      final file = await picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (file == null) return;

      setState(() {
        attachments.add(
          ComplaintAttachment(file: file, isVideo: true),
        );
      });
    } catch (_) {
      showMessage('Gagal memilih video.');
    }
  }

  void removeAttachment(int index) {
    setState(() => attachments.removeAt(index));
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> submitComplaint() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      showMessage('Pilih kategori keluhan terlebih dahulu.');
      return;
    }

    setState(() => isSubmitting = true);

    // Simulasi pengiriman laporan.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => isSubmitting = false);

    final ticketId =
        'KLM-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
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
              'Keluhan Berhasil Dikirim!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF244A7C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Laporan kamu berhasil dibuat. Petugas akan meninjau dan menindaklanjuti keluhan.',
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
                    ticketId,
                    style: const TextStyle(
                      fontSize: 19,
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
      ),
    );
  }

  Widget textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    IconData? icon,
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

  Widget dropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
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
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          items: options.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? 'Kategori wajib dipilih' : null,
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

  Widget attachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lampiran Foto / Video',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF244A7C),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tambahkan bukti masalah agar petugas lebih mudah melakukan pemeriksaan. Maksimal 5 media.',
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
            ...attachments.asMap().entries.map((entry) {
              final index = entry.key;
              final attachment = entry.value;

              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: attachment.isVideo
                        ? Container(
                            width: 95,
                            height: 95,
                            color: const Color(0xFFE8EFF8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.videocam_rounded,
                                  color: Color(0xFF244A7C),
                                  size: 30,
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    attachment.file.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Image.file(
                            File(attachment.file.path),
                            width: 95,
                            height: 95,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    right: 3,
                    top: 3,
                    child: GestureDetector(
                      onTap: () => removeAttachment(index),
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
            if (attachments.length < 5) ...[
              InkWell(
                onTap: pickPhotos,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFCBD5E1)),
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
              InkWell(
                onTap: pickVideo,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library_rounded,
                        color: Color(0xFF8B6CC1),
                        size: 26,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Tambah Video',
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
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${attachments.length}/5 media',
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
          'Buat Keluhan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
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
                        'Laporkan kendala layanan yang kamu alami. Petugas akan menerima laporan untuk ditindaklanjuti.',
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
              sectionTitle('Informasi Keluhan', 'Ceritakan masalah yang terjadi'),
              const SizedBox(height: 16),
              dropdownField(
                label: 'Kategori Keluhan *',
                hint: 'Pilih kategori masalah',
                value: selectedCategory,
                options: categories,
                onChanged: (value) => setState(() => selectedCategory = value),
              ),
              const SizedBox(height: 16),
              textField(
                label: 'Judul Keluhan *',
                hint: 'Contoh: WiFi tidak dapat digunakan',
                controller: titleController,
                icon: Icons.title_rounded,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Judul keluhan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              textField(
                label: 'Deskripsi Masalah *',
                hint: 'Jelaskan kendala yang dialami secara lengkap...',
                controller: descriptionController,
                maxLines: 5,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Deskripsi masalah wajib diisi';
                  }
                  if (v.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              textField(
                label: 'Lokasi Masalah *',
                hint: 'Contoh: Ruang guru, lantai 2',
                controller: locationController,
                icon: Icons.location_on_outlined,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Lokasi masalah wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Prioritas Keluhan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF244A7C),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Rendah', 'Normal', 'Tinggi'].map((priority) {
                  final selected = selectedPriority == priority;
                  Color color;

                  switch (priority) {
                    case 'Rendah':
                      color = const Color(0xFF32A879);
                      break;
                    case 'Tinggi':
                      color = const Color(0xFFE45D5D);
                      break;
                    default:
                      color = const Color(0xFFE49A43);
                  }

                  return ChoiceChip(
                    label: Text(priority),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => selectedPriority = priority);
                    },
                    selectedColor: color.withValues(alpha: 0.15),
                    labelStyle: TextStyle(
                      color: selected ? color : const Color(0xFF64748B),
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: selected ? color : const Color(0xFFE2E8F0),
                    ),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              attachmentSection(),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitComplaint,
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
                              'Kirim Keluhan',
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
                  style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
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

class ComplaintAttachment {
  final XFile file;
  final bool isVideo;

  ComplaintAttachment({
    required this.file,
    required this.isVideo,
  });
}
