import 'package:material_ui/material_ui.dart';
import '../tickets/customer_ticket_model.dart';

class CustomerTrackingScreen extends StatefulWidget {
  const CustomerTrackingScreen({super.key});

  @override
  State<CustomerTrackingScreen> createState() =>
      _CustomerTrackingScreenState();
}

class _CustomerTrackingScreenState extends State<CustomerTrackingScreen> {
  final Color primary = const Color(0xFF244A7C);
  final Color background = const Color(0xFFF4F7FB);
  final TextEditingController searchController = TextEditingController();

  CustomerTicket? selectedTicket;
  bool searched = false;

  final List<CustomerTicket> dummyTickets = [
    const CustomerTicket(
      id: 'SL-0024',
      title: 'Internet tidak dapat terhubung',
      type: 'Keluhan',
      category: 'Internet/Jaringan',
      description: 'Internet tidak bisa digunakan sejak pagi.',
      status: 'Dalam Proses',
      priority: 'Tinggi',
      date: '23 Nov 2026',
      location: 'Jl. Raya Cibinong',
      technician: 'Andi Pratama',
      technicianPhone: '081234567890',
    ),
    const CustomerTicket(
      id: 'SL-0023',
      title: 'Permintaan pemasangan WiFi',
      type: 'Instalasi',
      category: 'Instalasi Baru',
      description: 'Pengajuan pemasangan jaringan internet baru.',
      status: 'Menunggu',
      priority: 'Normal',
      date: '22 Nov 2026',
      location: 'Jl. Pabuaran, Cibinong',
      technician: '-',
      technicianPhone: '-',
    ),
    const CustomerTicket(
      id: 'SL-0022',
      title: 'WiFi sering terputus',
      type: 'Keluhan',
      category: 'WiFi',
      description: 'Koneksi WiFi sering terputus pada malam hari.',
      status: 'Menunggu Pelanggan',
      priority: 'Normal',
      date: '20 Nov 2026',
      location: 'Jl. Sukahati, Cibinong',
      technician: 'Budi Santoso',
      technicianPhone: '081298765432',
    ),
    const CustomerTicket(
      id: 'SL-0021',
      title: 'Pemasangan jaringan selesai',
      type: 'Instalasi',
      category: 'Instalasi Baru',
      description: 'Pemasangan jaringan internet telah selesai.',
      status: 'Selesai',
      priority: 'Normal',
      date: '18 Nov 2026',
      location: 'Jl. Nanggewer, Cibinong',
      technician: 'Budi Santoso',
      technicianPhone: '081298765432',
    ),
  ];

  final List<String> steps = [
    'Tiket Diterima',
    'Teknisi Ditugaskan',
    'Pengerjaan',
    'Selesai',
  ];

  final List<String> stepDescriptions = [
    'Laporan telah diterima oleh sistem SIJALink.',
    'Teknisi telah ditugaskan untuk menangani layanan.',
    'Teknisi sedang melakukan pengecekan dan pengerjaan.',
    'Layanan telah selesai dan dapat digunakan.',
  ];

  int get progressStep {
    if (selectedTicket == null) return 0;

    switch (selectedTicket!.status) {
      case 'Menunggu':
        return 0;
      case 'Dalam Proses':
        return 2;
      case 'Menunggu Pelanggan':
        return 2;
      case 'Selesai':
        return 3;
      default:
        return 0;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
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

  void searchTicket() {
    final query = searchController.text.trim().toUpperCase();

    setState(() {
      searched = true;
      selectedTicket = dummyTickets.where((ticket) {
        return ticket.id.toUpperCase() == query;
      }).firstOrNull;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
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
          'Tracking Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lacak Layanan Kamu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkan nomor tiket untuk melihat progres layanan.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: searchController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Contoh: SL-0024',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => searchTicket(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: searchTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Lacak Tiket',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (!searched) _trackingEmptyState(),

            if (searched && selectedTicket == null)
              _notFoundState(),

            if (selectedTicket != null) ...[
              _trackingResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _trackingEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.track_changes_outlined,
            size: 65,
            color: primary.withValues(alpha:0.6),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tracking Layanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Masukkan nomor tiket kamu untuk mengetahui status layanan secara lengkap.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _notFoundState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off,
            size: 55,
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          const Text(
            'Tiket Tidak Ditemukan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Pastikan nomor tiket yang kamu masukkan sudah benar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _trackingResult() {
    final ticket = selectedTicket!;
    final color = getStatusColor(ticket.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.id,
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ticket.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ticket.status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              _infoRow('Jenis Layanan', ticket.type),
              _infoRow('Tanggal', ticket.date),
              _infoRow('Prioritas', ticket.priority),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Progress bar
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progress Layanan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: List.generate(steps.length, (index) {
                  final completed = index <= progressStep;

                  return Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                            color: completed
                                ? const Color(0xFF27966A)
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            completed ? Icons.check : Icons.circle,
                            size: completed ? 15 : 8,
                            color: Colors.white,
                          ),
                        ),
                        if (index != steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 3,
                              color: index < progressStep
                                  ? const Color(0xFF27966A)
                                  : Colors.grey.shade300,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(steps.length, (index) {
                  return Expanded(
                    child: Text(
                      steps[index],
                      textAlign: index == 0
                          ? TextAlign.left
                          : index == steps.length - 1
                              ? TextAlign.right
                              : TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: index <= progressStep
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: index <= progressStep
                            ? Colors.black87
                            : Colors.grey,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Timeline
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Riwayat Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(steps.length, (index) {
                final completed = index <= progressStep;
                final isLast = index == steps.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 26,
                      child: Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: completed
                                  ? const Color(0xFF27966A)
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              completed ? Icons.check : Icons.circle,
                              size: completed ? 14 : 7,
                              color: Colors.white,
                            ),
                          ),
                          if (!isLast)
                            Container(
                              height: 62,
                              width: 2,
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
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              steps[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: completed
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              stepDescriptions[index],
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (completed) ...[
                              const SizedBox(height: 5),
                              Text(
                                index == 0
                                    ? ticket.date
                                    : 'Update status simulasi',
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Technician information
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.engineering_outlined),
                  SizedBox(width: 10),
                  Text(
                    'Informasi Teknisi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (ticket.technician == '-')
                const Text(
                  'Teknisi belum ditugaskan.',
                  style: TextStyle(fontSize: 13),
                )
              else
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primary.withValues(alpha:0.1),
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
                            'Petugas SIJALink',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Location
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 10),
                  Text(
                    'Lokasi Layanan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                ticket.location,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
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
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}