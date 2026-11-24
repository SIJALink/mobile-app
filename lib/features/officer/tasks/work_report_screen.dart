import 'package:material_ui/material_ui.dart';
import 'package:flutter/widgets.dart' as fw;
class WorkReportScreen extends StatefulWidget {
  final String taskId;
  final String taskTitle;

  const WorkReportScreen({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  @override
  State<WorkReportScreen> createState() => _WorkReportScreenState();
}

class _WorkReportScreenState extends State<WorkReportScreen> {
  final Color primary = const Color(0xFF244A7C);
  final Color background = const Color(0xFFF4F7FB);

  final TextEditingController summaryController = TextEditingController();
  final TextEditingController problemController = TextEditingController();
  final TextEditingController solutionController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String finalCondition = 'Berhasil diperbaiki';

  final List<String> conditions = [
    'Berhasil diperbaiki',
    'Selesai sebagian',
    'Belum terselesaikan',
    'Menunggu sparepart',
  ];

  bool get isComplete =>
    summaryController.text.trim().isNotEmpty &&
    problemController.text.trim().isNotEmpty &&
    solutionController.text.trim().isNotEmpty &&
    resultController.text.trim().isNotEmpty;

  void saveReport() {
    if (!isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi semua kolom wajib laporan terlebih dahulu.'),
        ),
      );
      return;
    }

    final report = {
      'taskId': widget.taskId,
      'taskTitle': widget.taskTitle,
      'summary': summaryController.text.trim(),
      'problem': problemController.text.trim(),
      'solution': solutionController.text.trim(),
      'result': resultController.text.trim(),
      'condition': finalCondition,
      'note': noteController.text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    Navigator.pop(context, report);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan pekerjaan berhasil disimpan sementara.'),
      ),
    );
  }

  @override
  void dispose() {
    summaryController.dispose();
    problemController.dispose();
    solutionController.dispose();
    resultController.dispose();
    noteController.dispose();
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
          'Laporan Pekerjaan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _taskCard(),
                const fw.SizedBox(height: 16),

                _section(
                  title: 'Ringkasan Pekerjaan',
                  subtitle: 'Jelaskan pekerjaan yang dilakukan teknisi.',
                  controller: summaryController,
                  hint: 'Contoh: Pemeriksaan dan perbaikan jaringan internet...',
                  icon: Icons.assignment_outlined,
                ),

                _section(
                  title: 'Kendala yang Ditemukan',
                  subtitle: 'Tuliskan masalah atau kendala selama pengerjaan.',
                  controller: problemController,
                  hint: 'Jelaskan kondisi awal dan kendala...',
                  icon: Icons.warning_amber_rounded,
                ),

                _section(
                  title: 'Tindakan Perbaikan',
                  subtitle: 'Jelaskan langkah perbaikan yang dilakukan.',
                  controller: solutionController,
                  hint: 'Tuliskan langkah-langkah penanganan...',
                  icon: Icons.build_outlined,
                ),

                _section(
                  title: 'Hasil Pengerjaan',
                  subtitle: 'Jelaskan hasil setelah pekerjaan dilakukan.',
                  controller: resultController,
                  hint: 'Contoh: Koneksi kembali normal dan perangkat berfungsi...',
                  icon: Icons.check_circle_outline,
                ),

                _conditionSection(),
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
            child: fw.SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Laporan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TASK CARD
  Widget _taskCard() {
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
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const fw.SizedBox(height: 8),
          Text(
            widget.taskTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const fw.SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.description_outlined,
                  color: Colors.white70, size: 18),
              fw.SizedBox(width: 6),
              Text(
                'Form laporan penyelesaian tugas',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TEXT SECTION
  Widget _section({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
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
              const fw.SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const fw.SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
          const fw.SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              alignLabelWithHint: true,
              filled: true,
              fillColor: background,
              contentPadding: const EdgeInsets.all(12),
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

  // CONDITION
  Widget _conditionSection() {
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
              Icon(Icons.fact_check_outlined, color: Color(0xFF244A7C)),
              fw.SizedBox(width: 8),
              Text(
                'Status Hasil Pekerjaan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const fw.SizedBox(height: 12),
          RadioGroup<String>(
  groupValue: finalCondition,
  onChanged: (value) {
    if (value != null) {
      setState(() => finalCondition = value);
    }
  },
  child: Column(
    children: conditions.map((condition) {
      return RadioListTile<String>(
        value: condition,
        activeColor: primary,
        contentPadding: EdgeInsets.zero,
        title: Text(
          condition,
          style: const TextStyle(fontSize: 13),
        ),
      );
    }).toList(),
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
              fw.SizedBox(width: 8),
              Text(
                'Catatan Tambahan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const fw.SizedBox(height: 12),
          TextField(
            controller: noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Catatan tambahan (opsional)...',
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
