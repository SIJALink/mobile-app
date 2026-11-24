
import 'dart:io';
import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

const Color chatPrimary = Color(0xFF244A7C);
const Color chatBg = Color(0xFFF4F7FB);

class CustomerChatScreen extends StatelessWidget {
  const CustomerChatScreen({super.key});

  final List<Map<String, dynamic>> conversations = const [
    {
      'name': 'Andi Pratama',
      'role': 'Teknisi',
      'ticket': 'SL-0024',
      'title': 'Gangguan Internet',
      'status': 'Dalam Proses',
      'lastMessage': 'Baik kak, saya sedang mengecek laporan...',
      'time': '14:35',
      'online': true,
      'avatar': 'A',
    },
    {
      'name': 'Budi Santoso',
      'role': 'Petugas',
      'ticket': 'SL-0022',
      'title': 'WiFi Tidak Stabil',
      'status': 'Menunggu Pelanggan',
      'lastMessage': 'Mohon konfirmasi apakah koneksi sudah normal?',
      'time': 'Kemarin',
      'online': false,
      'avatar': 'B',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatBg,
      appBar: AppBar(
        backgroundColor: chatPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chat Petugas', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Hubungi petugas layanan SIJALink',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.support_agent, color: chatPrimary, size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Layanan Bantuan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Chat dengan petugas atau teknisi yang menangani tiketmu.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final chat = conversations[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: chatPrimary.withValues(alpha:0.1),
                          child: Text(
                            chat['avatar'],
                            style: const TextStyle(
                              color: chatPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        if (chat['online'])
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          chat['time'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '${chat['ticket']} • ${chat['title']}',
                          style: const TextStyle(
                            color: chatPrimary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          chat['lastMessage'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: chatPrimary.withValues(alpha:0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            chat['status'],
                            style: const TextStyle(
                              color: chatPrimary,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomerChatDetailScreen(
                            conversation: chat,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> conversation;

  const CustomerChatDetailScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<CustomerChatDetailScreen> createState() =>
      _CustomerChatDetailScreenState();
}

class _CustomerChatDetailScreenState extends State<CustomerChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();

  late List<Map<String, dynamic>> messages;

  @override
  void initState() {
    super.initState();

    messages = [
      {
        'sender': 'petugas',
        'text': 'Halo kak, saya ${widget.conversation['name']}.',
        'image': null,
        'time': '14:20',
      },
      {
        'sender': 'petugas',
        'text':
            'Saya siap membantu terkait ${widget.conversation['title']}. Ada yang ingin disampaikan?',
        'image': null,
        'time': '14:21',
      },
      {
        'sender': 'customer',
        'text': 'Halo kak, internet di rumah saya masih belum stabil.',
        'image': null,
        'time': '14:25',
      },
      {
        'sender': 'petugas',
        'text': 'Baik kak, saya sedang mengecek laporan tersebut.',
        'image': null,
        'time': '14:35',
      },
    ];
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'customer',
        'text': text,
        'image': null,
        'time': currentTime(),
      });
    });

    messageController.clear();
    scrollToBottom();
  }

  String currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      messages.add({
        'sender': 'customer',
        'text': '',
        'image': picked.path,
        'time': currentTime(),
      });
    });

    scrollToBottom();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Widget buildMessage(Map<String, dynamic> message) {
    final isCustomer = message['sender'] == 'customer';
    final imagePath = message['image'];

    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCustomer ? chatPrimary : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(imagePath),
                  width: 220,
                  fit: BoxFit.cover,
                ),
              ),
            if (message['text'] != null &&
                message['text'].toString().isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message['text'],
                  style: TextStyle(
                    color: isCustomer ? Colors.white : Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message['time'],
                  style: TextStyle(
                    fontSize: 9,
                    color: isCustomer ? Colors.white70 : Colors.grey,
                  ),
                ),
                if (isCustomer) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 13, color: Colors.white70),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.conversation;

    return Scaffold(
      backgroundColor: chatBg,
      appBar: AppBar(
        backgroundColor: chatPrimary,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${chat['role']} • ${chat['ticket']}',
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.confirmation_number, color: chatPrimary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${chat['ticket']} - ${chat['title']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  chat['status'],
                  style: const TextStyle(fontSize: 10, color: chatPrimary),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) => buildMessage(messages[index]),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: sendImage,
                    icon: const Icon(Icons.attach_file, color: chatPrimary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        filled: true,
                        fillColor: chatBg,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    backgroundColor: chatPrimary,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
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
