import 'package:material_ui/material_ui.dart';
import 'checklist_screen.dart';
import 'work_report_screen.dart' show WorkReportScreen;
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'Semua';

  final List<TaskItem> tasks = [
    TaskItem(
      id: 'T-001',
      title: 'Perbaikan Jaringan Internet',
      category: 'Gangguan Jaringan',
      location: 'Ruang Server • Gedung A',
      customer: 'Admin Sekolah',
      date: '23 November 2026',
      time: '09.00 WIB',
      priority: 'Tinggi',
      status: 'Menunggu',
      description:
          'Melakukan pemeriksaan koneksi jaringan internet, '
          'memeriksa perangkat router, dan memastikan koneksi '
          'kembali normal.',
    ),
    TaskItem(
      id: 'T-002',
      title: 'Pengecekan Komputer Lab',
      category: 'Maintenance',
      location: 'Lab Komputer • Gedung B',
      customer: 'Bagian Laboratorium',
      date: '23 November 2026',
      time: '10.30 WIB',
      priority: 'Normal',
      status: 'Diproses',
      description:
          'Melakukan pemeriksaan komputer laboratorium, '
          'memastikan perangkat dapat digunakan dan '
          'memeriksa koneksi jaringan setiap komputer.',
    ),
    TaskItem(
      id: 'T-003',
      title: 'Instalasi Access Point',
      category: 'Instalasi Perangkat',
      location: 'Ruang Guru • Gedung A',
      customer: 'Bagian Tata Usaha',
      date: '23 November 2026',
      time: '13.00 WIB',
      priority: 'Normal',
      status: 'Menunggu',
      description:
          'Melakukan pemasangan access point baru, '
          'konfigurasi SSID, pengaturan keamanan, '
          'dan pengujian konektivitas Wi-Fi.',
    ),
    TaskItem(
      id: 'T-004',
      title: 'Perbaikan Printer',
      category: 'Perbaikan Perangkat',
      location: 'Administrasi • Gedung C',
      customer: 'Staff Administrasi',
      date: '22 November 2026',
      time: '14.00 WIB',
      priority: 'Normal',
      status: 'Selesai',
      description:
          'Memeriksa printer yang mengalami gangguan, '
          'melakukan perbaikan, dan menguji pencetakan '
          'dokumen.',
    ),
  ];

  final List<String> filters = [
    'Semua',
    'Menunggu',
    'Diproses',
    'Selesai',
  ];

  List<TaskItem> get filteredTasks {
    return tasks.where((task) {
      final matchesFilter =
          selectedFilter == 'Semua' || task.status == selectedFilter;

      final query = searchController.text.toLowerCase();

      final matchesSearch = task.title.toLowerCase().contains(query) ||
          task.location.toLowerCase().contains(query) ||
          task.id.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int get waitingCount =>
      tasks.where((task) => task.status == 'Menunggu').length;

  int get processCount =>
      tasks.where((task) => task.status == 'Diproses').length;

  int get completedCount =>
      tasks.where((task) => task.status == 'Selesai').length;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        foregroundColor: const Color(0xFF244A7C),
        elevation: 0,
        title: const Text(
          'Tugas Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _summarySection(),
          _searchSection(),
          _filterSection(),
          Expanded(child: _taskList()),
        ],
      ),
    );
  }

  Widget _summarySection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF244A7C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(child: _summaryItem('Total', tasks.length.toString())),
          _divider(),
          Expanded(
            child: _summaryItem('Menunggu', waitingCount.toString()),
          ),
          _divider(),
          Expanded(
            child: _summaryItem('Diproses', processCount.toString()),
          ),
          _divider(),
          Expanded(
            child: _summaryItem('Selesai', completedCount.toString()),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 34,
      color: Colors.white24,
    );
  }

  Widget _searchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Cari tugas atau lokasi...',
          prefixIcon: const Icon(Icons.search_rounded),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _filterSection() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) {
              setState(() => selectedFilter = filter);
            },
            selectedColor: const Color(0xFF244A7C),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF244A7C)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _taskList() {
    final result = filteredTasks;

    if (result.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 55,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'Tugas tidak ditemukan',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Coba kata kunci atau filter lainnya.',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: result.length,
      itemBuilder: (context, index) {
        final task = result[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _taskCard(task),
        );
      },
    );
  }

  Widget _taskCard(TaskItem task) {
    final statusColor = _statusColor(task.status);
    final priorityColor = task.priority == 'Tinggi'
        ? const Color(0xFFE45D5D)
        : const Color(0xFF4479C5);

    return InkWell(
      onTap: () async {
        final changed = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(task: task),
          ),
        );

        if (changed == true && mounted) {
          setState(() {});
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                Text(
                  task.id,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _badge(task.status, statusColor),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF244A7C),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              task.category,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 14),
            _infoRow(Icons.location_on_outlined, task.location),
            const SizedBox(height: 7),
            _infoRow(Icons.calendar_today_rounded, task.date),
            const SizedBox(height: 7),
            _infoRow(Icons.access_time_rounded, task.time),
            const SizedBox(height: 13),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Prioritas ${task.priority}',
                    style: TextStyle(
                      fontSize: 10,
                      color: priorityColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Detail Tugas',
                  style: TextStyle(
                    color: Color(0xFF4479C5),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF4479C5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return const Color(0xFF32A879);
      case 'Diproses':
        return const Color(0xFF4479C5);
      default:
        return const Color(0xFFE49A43);
    }
  }
}

