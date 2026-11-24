import 'package:material_ui/material_ui.dart';
import 'customer_ticket_model.dart';

class CustomerTicketDetailScreen extends StatelessWidget {
  final CustomerTicket ticket;

  const CustomerTicketDetailScreen({
    super.key,
    required this.ticket,
  });

  final Color primary = const Color(0xFF244A7C);

  Color get statusColor {
    switch (ticket.status) {
      case 'Dalam Proses':
        return const Color(0xFF2878C7);
      case 'Selesai':
        return const Color(0xFF27966A);
      case 'Menunggu':
        return const Color(0xFFE49A36);
      case 'Menunggu Pelanggan':
        return const Color(0xFF9B6AC8);
      default:
        return Colors.grey;
    }
  }

  int get currentStep {
    switch (ticket.status) {
      case 'Menunggu':
        return 0;
      case 'Dalam Proses':
        return 1;
      case 'Menunggu Pelanggan':
        return 2;
      case 'Selesai':
        return 3;
      default:
        return 0;
    }
  }

  final List<String> timeline = const [
    'Tiket Dibuat',
    'Sedang Ditangani',
    'Pengecekan',
    'Selesai',
  ];

  final List<String> timelineDescriptions = const [
    'Tiket berhasil dibuat dan diterima sistem.',
    'Petugas sedang menangani laporan kamu.',
    'Petugas sedang melakukan pengecekan layanan.',
    'Layanan telah selesai dikerjakan.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Tiket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header tiket
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.id,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ticket.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ticket.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      ticket.date,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Timeline
          sectionCard(
            title: 'Tracking Pengerjaan',
            icon: Icons.timeline,
            child: Column(
              children: List.generate(timeline.length, (index) {
                final completed = index <= currentStep;
                final last = index == timeline.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 32,
                      child: Column(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: completed
                                  ? const Color(0xFF27966A)
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              completed
                                  ? Icons.check
                                  : Icons.circle_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                          if (!last)
                            Container(
                              width: 2,
                              height: 54,
                              color: completed
                                  ? const Color(0xFF27966A)
                                  : Colors.grey.shade300,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeline[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: completed
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              timelineDescriptions[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: completed
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Detail laporan
          sectionCard(
            title: 'Informasi Tiket',
            icon: Icons.description_outlined,
            child: Column(
              children: [
                infoRow('Jenis Layanan', ticket.type),
                infoRow('Kategori', ticket.category),
                infoRow('Prioritas', ticket.priority),
                infoRow('Tanggal Pengajuan', ticket.date),
                infoRow('Lokasi', ticket.location),
                const Divider(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Deskripsi',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ticket.description,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Teknisi
          sectionCard(
            title: 'Petugas Penanganan',
            icon: Icons.engineering_outlined,
            child: ticket.technician == '-'
                ? const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Teknisi belum ditugaskan untuk tiket ini.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: primary.withValues(alpha: 0.1),
                        child: Icon(Icons.person, color: primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.technician,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Teknisi SIJALink',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fitur kontak teknisi akan tersedia.',
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.chat_outlined, color: primary),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 20),

          // Chat tiket
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur chat tiket akan segera tersedia.'),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Chat Petugas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
              Icon(icon, color: primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}