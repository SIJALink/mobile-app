
import 'package:material_ui/material_ui.dart';
import 'report_store.dart';
import 'history_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const Color primary = Color(0xFF244A7C);
  static const Color background = Color(0xFFF4F7FB);

  final TextEditingController teacherController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final TextEditingController obstacleController = TextEditingController();
  final TextEditingController followUpController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    teacherController.dispose();
    activityController.dispose();
    obstacleController.dispose();
    followUpController.dispose();
    super.dispose();
  }

  String get formattedDate {
    const months = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember',
    ];

    return '${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}';
  }

  Future<void> chooseDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (result != null) {
      setState(() => selectedDate = result);
    }
  }

  void saveReport() {
    if (teacherController.text.trim().isEmpty ||
        activityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama guru dan kegiatan wajib diisi.'),
        ),
      );
      return;
    }

    ReportStore.addReport(
      date: selectedDate,
      teacher: teacherController.text.trim(),
      activity: activityController.text.trim(),
      obstacle: obstacleController.text.trim(),
      followUp: followUpController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan berhasil ditambahkan ke riwayat.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Laporan Harian',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Riwayat Piket',
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _headerCard(),
          const SizedBox(height: 18),

          _sectionCard(
            title: 'Informasi Piket',
            icon: Icons.info_outline_rounded,
            children: [
              _dateField(),
              const SizedBox(height: 15),
              _inputField(
                controller: teacherController,
                label: 'Nama Guru Penanggung Jawab',
                hint: 'Masukkan nama guru',
                icon: Icons.person_outline,
              ),
            ],
          ),

          const SizedBox(height: 16),

          _sectionCard(
            title: 'Ringkasan Kegiatan',
            icon: Icons.assignment_outlined,
            children: [
              _inputField(
                controller: activityController,
                label: 'Kegiatan yang Dilaksanakan',
                hint: 'Jelaskan kegiatan piket hari ini...',
                maxLines: 5,
              ),
              const SizedBox(height: 15),
              _inputField(
                controller: obstacleController,
                label: 'Kendala yang Ditemukan',
                hint: 'Tuliskan kendala selama kegiatan...',
                maxLines: 4,
              ),
              const SizedBox(height: 15),
              _inputField(
                controller: followUpController,
                label: 'Tindak Lanjut',
                hint: 'Tuliskan tindak lanjut atau solusi...',
                maxLines: 4,
              ),
            ],
          ),

          const SizedBox(height: 16),

          _sectionCard(
            title: 'Status Checklist',
            icon: Icons.checklist_rounded,
            children: const [
              Text(
                'Data checklist akan ditampilkan otomatis setelah halaman ini dihubungkan dengan Checklist Piket.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _sectionCard(
            title: 'Dokumentasi dan Paraf',
            icon: Icons.camera_alt_outlined,
            children: const [
              Text(
                'Foto, video, dan paraf akan ditampilkan di bagian ini setelah integrasi data selesai.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: saveReport,
              icon: const Icon(Icons.save_rounded),
              label: const Text(
                'Simpan Laporan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.description_rounded,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(height: 12),
          Text(
            'Laporan Kegiatan Piket',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Lengkapi laporan kegiatan Guru Piket setiap harinya.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE7ECF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primary, size: 21),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Piket',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: chooseDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDCE3EC)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: primary,
                ),
                const SizedBox(width: 10),
                Text(formattedDate),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon == null ? null : Icon(icon),
            alignLabelWithHint: true,
            filled: true,
            fillColor: const Color(0xFFFAFBFD),
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFDCE3EC),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFDCE3EC),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
