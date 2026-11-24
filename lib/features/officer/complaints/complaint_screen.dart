
import 'package:material_ui/material_ui.dart';
import 'complaint_chat_screen.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final Color primary = const Color(0xFF244A7C);

  String selectedFilter = 'Semua';
  String searchQuery = '';

  final List<Map<String, dynamic>> complaints = [
    {
      'id': 'K-001',
      'title': 'Internet tidak dapat digunakan',
      'location': 'Lab Komputer 1',
      'category': 'Jaringan',
      'date': '23 Nov 2026',
      'status': 'Menunggu',
      'priority': 'Urgent',
      'description':
          'Koneksi internet di lab komputer tidak dapat digunakan oleh seluruh komputer.',
    },
    {
      'id': 'K-002',
      'title': 'Komputer tidak bisa menyala',
      'location': 'Ruang Guru',
      'category': 'Hardware',
      'date': '23 Nov 2026',
      'status': 'Diproses',
      'priority': 'Normal',
      'description':
          'Salah satu komputer di ruang guru tidak dapat menyala ketika tombol power ditekan.',
    },
    {
      'id': 'K-003',
      'title': 'WiFi tidak terdeteksi',
      'location': 'Ruang Kelas 11',
      'category': 'Jaringan',
      'date': '22 Nov 2026',
      'status': 'Menunggu',
      'priority': 'Normal',
      'description':
          'SSID WiFi sekolah tidak muncul pada beberapa perangkat siswa.',
    },
    {
      'id': 'K-004',
      'title': 'Printer mengalami paper jam',
      'location': 'Tata Usaha',
      'category': 'Perangkat',
      'date': '21 Nov 2026',
      'status': 'Selesai',
      'priority': 'Normal',
      'description':
          'Printer mengalami paper jam dan tidak dapat digunakan untuk mencetak dokumen.',
    },
  ];

  List<Map<String, dynamic>> get filteredComplaints {
    return complaints.where((complaint) {
      final matchesSearch =
          complaint['title'].toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
          complaint['id'].toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
          complaint['location'].toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              );

      final matchesFilter =
          selectedFilter == 'Semua' ||
          complaint['status'] == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Diproses':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color priorityColor(String priority) {
    return priority == 'Urgent' ? Colors.red : Colors.grey;
  }

  Widget summaryCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menunggu =
        complaints.where((e) => e['status'] == 'Menunggu').length;
    final diproses =
        complaints.where((e) => e['status'] == 'Diproses').length;
    final selesai =
        complaints.where((e) => e['status'] == 'Selesai').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Daftar Keluhan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // SUMMARY
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                summaryCard('Menunggu', menunggu, Colors.orange),
                const SizedBox(width: 10),
                summaryCard('Diproses', diproses, Colors.blue),
                const SizedBox(width: 10),
                summaryCard('Selesai', selesai, Colors.green),
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Cari keluhan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // FILTER
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Semua', 'Menunggu', 'Diproses', 'Selesai']
                  .map((filter) {
                final active = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: active,
                    onSelected: (_) {
                      setState(() => selectedFilter = filter);
                    },
                    selectedColor: primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: active ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: active ? primary : Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // COMPLAINT LIST
          Expanded(
            child: filteredComplaints.isEmpty
                ? const Center(
                    child: Text('Keluhan tidak ditemukan'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: filteredComplaints.length,
                    itemBuilder: (context, index) {
                      final complaint = filteredComplaints[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ComplaintDetailScreen(
                                complaint: complaint,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    complaint['id'],
                                    style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: priorityColor(
                                              complaint['priority'])
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      complaint['priority'],
                                      style: TextStyle(
                                        color: priorityColor(
                                            complaint['priority']),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                complaint['title'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    complaint['location'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    complaint['date'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    complaint['category'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor(
                                              complaint['status'])
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      complaint['status'],
                                      style: TextStyle(
                                        color: statusColor(
                                            complaint['status']),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

// DETAIL KELUHAN
class ComplaintDetailScreen extends StatelessWidget {
  final Map<String, dynamic> complaint;

  const ComplaintDetailScreen({
    super.key,
    required this.complaint,
  });

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF244A7C);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text('Detail Keluhan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complaint['id'],
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    complaint['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(complaint['description']),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _infoCard('Lokasi', complaint['location']),
            _infoCard('Kategori', complaint['category']),
            _infoCard('Tanggal', complaint['date']),
            _infoCard('Prioritas', complaint['priority']),
            _infoCard('Status', complaint['status']),
            const SizedBox(height: 20),
            
SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ComplaintChatScreen(
            complaintId: complaint['id'].toString(),
            complaintTitle: complaint['title'].toString(),
          ),
        ),
      );
    },
    icon: const Icon(Icons.chat_outlined),
    label: const Text('Chat Pelapor'),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF244A7C),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
