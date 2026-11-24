
import 'package:material_ui/material_ui.dart';

class TechnicianScheduleScreen extends StatefulWidget {
  const TechnicianScheduleScreen({super.key});

  @override
  State<TechnicianScheduleScreen> createState() =>
      _TechnicianScheduleScreenState();
}

class _TechnicianScheduleScreenState
    extends State<TechnicianScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> schedules = [
    {
      'title': 'Perbaikan Jaringan',
      'location': 'Gedung A',
      'time': '08:00 - 10:00',
      'status': 'Menunggu',
      'description': 'Pemeriksaan dan perbaikan jaringan internet.'
    },
    {
      'title': 'Pengecekan Server',
      'location': 'Ruang Server',
      'time': '10:30 - 12:00',
      'status': 'Berlangsung',
      'description': 'Pengecekan kondisi server utama.'
    },
    {
      'title': 'Maintenance Perangkat',
      'location': 'Gedung B',
      'time': '13:00 - 15:00',
      'status': 'Selesai',
      'description': 'Maintenance perangkat jaringan.'
    },
  ];

  Color statusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Berlangsung':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Jadwal Teknisi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kalender Jadwal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2035),
                  onDateChanged: (date) {
                    setState(() => selectedDate = date);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Daftar Jadwal - ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...schedules.map((schedule) {
              final color = statusColor(schedule['status']);

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    schedule['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📍 ${schedule['location']}'),
                        Text('🕒 ${schedule['time']}'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            schedule['status'],
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(schedule['title']),
                        content: Text(
                          '${schedule['description']}\n\n'
                          'Lokasi: ${schedule['location']}\n'
                          'Waktu: ${schedule['time']}\n'
                          'Status: ${schedule['status']}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
