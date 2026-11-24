import 'package:material_ui/material_ui.dart';

class CustomerServiceHistoryScreen extends StatefulWidget {
  const CustomerServiceHistoryScreen({super.key});

  @override
  State<CustomerServiceHistoryScreen> createState() =>
      _CustomerServiceHistoryScreenState();
}

class _CustomerServiceHistoryScreenState
    extends State<CustomerServiceHistoryScreen> {
  final Color primary = const Color(0xFF244A7C);
  final Color background = const Color(0xFFF4F7FB);

  String selectedFilter = 'Semua';
  String searchQuery = '';

  final List<Map<String, String>> history = [
    {
      'id': 'SL-0021',
      'title': 'Pemasangan jaringan internet',
      'type': 'Instalasi',
      'category': 'Instalasi Baru',
      'status': 'Selesai',
      'date': '18 Nov 2026',
      'technician': 'Budi Santoso',
      'location': 'Jl. Nanggewer, Cibinong',
      'description':
          'Pemasangan perangkat jaringan internet dan konfigurasi router telah selesai dilakukan.',
      'duration': '2 jam 30 menit',
    },
    {
      'id': 'SL-0019',
      'title': 'Perbaikan koneksi WiFi',
      'type': 'Keluhan',
      'category': 'WiFi',
      'status': 'Selesai',
      'date': '15 Nov 2026',
      'technician': 'Andi Pratama',
      'location': 'Jl. Raya Cibinong',
      'description':
          'Perbaikan koneksi WiFi yang tidak stabil dan pemeriksaan router.',
      'duration': '1 jam 15 menit',
    },
    {
      'id': 'SL-0017',
      'title': 'Penggantian kabel jaringan',
      'type': 'Keluhan',
      'category': 'Kabel/Koneksi',
      'status': 'Selesai',
      'date': '10 Nov 2026',
      'technician': 'Andi Pratama',
      'location': 'Jl. Sukahati, Cibinong',
      'description':
          'Penggantian kabel jaringan yang mengalami kerusakan dan pengecekan koneksi.',
      'duration': '1 jam',
    },
    {
      'id': 'SL-0015',
      'title': 'Permintaan instalasi dibatalkan',
      'type': 'Instalasi',
      'category': 'Instalasi Baru',
      'status': 'Dibatalkan',
      'date': '5 Nov 2026',
      'technician': '-',
      'location': 'Jl. Pabuaran, Cibinong',
      'description':
          'Pengajuan instalasi dibatalkan sebelum proses pengerjaan dilakukan.',
      'duration': '-',
    },
    {
      'id': 'SL-0012',
      'title': 'Pemeriksaan modem',
      'type': 'Keluhan',
      'category': 'Perangkat Hardware',
      'status': 'Selesai',
      'date': '1 Nov 2026',
      'technician': 'Budi Santoso',
      'location': 'Jl. Cibinong',
      'description':
          'Pemeriksaan perangkat modem dan penyesuaian konfigurasi jaringan.',
      'duration': '45 menit',
    },
  ];

  List<Map<String, String>> get filteredHistory {
    return history.where((item) {
      final filterMatch = selectedFilter == 'Semua' ||
          item['type'] == selectedFilter;

      final query = searchQuery.toLowerCase();

      final searchMatch =
          item['id']!.toLowerCase().contains(query) ||
          item['title']!.toLowerCase().contains(query) ||
          item['category']!.toLowerCase().contains(query);

      return filterMatch && searchMatch;
    }).toList();
  }

  int get completedCount =>
      history.where((item) => item['status'] == 'Selesai').length;

  int get cancelledCount =>
      history.where((item) => item['status'] == 'Dibatalkan').length;

  Color getStatusColor(String status) {
    if (status == 'Selesai') return const Color(0xFF27966A);
    if (status == 'Dibatalkan') return const Color(0xFFE06B75);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Riwayat Layanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Summary
          Container(
            color: primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
            child: Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    'Total Riwayat',
                    history.length.toString(),
                    Icons.history,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _summaryCard(
                    'Selesai',
                    completedCount.toString(),
                    Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _summaryCard(
                    'Dibatalkan',
                    cancelledCount.toString(),
                    Icons.cancel_outlined,
                  ),
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Cari riwayat layanan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Semua', 'Instalasi', 'Keluhan'].map((filter) {
                final active = selectedFilter == filter;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedFilter = filter);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: active ? primary : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: active ? primary : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          filter,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: active ? Colors.white : Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // History list
          Expanded(
            child: filteredHistory.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) {
                      return _historyCard(filteredHistory[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha:0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyCard(Map<String, String> item) {
    final status = item['status']!;
    final color = getStatusColor(status);
    final isInstallation = item['type'] == 'Instalasi';

    return GestureDetector(
      onTap: () => _showDetail(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isInstallation
                        ? Icons.router_outlined
                        : Icons.build_outlined,
                    color: primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['id']!,
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['date']!,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              item['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category_outlined,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 5),
                Text(
                  item['category']!,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200),
            Row(
              children: [
                Icon(Icons.engineering_outlined,
                    size: 15, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item['technician'] == '-'
                        ? 'Belum ada teknisi'
                        : item['technician']!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Text(
                  'Lihat detail',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Riwayat tidak ditemukan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Tidak ada layanan yang sesuai pencarian.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(Map<String, String> item) {
    final color = getStatusColor(item['status']!);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Detail Riwayat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _detailRow('Nomor Tiket', item['id']!),
                  _detailRow('Nama Layanan', item['title']!),
                  _detailRow('Jenis', item['type']!),
                  _detailRow('Kategori', item['category']!),
                  _detailRow('Tanggal', item['date']!),
                  _detailRow('Status', item['status']!, valueColor: color),
                  _detailRow('Teknisi', item['technician']!),
                  _detailRow('Durasi', item['duration']!),
                  _detailRow('Lokasi', item['location']!),
                  const SizedBox(height: 12),
                  const Text(
                    'Deskripsi Pengerjaan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description']!,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tutup Detail'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}