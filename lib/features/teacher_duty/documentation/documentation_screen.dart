
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

class DocumentationScreen extends StatefulWidget {
  const DocumentationScreen({super.key});

  @override
  State<DocumentationScreen> createState() =>
      _DocumentationScreenState();
}

class _DocumentationScreenState extends State<DocumentationScreen> {
  static const Color primary = Color(0xFF244A7C);
  static const Color background = Color(0xFFF4F7FB);

  final ImagePicker picker = ImagePicker();
  final List<XFile> photos = [];
  final List<XFile> videos = [];

  Future<void> takePhoto() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (file != null && mounted) {
      setState(() => photos.add(file));
    }
  }

  Future<void> choosePhoto() async {
    final List<XFile> files = await picker.pickMultiImage(
      imageQuality: 80,
    );

    if (mounted && files.isNotEmpty) {
      setState(() => photos.addAll(files));
    }
  }

  Future<void> recordVideo() async {
    final XFile? file = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 5),
    );

    if (file != null && mounted) {
      setState(() => videos.add(file));
    }
  }

  Future<void> chooseVideo() async {
    final XFile? file = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (file != null && mounted) {
      setState(() => videos.add(file));
    }
  }

  void removePhoto(int index) {
    setState(() => photos.removeAt(index));
  }

  void removeVideo(int index) {
    setState(() => videos.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Dokumentasi Piket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _introCard(),
          const SizedBox(height: 22),
          _sectionTitle('Tambah Dokumentasi'),
          const SizedBox(height: 12),
          _actionButton(
            icon: Icons.camera_alt_rounded,
            title: 'Ambil Foto',
            subtitle: 'Gunakan kamera perangkat',
            onTap: takePhoto,
          ),
          _actionButton(
            icon: Icons.photo_library_rounded,
            title: 'Pilih Foto',
            subtitle: 'Ambil foto dari galeri',
            onTap: choosePhoto,
          ),
          _actionButton(
            icon: Icons.videocam_rounded,
            title: 'Rekam Video',
            subtitle: 'Rekam kegiatan secara langsung',
            onTap: recordVideo,
          ),
          _actionButton(
            icon: Icons.video_library_rounded,
            title: 'Pilih Video',
            subtitle: 'Ambil video dari galeri',
            onTap: chooseVideo,
          ),
          const SizedBox(height: 24),
          _sectionTitle('Foto Dokumentasi (${photos.length})'),
          const SizedBox(height: 12),
          _photoGrid(),
          const SizedBox(height: 24),
          _sectionTitle('Video Dokumentasi (${videos.length})'),
          const SizedBox(height: 12),
          _videoList(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: photos.isEmpty && videos.isEmpty
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Dokumentasi tersimpan sementara di perangkat. '
                            'Upload ke server belum diaktifkan.',
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Simpan Dokumentasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _introCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.folder_copy_rounded,
            color: Colors.white,
            size: 35,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dokumentasi Kegiatan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Lampirkan foto dan video sebagai bukti pelaksanaan piket.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7ECF2)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE5EFFB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _photoGrid() {
    if (photos.isEmpty) {
      return _emptyState('Belum ada foto dokumentasi.');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
      ),
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(photos[index].path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => removePhoto(index),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _videoList() {
    if (videos.isEmpty) {
      return _emptyState('Belum ada video dokumentasi.');
    }

    return Column(
      children: List.generate(videos.length, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE7ECF2)),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.video_file_rounded,
              color: primary,
              size: 34,
            ),
            title: Text(
              videos[index].name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            subtitle: const Text('Video dokumentasi'),
            trailing: IconButton(
              onPressed: () => removeVideo(index),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _emptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE7ECF2)),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}
