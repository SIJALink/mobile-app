
import 'package:material_ui/material_ui.dart';

class ChecklistScreen extends StatefulWidget {
  final String taskId;
  final String taskTitle;

  const ChecklistScreen({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final Color primary = const Color(0xFF244A7C);
  final Color background = const Color(0xFFF4F7FB);

  final Map<String, List<String>> checklistData = {
    'Pemeriksaan Awal': [
      'Memeriksa kondisi perangkat',
      'Memastikan sumber listrik tersedia',
      'Memeriksa kabel dan koneksi',
      'Mengidentifikasi penyebab masalah',
    ],
    'Proses Pengerjaan': [
      'Melakukan tindakan perbaikan',
      'Melakukan konfigurasi jika diperlukan',
      'Melakukan pengujian fungsi',
      'Memastikan perangkat berjalan normal',
    ],
    'Pemeriksaan Akhir': [
      'Memastikan masalah sudah teratasi',
      'Memastikan perangkat dapat digunakan',
      'Membersihkan area kerja',
      'Menginformasikan hasil pengerjaan',
    ],
  };

  late Map<String, List<bool>> checkedItems;

  @override
  void initState() {
    super.initState();

    checkedItems = {
      for (final section in checklistData.keys)
        section: List<bool>.filled(
          checklistData[section]!.length,
          false,
        ),
    };
  }

  int get totalItems =>
      checklistData.values.fold(0, (sum, items) => sum + items.length);

  int get completedItems =>
      checkedItems.values.fold(0, (sum, items) {
        return sum + items.where((value) => value).length;
      });

  double get progress => totalItems == 0 ? 0 : completedItems / totalItems;

  void saveChecklist() {
    if (completedItems < totalItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Checklist belum lengkap ($completedItems/$totalItems)',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checklist pengerjaan berhasil diselesaikan!'),
      ),
    );

    Navigator.pop(context, true);
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
          'Checklist Pengerjaan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.taskId,
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.taskTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress Checklist',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$completedItems/$totalItems',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 9,
                          backgroundColor: const Color(0xFFE4EAF1),
                          valueColor: AlwaysStoppedAnimation(primary),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toInt()}% selesai',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                ...checklistData.entries.map((section) {
                  final sectionItems = section.value;
                  final sectionChecks = checkedItems[section.key]!;

                  final sectionDone =
                      sectionChecks.where((value) => value).length;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  section.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                '$sectionDone/${sectionItems.length}',
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...List.generate(sectionItems.length, (index) {
                          return CheckboxListTile(
                            value: sectionChecks[index],
                            activeColor: primary,
                            controlAffinity:
                                ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            title: Text(
                              sectionItems[index],
                              style: TextStyle(
                                fontSize: 13,
                                color: sectionChecks[index]
                                    ? Colors.grey
                                    : Colors.black87,
                                decoration: sectionChecks[index]
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                sectionChecks[index] = value ?? false;
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

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
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveChecklist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Checklist',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
