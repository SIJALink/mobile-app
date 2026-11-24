
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ComplaintChatScreen extends StatefulWidget {
  final String complaintId;
  final String complaintTitle;

  const ComplaintChatScreen({
    super.key,
    required this.complaintId,
    required this.complaintTitle,
  });

  @override
  State<ComplaintChatScreen> createState() => _ComplaintChatScreenState();
}

class _ComplaintChatScreenState extends State<ComplaintChatScreen> {
  final Color primary = const Color(0xFF244A7C);
  final TextEditingController messageController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'pelapor',
      'text': 'Halo Pak, internet di lab masih belum bisa digunakan.',
      'type': 'text',
      'time': '14:05',
    },
    {
      'sender': 'teknisi',
      'text': 'Baik, saya sedang menuju lokasi untuk melakukan pengecekan.',
      'type': 'text',
      'time': '14:08',
    },
  ];

  void sendText() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'teknisi',
        'text': text,
        'type': 'text',
        'time': TimeOfDay.now().format(context),
      });

      messageController.clear();
    });
  }

  Future<void> sendImage() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null || !mounted) return;

    setState(() {
      messages.add({
        'sender': 'teknisi',
        'text': file.path,
        'type': 'image',
        'time': TimeOfDay.now().format(context),
      });
    });
  }

  Future<void> sendVideo() async {
    final XFile? file = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (file == null || !mounted) return;

    setState(() {
      messages.add({
        'sender': 'teknisi',
        'text': file.path,
        'type': 'video',
        'time': TimeOfDay.now().format(context),
      });
    });
  }

  void showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.image_outlined,
                    color: primary,
                  ),
                  title: const Text('Kirim Foto'),
                  onTap: () {
                    Navigator.pop(context);
                    sendImage();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.video_library_outlined,
                    color: primary,
                  ),
                  title: const Text('Kirim Video'),
                  onTap: () {
                    Navigator.pop(context);
                    sendVideo();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMessage(Map<String, dynamic> message) {
    final bool isTechnician = message['sender'] == 'teknisi';
    final String type = message['type'];

    return Align(
      alignment: isTechnician
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isTechnician ? primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (type == 'text')
              Text(
                message['text'],
                style: TextStyle(
                  color: isTechnician
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 14,
                ),
              )
            else if (type == 'image')
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePreviewPage(
                        path: message['text'],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(message['text']),
                    width: 230,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else if (type == 'video')
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPreviewPage(
                        path: message['text'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 230,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 55,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 5),

            Text(
              message['time'],
              style: TextStyle(
                color: isTechnician
                    ? Colors.white70
                    : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chat Pelapor',
              style: TextStyle(fontSize: 17),
            ),
            Text(
              widget.complaintId,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Text(
              widget.complaintTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    onPressed: showAttachmentMenu,
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: primary,
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        filled: true,
                        fillColor: const Color(0xFFF4F7FB),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  CircleAvatar(
                    backgroundColor: primary,
                    child: IconButton(
                      onPressed: sendText,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// HALAMAN PREVIEW FOTO

class ImagePreviewPage extends StatelessWidget {
  final String path;

  const ImagePreviewPage({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(
            File(path),
          ),
        ),
      ),
    );
  }
}

// HALAMAN PREVIEW VIDEO

class VideoPreviewPage extends StatefulWidget {
  final String path;

  const VideoPreviewPage({
    super.key,
    required this.path,
  });

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(
      File(widget.path),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
      floatingActionButton: controller.value.isInitialized
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF244A7C),
              onPressed: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                });
              },
              child: Icon(
                controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
