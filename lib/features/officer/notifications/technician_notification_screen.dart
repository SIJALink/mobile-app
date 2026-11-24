
import 'package:material_ui/material_ui.dart';

class TechnicianNotificationScreen extends StatefulWidget {
  const TechnicianNotificationScreen({super.key});

  @override
  State<TechnicianNotificationScreen> createState() =>
      _TechnicianNotificationScreenState();
}

class _TechnicianNotificationScreenState
    extends State<TechnicianNotificationScreen> {
  String selectedFilter = 'Semua';

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Tugas Baru Ditugaskan',
      'message': 'Anda mendapatkan tugas perbaikan jaringan di Ruang Server.',
      'category': 'Tugas',
      'time': '10 menit yang lalu',
      'icon': Icons.assignment_rounded,
      'color': Colors.blue,
      'read': false,
    },
    {
      'title': 'Keluhan Baru Masuk',
      'message': 'Keluhan internet tidak terhubung membutuhkan penanganan.',
      'category': 'Keluhan',
      'time': '30 menit yang lalu',
      'icon': Icons.support_agent_rounded,
      'color': Colors.orange,
      'read': false,
    },
    {
      'title': 'Jadwal Maintenance',
      'message': 'Jadwal maintenance perangkat jaringan pukul 13.00 WIB.',
      'category': 'Jadwal',
      'time': '1 jam yang lalu',
      'icon': Icons.calendar_month_rounded,
      'color': Colors.purple,
      'read': true,
    },
    {
      'title': 'Tugas Berhasil Diselesaikan',
      'message': 'Pengecekan komputer Lab berhasil diselesaikan.',
      'category': 'Tugas',
      'time': '3 jam yang lalu',
      'icon': Icons.check_circle_rounded,
      'color': Colors.green,
      'read': true,
    },
    {
      'title': 'Update Status Keluhan',
      'message': 'Tiket keluhan SL-0024 telah diperbarui.',
      'category': 'Keluhan',
      'time': 'Kemarin',
      'icon': Icons.notifications_active_rounded,
      'color': Colors.teal,
      'read': true,
    },
  ];

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'Semua') return notifications;

    if (selectedFilter == 'Belum dibaca') {
      return notifications.where((n) => !n['read']).toList();
    }

    return notifications
        .where((n) => n['category'] == selectedFilter)
        .toList();
  }

  int get unreadCount =>
      notifications.where((n) => !n['read']).length;

  void markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['read'] = true;
    });
  }

  void markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification['read'] = true;
      }
    });
  }

  void deleteNotification(Map<String, dynamic> notification) {
    setState(() {
      notifications.remove(notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF244A7C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text(
                'Baca semua',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _filterBar(),
          Expanded(
            child: filteredNotifications.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _notificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterBar() {
    final filters = [
      'Semua',
      'Belum dibaca',
      'Tugas',
      'Keluhan',
      'Jadwal',
    ];

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final active = selectedFilter == filter;

          return Center(
            child: ChoiceChip(
              label: Text(filter),
              selected: active,
              onSelected: (_) {
                setState(() => selectedFilter = filter);
              },
              selectedColor: const Color(0xFF244A7C),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: active ? Colors.white : const Color(0xFF475569),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _notificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] as bool;
    final color = notification['color'] as Color;

    return Dismissible(
      key: ValueKey(notification['title']),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => deleteNotification(notification),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: InkWell(
        onTap: () => markAsRead(notification),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : const Color(0xFFEAF2FC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead
                  ? const Color(0xFFE8EDF4)
                  : const Color(0xFFBBD2F0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  notification['icon'] as IconData,
                  color: color,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontWeight: isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              fontSize: 13,
                              color: const Color(0xFF244A7C),
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4479C5),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification['message'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          notification['category'],
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('•',
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Text(
                          notification['time'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'Tidak ada notifikasi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF244A7C),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Notifikasi akan muncul di sini.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
