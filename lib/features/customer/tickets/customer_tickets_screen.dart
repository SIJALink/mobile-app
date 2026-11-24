import 'package:material_ui/material_ui.dart';
import 'customer_ticket_model.dart';
import 'customer_ticket_detail_screen.dart';

class CustomerTicketsScreen extends StatefulWidget {
  const CustomerTicketsScreen({super.key});

  @override
  State<CustomerTicketsScreen> createState() =>
      _CustomerTicketsScreenState();
}

class _CustomerTicketsScreenState
    extends State<CustomerTicketsScreen> {
  final Color primary = const Color(0xFF244A7C);
  final Color background = const Color(0xFFF4F7FB);

  String selectedFilter = 'Semua';
  String searchQuery = '';

  final List<CustomerTicket> tickets = [
    const CustomerTicket(
      id: 'SL-0024',
      title: 'Internet tidak dapat terhubung',
      type: 'Keluhan',
      category: 'Internet/Jaringan',
      description:
          'Internet tidak bisa digunakan sejak pagi. Lampu indikator modem berkedip merah.',
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
      description:
          'Pengajuan pemasangan jaringan internet baru untuk rumah.',
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
      description:
          'Koneksi WiFi sering terputus terutama pada malam hari.',
      status: 'Menunggu',
      priority: 'Normal',
      date: '20 Nov 2026',
      location: 'Jl. Sukahati, Cibinong',
      technician: '-',
      technicianPhone: '-',
    ),
    const CustomerTicket(
      id: 'SL-0021',
      title: 'Pemasangan jaringan selesai',
      type: 'Instalasi',
      category: 'Instalasi Baru',
      description:
          'Pemasangan jaringan internet di lokasi pelanggan telah selesai.',
      status: 'Selesai',
      priority: 'Normal',
      date: '18 Nov 2026',
      location: 'Jl. Nanggewer, Cibinong',
      technician: 'Budi Santoso',
      technicianPhone: '081298765432',
    ),
  ];

  List<CustomerTicket> get filteredTickets {
    return tickets.where((ticket) {
      final matchesFilter = selectedFilter == 'Semua' ||
          ticket.type == selectedFilter;

      final matchesSearch =
          ticket.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          ticket.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
          ticket.category.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  Color statusColor(String status) {
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

  IconData ticketIcon(String type) {
    return type == 'Instalasi'
        ? Icons.router_outlined
        : Icons.report_problem_outlined;
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
          'Tiket Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: primary,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pantau semua layanan kamu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nomor atau nama tiket...',
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
              ],
            ),
          ),

          // Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            child: Row(
              children: ['Semua', 'Keluhan', 'Instalasi'].map((filter) {
                final active = selectedFilter == filter;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedFilter = filter);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
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
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: filteredTickets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tiket tidak ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Coba gunakan kata pencarian lain.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filteredTickets.length,
                    itemBuilder: (context, index) {
                      final ticket = filteredTickets[index];

                      return ticketCard(ticket);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget ticketCard(CustomerTicket ticket) {
    final color = statusColor(ticket.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerTicketDetailScreen(ticket: ticket),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
                    color: primary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(ticketIcon(ticket.type), color: primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.id,
                        style: TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket.date,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
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
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticket.status,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              ticket.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              ticket.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 15,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 5),
                Text(
                  ticket.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  'Detail',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}