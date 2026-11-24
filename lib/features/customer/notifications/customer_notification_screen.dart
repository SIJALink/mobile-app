import 'package:material_ui/material_ui.dart';

class CustomerNotificationScreen extends StatefulWidget {
  const CustomerNotificationScreen({super.key});

  @override
  State<CustomerNotificationScreen> createState() =>
      _CustomerNotificationScreenState();
}

class _CustomerNotificationScreenState
    extends State<CustomerNotificationScreen> {
  final Color primary = const Color(0xFF244A7C);
  final Color background = const Color(0xFFF4F7FB);

  String selectedFilter = 'Semua';

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Teknisi telah ditugaskan',
      'message':
          'Andi Pratama telah ditugaskan untuk menangani tiket SL-0024.',
      'ticket': 'SL-0024',
      'time': '10 menit yang lalu',
      'date': '24 Nov 2026',
      'type': 'Teknisi',
      'icon': Icons.engineering_outlined,
      'color': 0xFF2878C7,
      'read': false,
    },
    {
      'title': 'Tiket sedang dalam proses',
      'message':
          'Keluhan Internet tidak dapat terhubung sedang dikerjakan oleh teknisi.',
      'ticket': 'SL-0024',
      'time': '30 menit yang lalu',
      'date': '24 Nov 2026',
      'type': 'Status',
      'icon': Icons.sync_outlined,
      'color': 0xFF2878C7,
      'read': false,
    },
    {
      'title': 'Pengajuan instalasi diterima',
      'message':
          'Pengajuan pemasangan WiFi kamu berhasil diterima. Silakan pantau status tiket.',
      'ticket': 'SL-0023',
      'time': '2 jam yang lalu',
      'date': '24 Nov 2026',
      'type': 'Pengajuan',
      'icon': Icons.router_outlined,
      'color': 0xFF9B6AC8,
      'read': false,
    },
    {
      'title': 'Layanan berhasil diselesaikan',
      'message':
          'Pemasangan jaringan internet untuk tiket SL-0021 telah selesai.',
      'ticket': 'SL-0021',
      'time': '2 hari yang lalu',
      'date': '22 Nov 2026',
      'type': 'Selesai',
      'icon': Icons.check_circle_outline,
      'color': 0xFF27966A,
      'read': true,
    },
    {
      'title': 'Tiket berhasil dibuat',
      'message':
          'Keluhan WiFi sering terputus berhasil dikirim. Nomor tiket kamu SL-0022.',
      'ticket': 'SL-0022',
      'time': '4 hari yang lalu',
      'date': '20 Nov 2026',
      'type': 'Pengajuan',
      'icon': Icons.receipt_long_outlined,
      'color': 0xFFE49A36,
      'read': true,
    },
    {
      'title': 'Pengingat layanan',
      'message':
          'Pastikan lokasi pemasangan dapat diakses oleh teknisi pada jadwal kunjungan.',
      'ticket': 'SL-0023',
      'time': '5 hari yang lalu',
      'date': '19 Nov 2026',
      'type': 'Pengingat',
      'icon': Icons.notifications_active_outlined,
      'color': 0xFFE49A36,
      'read': true,
    },
  ];

  int get unreadCount =>
      notifications.where((item) => item['read'] == false).length;

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'Belum Dibaca') {
      return notifications.where((item) => item['read'] == false).toList();
    }
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (unreadCount > 0)
            IconButton(
              tooltip: 'Tandai semua dibaca',
              icon: const Icon(Icons.done_all),
              onPressed: markAllRead,
            ),
        ],
      ),
      body: Column(
        children: [
          // Header summary
          Container(
            color: primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifikasi kamu',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '$unreadCount notifikasi belum dibaca',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: ['Semua', 'Belum Dibaca'].map((filter) {
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
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Notification list
          Expanded(
            child: filteredNotifications.isEmpty
                ? emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final item = filteredNotifications[index];
                      return notificationCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget notificationCard(Map<String, dynamic> item) {
    final isRead = item['read'] as bool;
    final color = Color(item['color'] as int);

    return GestureDetector(
      onTap: () => openNotification(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFEAF2FB),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: isRead ? Colors.grey.shade200 : primary.withValues(alpha:0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(item['icon'] as IconData, color: color, size: 23),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isRead ? FontWeight.w600 : FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 9,
                          height: 9,
                          margin: const EdgeInsets.only(left: 5, top: 5),
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['message'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.confirmation_number_outlined,
                          size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 5),
                      Text(
                        item['ticket'] as String,
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item['time'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, color: Colors.grey.shade500, size: 20),
              onSelected: (value) {
                if (value == 'read') {
                  markRead(item);
                } else if (value == 'delete') {
                  deleteNotification(item);
                }
              },
              itemBuilder: (_) => [
                if (!isRead)
                  const PopupMenuItem(
                    value: 'read',
                    child: Row(
                      children: [
                        Icon(Icons.done, size: 18),
                        SizedBox(width: 10),
                        Text('Tandai dibaca'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Hapus'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selectedFilter == 'Belum Dibaca'
                  ? Icons.mark_email_read_outlined
                  : Icons.notifications_none,
              size: 65,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            Text(
              selectedFilter == 'Belum Dibaca'
                  ? 'Semua sudah dibaca'
                  : 'Belum ada notifikasi',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              selectedFilter == 'Belum Dibaca'
                  ? 'Tidak ada notifikasi yang belum dibaca.'
                  : 'Notifikasi layanan kamu akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void markRead(Map<String, dynamic> item) {
    setState(() {
      item['read'] = true;
    });
  }

  void markAllRead() {
    setState(() {
      for (final item in notifications) {
        item['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua notifikasi telah dibaca.')),
    );
  }

  void deleteNotification(Map<String, dynamic> item) {
    setState(() {
      notifications.remove(item);
    });
  }

  void openNotification(Map<String, dynamic> item) {
    setState(() {
      item['read'] = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final color = Color(item['color'] as int);

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha:0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item['icon'] as IconData, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  item['message'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.confirmation_number_outlined, size: 18),
                      const SizedBox(width: 10),
                      const Text('Nomor Tiket'),
                      const Spacer(),
                      Text(
                        item['ticket'] as String,
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 7),
                    Text(
                      '${item['date']} • ${item['time']}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}