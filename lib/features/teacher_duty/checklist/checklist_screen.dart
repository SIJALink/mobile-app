import 'package:material_ui/material_ui.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}


class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF244A7C)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (current != null && next != null) {
        canvas.drawLine(current, next, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  static const Color primary = Color(0xFF244A7C);
  static const Color background = Color(0xFFF4F7FB);

  final Map<int, String> statuses = {};
  final List<Offset?> signaturePoints = [];
bool signatureSaved = false;
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'A. Opening',
      'subtitle': 'Persiapan dan Pembukaan Kegiatan',
      'items': [
        'Mengumpulkan siswa petugas SIJALINK untuk briefing pagi pukul 07.00 WIB',
        'Memeriksa kehadiran dan kesesuaian jadwal piket siswa',
        'Memastikan kondisi kesehatan dan kesiapan fisik siswa sebelum bertugas',
        'Memastikan siswa sudah sarapan sebelum melaksanakan aktivitas',
        'Memastikan pembagian tugas dan kesiapan petugas Admin, NOC, dan Teknisi',
        'Memastikan siswa memahami pekerjaan dan target kegiatan hari ini',
        'Memastikan siswa membagikan live location kepada guru untuk setiap titik pekerjaan lapangan',
        'Memeriksa kesiapan alat, bahan, APD, dan perangkat kerja siswa SIJALINK',
        'Memberikan pengarahan dan mengingatkan penerapan K3',
        'Mengingatkan siswa untuk menjaga attitude, sopan santun, dan nama baik sekolah',
        'Mengingatkan siswa menggunakan bahasa yang baik, sopan, dan profesional',
        'Mengingatkan siswa agar tidak terpengaruh provokasi/aktivitas yang berpotensi memicu konflik atau tawuran; menjauh dan segera melapor',
        'Memeriksa jadwal tim pengajar dan petugas Kiddotics',
        'Memastikan kesiapan ruang pembelajaran Kiddotics',
        'Memastikan kesiapan perangkat, media, dan bahan pembelajaran Kiddotics',
        'Memastikan siswa/petugas pendamping Kiddotics memahami tugasnya',
      ],
    },
    {
      'title': 'B. Monitoring',
      'subtitle': 'Pengawasan dan Pendampingan Kegiatan',
      'items': [
        'Melaksanakan monitoring pertama ke lokasi/site pekerjaan SIJALINK',
        'Melaksanakan monitoring kedua ke lokasi/site pekerjaan SIJALINK',
        'Memastikan keberadaan dan posisi siswa sesuai informasi live location dan penugasan',
        'Memastikan siswa menerapkan K3 selama pekerjaan di lapangan',
      ],
    },
    {
      'title': 'C. Closing',
      'subtitle': 'Evaluasi dan Pengamanan Kegiatan',
      'items': [
        'Melakukan evaluasi kegiatan, kendala, dan kebutuhan pembelajaran berikutnya',
        'Memeriksa kondisi dan kelengkapan perangkat serta media pembelajaran',
        'Memastikan seluruh perangkat dan bahan pembelajaran dikembalikan ke tempat semula',
        'Memastikan ruang pembelajaran Kiddotics kembali bersih dan rapi',
        'Memastikan seluruh siswa Kiddotics telah meninggalkan lokasi dengan aman',
        'Memeriksa kebersihan dan kerapian seluruh ruang laboratorium SIJA',
        'Memastikan seluruh peralatan dan inventaris laboratorium tersimpan rapi',
        'Memastikan AC di setiap ruangan laboratorium telah dimatikan',
        'Memastikan lampu, komputer, monitor, dan perangkat elektronik yang tidak diperlukan telah dimatikan',
        'Memastikan server dan perangkat jaringan utama penunjang ISP tetap beroperasi',
        'Memastikan tidak ada siswa yang tertinggal di dalam ruang laboratorium',
        'Memastikan seluruh pintu dan ruang laboratorium terkunci dengan aman',
      ],
    },
  ];

  int get totalItems {
    return sections.fold<int>(
      0,
      (total, section) => total + (section['items'] as List).length,
    );
  }

  int get completedItems {
    return statuses.values.where((value) => value == 'done').length;
  }

  int get naItems {
    return statuses.values.where((value) => value == 'na').length;
  }

  int get checkedItems => completedItems + naItems;

  void updateStatus(int number, String? value) {
    setState(() {
      if (value == null) {
        statuses.remove(number);
      } else {
        statuses[number] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = totalItems == 0 ? 0.0 : checkedItems / totalItems;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Checklist Piket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          _progressHeader(progress),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                ..._buildSections(),
                _signatureCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressHeader(double progress) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Kegiatan Piket',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$checkedItems/$totalItems',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8DD8B5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$completedItems selesai • $naItems N/A • ${totalItems - checkedItems} belum dikerjakan',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSections() {
    final widgets = <Widget>[];
    int number = 0;

    for (final section in sections) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['title'],
                style: const TextStyle(
                  color: primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                section['subtitle'],
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );

      final items = section['items'] as List<String>;

      for (final item in items) {
        number++;

        widgets.add(
          _checklistItem(number, item),
        );
      }
    }

    return widgets;
  }

  Widget _checklistItem(int number, String title) {
    final status = statuses[number];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE7ECF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EFFB),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statusButton(
                  label: '✓ Selesai',
                  selected: status == 'done',
                  color: const Color(0xFF198754),
                  onTap: () => updateStatus(
                    number,
                    status == 'done' ? null : 'done',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _statusButton(
                  label: 'N/A',
                  selected: status == 'na',
                  color: const Color(0xFF64748B),
                  onTap: () => updateStatus(
                    number,
                    status == 'na' ? null : 'na',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusButton({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: selected ? Colors.white : color,
        backgroundColor: selected ? color : Colors.white,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(vertical: 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  
Widget _signatureCard() {
  final hasSignature = signaturePoints.any((point) => point != null);

  return Container(
    margin: const EdgeInsets.only(top: 20),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE7ECF2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.draw_rounded, color: primary, size: 26),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Paraf Guru Penanggung Jawab',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Silakan bubuhkan paraf menggunakan jari atau stylus.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 15),

        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFD),
            border: Border.all(color: const Color(0xFFD6DEE8)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  signatureSaved = false;
                  signaturePoints.add(details.localPosition);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  signatureSaved = false;
                  signaturePoints.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  signaturePoints.add(null);
                });
              },
              child: CustomPaint(
                painter: SignaturePainter(signaturePoints),
                size: Size.infinite,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: hasSignature
                    ? () {
                        setState(() {
                          signaturePoints.clear();
                          signatureSaved = false;
                        });
                      }
                    : null,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Hapus'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: hasSignature
                    ? () {
                        setState(() {
                          signatureSaved = true;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Paraf berhasil disimpan sementara.'),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan Paraf'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),

        if (signatureSaved) ...[
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 18),
              SizedBox(width: 6),
              Text(
                'Paraf berhasil disimpan',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 15),
        const Divider(),
        const Center(
          child: Text(
            'Guru Penanggung Jawab',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}

          
        
      
    
  }

