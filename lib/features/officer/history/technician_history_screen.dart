
import 'package:material_ui/material_ui.dart';

class TechnicianHistoryScreen extends StatefulWidget {
  const TechnicianHistoryScreen({super.key});

  @override
  State<TechnicianHistoryScreen> createState() =>
      _TechnicianHistoryScreenState();
}

class _TechnicianHistoryScreenState extends State<TechnicianHistoryScreen> {
  final Color primary = const Color(0xFF244A7C);

  String selectedFilter = 'Semua';
  String searchQuery = '';

  final List<Map<String, dynamic>> history = [
    {
      'id': 'T-001',
      'title': 'Perbaikan Jaringan Internet',
      'category': 'Jaringan',
      'location': 'Lab Komputer 1',
      'date': '23 Nov 2026',
      'time': '09:00 - 10:30',
      'status': 'Selesai',
      'description':
          'Melakukan pengecekan koneksi jaringan, konfigurasi ulang perangkat, dan pengujian koneksi internet.',
      'result': 'Internet berhasil kembali normal.',
    },
    {
      'id': 'T-002',
      'title': 'Pengecekan Komputer Lab',
      'category': 'Hardware',
      'location': 'Lab Komputer 2',
      'date': '22 Nov 2026',
      'time': '10:00 - 11:15',
      'status': 'Selesai',
      'description':
          'Melakukan pemeriksaan komputer, kondisi hardware, serta pengecekan sistem operasi.',
      'result': 'Seluruh perangkat berfungsi dengan baik.',
    },
    {
      'id': 'T-003',
      'title': 'Instalasi Access Point',
      'category': 'Jaringan',
      'location': 'Ruang Kelas 11',
      'date': '22 Nov 2026',
      'time': '13:00 - 15:00',
      'status': 'Diproses',
      'description':
          'Melakukan pemasangan access point baru untuk memperluas jangkauan WiFi.',
      'result': 'Instalasi dan konfigurasi masih berlangsung.',
    },
    {
      'id': 'T-004',
      'title': 'Perbaikan Printer',
      'category': 'Perangkat',
      'location': 'Tata Usaha',
      'date': '21 Nov 2026',
      'time': '08:30 - 09:30',
      'status': 'Selesai',
      'description':
          'Pemeriksaan printer, pembersihan roller, dan pengujian proses pencetakan.',
      'result': 'Printer dapat digunakan kembali.',
    },
    {
      'id': 'T-005',
      'title': 'Pengecekan CCTV',
      'category': 'CCTV',
      'location': 'Koridor Gedung A',
      'date': '20 Nov 2026',
      'time': '14:00 - 14:45',
      'status': 'Menunggu',
      'description':
          'Pengecekan kamera CCTV yang tidak menampilkan gambar pada monitor.',
      'result': 'Menunggu pemeriksaan lanjutan.',
    },
  ];

  List<Map<String, dynamic>> get filteredHistory {
    return history.where((item) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          item['title'].toString().toLowerCase().contains(query) ||
          item['id'].toString().toLowerCase().contains(query) ||
          item['location'].toString().toLowerCase().contains(query) ||
          item['category'].toString().toLowerCase().contains(query);

      final matchesFilter =
          selectedFilter == 'Semua' || item['status'] == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Diproses':
        return Colors.blue;
      case 'Menunggu':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget summaryItem(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void showHistoryDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFF4F7FB),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  item['id'],
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _statusBadge(item['status']),
                    const SizedBox(width: 8),
                    _statusBadge(item['category'], color: primary),
                  ],
                ),
                const SizedBox(height: 20),
                _detailItem(Icons.location_on_outlined, 'Lokasi', item['location']),
                _detailItem(Icons.calendar_today_outlined, 'Tanggal', item['date']),
                _detailItem(Icons.access_time, 'Waktu', item['time']),
                const SizedBox(height: 12),
                _sectionTitle('Deskripsi Pekerjaan'),
                _whiteCard(item['description']),
                const SizedBox(height: 14),
                _sectionTitle('Hasil Pengerjaan'),
                _whiteCard(item['result']),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: BorderSide(color: primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Tutup Detail'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusBadge(String text, {Color? color}) {
    final badgeColor = color ?? getStatusColor(text);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _whiteCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(height: 1.5)),
    );
  }

  Widget historyCard(Map<String, dynamic> item) {
    final color = getStatusColor(item['status']);

    return GestureDetector(
      onTap: () => showHistoryDetail(item),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['id'],
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                _statusBadge(item['status']),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item['title'],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item['location'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  item['date'],
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  item['time'],
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statusBadge(item['category'], color: primary),
                Icon(Icons.chevron_right, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = history.length;
    final completed = history.where((e) => e['status'] == 'Selesai').length;
    final processing = history.where((e) => e['status'] == 'Diproses').length;
    final waiting = history.where((e) => e['status'] == 'Menunggu').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text('Riwayat Pekerjaan'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                summaryItem('Total', total, primary),
                const SizedBox(width: 8),
                summaryItem('Selesai', completed, Colors.green),
                const SizedBox(width: 8),
                summaryItem('Proses', processing + waiting, Colors.orange),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari pekerjaan, ID, lokasi...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Semua', 'Selesai', 'Diproses', 'Menunggu'].map((filter) {
                final active = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: active,
                    onSelected: (_) => setState(() => selectedFilter = filter),
                    selectedColor: primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: active ? Colors.white : Colors.black87,
                    ),
                    side: BorderSide(color: active ? primary : Colors.transparent),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredHistory.isEmpty
                ? const Center(child: Text('Riwayat tidak ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) =>
                        historyCard(filteredHistory[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
