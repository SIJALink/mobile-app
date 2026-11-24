class CustomerTicket {
  final String id;
  final String title;
  final String type;
  final String category;
  final String description;
  final String status;
  final String priority;
  final String date;
  final String location;
  final String technician;
  final String technicianPhone;

  const CustomerTicket({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.description,
    required this.status,
    required this.priority,
    required this.date,
    required this.location,
    required this.technician,
    required this.technicianPhone,
  });
}