class TaskItem {
  final String id;
  final String title;
  final String category;
  final String location;
  final String customer;
  final String date;
  final String time;
  final String priority;
  String status;
  final String description;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.customer,
    required this.date,
    required this.time,
    required this.priority,
    required this.status,
    required this.description,
  });
}

class TaskDetailScreen extends StatefulWidget {
  final TaskItem task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool changed = false;

  Color get statusColor {
    switch (widget.task.status) {
      case 'Selesai':
        return const Color(0xFF32A879);
      case 'Diproses':
        return const Color(0xFF4479C5);
      default:
        return const Color(0xFFE49A43);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) {
    if (!didPop) {
      Navigator.pop(context, changed);
    }
  },
  child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF4F7FB),
          foregroundColor: const Color(0xFF244A7C),
          elevation: 0,
          title: const Text(
            'Detail Tugas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statusCard(task),
              const SizedBox(height: 18),
              _detailCard(task),
              const SizedBox(height: 18),
              _descriptionCard(task),
              const SizedBox(height: 18),
              
_customerCard(task),
const SizedBox(height: 18),

// CHECKLIST PENGERJAAN
SizedBox(
  width: double.infinity,
  height: 48,
  child: OutlinedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChecklistScreen(
            taskId: task.id,
            taskTitle: task.title,
          ),
        ),
      );
    },
    icon: const Icon(Icons.checklist_rounded),
    label: const Text('Checklist Pengerjaan'),
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF244A7C),
      side: const BorderSide(
        color: Color(0xFF244A7C),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  ),
),

const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  height: 48,
  child: OutlinedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkReportScreen(
            taskId: task.id,
            taskTitle: task.title,
          ),
        ),
      );
    },
    icon: const Icon(Icons.description_outlined),
    label: const Text('Laporan Pekerjaan'),
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF244A7C),
      side: const BorderSide(
        color: Color(0xFF244A7C),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  ),
),

const SizedBox(height: 24),
_actionButton(task),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard(TaskItem task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.id,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF244A7C),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              task.status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(TaskItem task) {
    return _whiteCard(
      title: 'Informasi Tugas',
      children: [
        _detailRow(Icons.category_outlined, 'Kategori', task.category),
        _detailRow(Icons.location_on_outlined, 'Lokasi', task.location),
        _detailRow(Icons.calendar_today_rounded, 'Tanggal', task.date),
        _detailRow(Icons.access_time_rounded, 'Waktu', task.time),
        _detailRow(Icons.flag_rounded, 'Prioritas', task.priority),
      ],
    );
  }

  Widget _descriptionCard(TaskItem task) {
    return _whiteCard(
      title: 'Deskripsi Pekerjaan',
      children: [
        Text(
          task.description,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _customerCard(TaskItem task) {
    return _whiteCard(
      title: 'Informasi Pelapor',
      children: [
        _detailRow(Icons.person_outline_rounded, 'Pelapor', task.customer),
      ],
    );
  }

  Widget _whiteCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF244A7C),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4479C5), size: 19),
          const SizedBox(width: 10),
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF718096),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF244A7C),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(TaskItem task) {
    String label;
    Color color;
    VoidCallback? action;

    if (task.status == 'Menunggu') {
      label = 'Mulai Pengerjaan';
      color = const Color(0xFF244A7C);
      action = () {
        setState(() {
          task.status = 'Diproses';
          changed = true;
        });
      };
    } else if (task.status == 'Diproses') {
      label = 'Selesaikan Tugas';
      color = const Color(0xFF32A879);
      action = () {
        setState(() {
          task.status = 'Selesai';
          changed = true;
        });
      };
    } else {
      label = 'Tugas Telah Selesai';
      color = const Color(0xFF94A3B8);
      action = null;
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: action == null
            ? null
            : () {
                action!();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      task.status == 'Selesai'
                          ? 'Tugas berhasil diselesaikan.'
                          : 'Status tugas diperbarui.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFE2E8F0),
          disabledForegroundColor: const Color(0xFF64748B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
