import 'package:material_ui/material_ui.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const Color primary = Color(0xFF244A7C);
  static const Color background = Color(0xFFF4F7FB);

  int selectedDay = DateTime.now().weekday - 1;

  final List<String> days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  // Data contoh untuk tampilan UI
  final Map<String, List<Map<String, String>>> schedules = {
    'Senin': [
      {
        'shift': 'Shift Pagi',
        'time': '06.30 - 13.00',
        'location': 'Gerbang Utama',
        'teachers': 'Guru 1, Guru 2',
      },
      {
        'shift': 'Shift Siang',
        'time': '13.00 - 17.00',
        'location': 'Area Sekolah',
        'teachers': 'Guru 3, Guru 4',
      },
    ],
    'Selasa': [
      {
        'shift': 'Shift Pagi',
        'time': '06.30 - 13.00',
        'location': 'Gerbang Utama',
        'teachers': 'Guru 1, Guru 2',
      },
      {
        'shift': 'Shift Siang',
        'time': '13.00 - 17.00',
        'location': 'Area Sekolah',
        'teachers': 'Guru 3, Guru 4',
      },
    ],
    'Rabu': [
      {
        'shift': 'Shift Pagi',
        'time': '06.30 - 13.00',
        'location': 'Gerbang Utama',
        'teachers': 'Guru 5, Guru 6',
      },
      {
        'shift': 'Shift Siang',
        'time': '13.00 - 17.00',
        'location': 'Area Sekolah',
        'teachers': 'Guru 7, Guru 8',
      },
    ],
    'Kamis': [
      {
        'shift': 'Shift Pagi',
        'time': '06.30 - 13.00',
        'location': 'Gerbang Utama',
        'teachers': 'Guru 1, Guru 3',
      },
      {
        'shift': 'Shift Siang',
        'time': '13.00 - 17.00',
        'location': 'Area Sekolah',
        'teachers': 'Guru 2, Guru 4',
      },
    ],
    'Jumat': [
      {
        'shift': 'Shift Pagi',
        'time': '06.30 - 11.30',
        'location': 'Gerbang Utama',
        'teachers': 'Guru 5, Guru 6',
      },
    ],
    'Sabtu': [
      {
        'shift': 'Shift Pagi',
        'time': '07.00 - 12.00',
        'location': 'Area Sekolah',
        'teachers': 'Guru 7, Guru 8',
      },
    ],
    'Minggu': [],
  };

  @override
  Widget build(BuildContext context) {
    final currentDay = days[selectedDay];
    final currentSchedules = schedules[currentDay] ?? [];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: const Text(
          'Jadwal Piket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _introCard(),
            const SizedBox(height: 24),
            const Text(
              'Pilih Hari',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            _daySelector(),
            const SizedBox(height: 24),
            Row(
              children: [
                 Expanded(
                  child: Text(
                    'Jadwal $currentDay',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${currentSchedules.length} Shift',
                  style: const TextStyle(
                    fontSize: 12,
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (currentSchedules.isEmpty)
              _emptySchedule()
            else
              ...currentSchedules.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _shiftCard(entry.value, entry.key),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _introCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.calendar_month_rounded,
              color: Colors.white, size: 30),
          SizedBox(height: 14),
          Text(
            'Jadwal Guru Piket',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Lihat pembagian jadwal, waktu, lokasi, dan guru yang bertugas.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _daySelector() {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
separatorBuilder: (_, _) => const SizedBox(width: 8),        itemBuilder: (context, index) {
          final isSelected = selectedDay == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? primary : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? primary
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                days[index],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _shiftCard(Map<String, String> schedule, int index) {
    final isMorning = index == 0;

    final shiftColor = isMorning
        ? const Color(0xFF2563EB)
        : const Color(0xFFEA580C);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: shiftColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isMorning
                      ? Icons.wb_sunny_rounded
                      : Icons.wb_twilight_rounded,
                  color: shiftColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule['shift'] ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      schedule['time'] ?? '-',
                      style: TextStyle(
                        color: shiftColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
                  color: const Color(0xFFEAF5ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Terjadwal',
                  style: TextStyle(
                    color: Color(0xFF24864B),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _detailRow(
            Icons.location_on_outlined,
            'Lokasi Piket',
            schedule['location'] ?? '-',
          ),
          const SizedBox(height: 12),
          _detailRow(
            Icons.people_alt_outlined,
            'Guru Bertugas',
            schedule['teachers'] ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptySchedule() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 45,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'Tidak ada jadwal piket',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            'Tidak terdapat jadwal piket pada hari ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
