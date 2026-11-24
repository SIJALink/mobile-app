import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class WorkDocumentationScreen extends StatefulWidget {
  final String taskId;
  final String taskTitle;

  const WorkDocumentationScreen({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  @override
  State<WorkDocumentationScreen> createState() =>
      _WorkDocumentationScreenState();
}

class _WorkDocumentationScreenState
    extends State<WorkDocumentationScreen> {
  final Color primary = const Color(0xFF244A7C);
  final Color background = const Color(0xFFF4F7FB);
  final ImagePicker picker = ImagePicker();

  final Map<String, List<XFile>> photos = {
    'Sebelum Pengerjaan': [],
    'Saat Pengerjaan': [],
    'Setelah Pengerjaan': [],
  };

  final List<XFile> videos = [];
  final Map<String, VideoPlayerController> videoControllers = {};

  final TextEditingController noteController = TextEditingController();

  int get totalPhotos =>
      photos.values.fold(0, (sum, list) => sum + list.length);

  Future<void> addPhotos(String category) async {
    final selected = await picker.pickMultiImage(
      imageQuality: 80,
    );

    if (selected.isEmpty) return;

    setState(() {
      photos[category]!.addAll(selected);
    });
  }

  Future<void> addVideo() async {
    final selected = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (selected == null) return;

    final controller = VideoPlayerController.file(
      File(selected.path),
    );

    videos.add(selected);
    videoControllers[selected.path] = controller;

    await controller.initialize();

    if (mounted) setState(() {});
  }

  void removePhoto(String category, int index) {
    setState(() {
      photos[category]!.removeAt(index);
    });
  }

  void removeVideo(int index) {
    final video = videos[index];
    videoControllers[video.path]?.dispose();
    videoControllers.remove(video.path);

    setState(() {
      videos.removeAt(index);
    });
  }

  void saveDocumentation() {
    if (totalPhotos == 0 && videos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan foto atau video dokumentasi terlebih dahulu.'),
        ),
      );
      return;
    }

    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dokumentasi berhasil disimpan sementara.'),
      ),
    );
  }

  @override
  void dispose() {
    noteController.dispose();

    for (final controller in videoControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dokumentasi Pekerjaan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _taskInfo(),
                const SizedBox(height: 16),

                // PHOTO DOCUMENTATION
                ...photos.entries.map(
                  (entry) => _photoSection(entry.key, entry.value),
                ),

                // VIDEO DOCUMENTATION
                _videoSection(),

                // NOTES
                _notesSection(),
              ],
            ),
          ),

          // SAVE BUTTON
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveDocumentation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Dokumentasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TASK INFO
  Widget _taskInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.taskId,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.taskTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.photo_library_outlined,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '$totalPhotos foto • ${videos.length} video',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PHOTO SECTION
  Widget _photoSection(String title, List<XFile> items) {
    IconData icon;

    if (title == 'Sebelum Pengerjaan') {
      icon = Icons.camera_alt_outlined;
    } else if (title == 'Saat Pengerjaan') {
      icon = Icons.build_outlined;
    } else {
      icon = Icons.check_circle_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '${items.length} foto',
                style: TextStyle(
                  color: primary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 32,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Belum ada foto',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return _photoItem(title, items[index], index);
              },
            ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => addPhotos(title),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Tambah Foto'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: BorderSide(color: primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PHOTO ITEM
  Widget _photoItem(String category, XFile file, int index) {
    return GestureDetector(
      onTap: () => _previewPhoto(category, index),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(file.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () => removePhoto(category, index),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PHOTO PREVIEW
  void _previewPhoto(String category, int index) {
    final file = photos[category]![index];

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            InteractiveViewer(
              child: Image.file(
                File(file.path),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // VIDEO SECTION
  Widget _videoSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.videocam_outlined, color: Color(0xFF244A7C)),
              SizedBox(width: 8),
              Text(
                'Video Dokumentasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (videos.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    size: 32,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Belum ada video',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            ...videos.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              final controller = videoControllers[file.path];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (controller != null &&
                        controller.value.isInitialized)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(controller),
                              IconButton(
                                iconSize: 42,
                                onPressed: () {
                                  setState(() {
                                    controller.value.isPlaying
                                        ? controller.pause()
                                        : controller.play();
                                  });
                                },
                                icon: Icon(
                                  controller.value.isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.movie_outlined,
                          color: Color(0xFF244A7C),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        IconButton(
                          onPressed: () => removeVideo(index),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: addVideo,
              icon: const Icon(Icons.video_call_outlined),
              label: const Text('Tambah Video'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: BorderSide(color: primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NOTES
  Widget _notesSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notes_outlined, color: Color(0xFF244A7C)),
              SizedBox(width: 8),
              Text(
                'Catatan Dokumentasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tambahkan keterangan dokumentasi...',
              filled: true,
              fillColor: background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}