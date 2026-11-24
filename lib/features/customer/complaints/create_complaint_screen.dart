
import 'package:material_ui/material_ui.dart';

class CreateComplaintScreen extends StatefulWidget {
  const CreateComplaintScreen({super.key});

  @override
  State<CreateComplaintScreen> createState() =>
      _CreateComplaintScreenState();
}

class _CreateComplaintScreenState extends State<CreateComplaintScreen> {
  final descriptionController = TextEditingController();

  String selectedType = 'Gangguan Internet';

  final complaintTypes = [
    'Gangguan Internet',
    'Gangguan Jaringan LAN',
    'Kerusakan Perangkat',
    'Gangguan WiFi',
    'Gangguan Instalasi',
    'Lainnya',
  ];

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void submitComplaint() {
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deskripsi pengaduan wajib diisi')),
      );
      return;
    }

    final now = DateTime.now();
    final id = 'TKT-${now.millisecondsSinceEpoch.toString().substring(7)}';

    Navigator.pop(context, {
      'id': id,
      'type': selectedType,
      'description': descriptionController.text.trim(),
      'date': '${now.day} ${_month(now.month)} ${now.year}',
      'status': 'Menunggu',
    });
  }

  String _month(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Buat Pengaduan'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporkan Gangguan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih jenis gangguan dan jelaskan masalah yang kamu alami.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 25),

            const Text(
              'Jenis Gangguan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: complaintTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedType = value);
                }
              },
            ),

            const SizedBox(height: 22),
            const Text(
              'Deskripsi Gangguan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Jelaskan gangguan yang kamu alami...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: submitComplaint,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Kirim Pengaduan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
