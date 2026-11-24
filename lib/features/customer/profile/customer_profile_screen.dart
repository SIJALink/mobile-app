
import 'dart:io';
import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  static const Color primary = Color(0xFF244A7C);
  static const Color background = Color(0xFFF4F7FB);

  bool isEditing = false;
  File? profileImage;

  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: 'Kharisma Maulidya');
  final customerIdController = TextEditingController(text: 'CUS-000124');
  final emailController = TextEditingController(text: 'kharisma@email.com');
  final phoneController = TextEditingController(text: '081234567890');
  final addressController = TextEditingController(text: 'Jl. Raya Cibinong No. 10');
  final provinceController = TextEditingController(text: 'Jawa Barat');
  final cityController = TextEditingController(text: 'Bogor');
  final districtController = TextEditingController(text: 'Cibinong');
  final postalCodeController = TextEditingController(text: '16911');

  late Map<String, String> originalData;

  @override
  void initState() {
    super.initState();
    originalData = getCurrentData();
  }

  Map<String, String> getCurrentData() {
    return {
      'name': nameController.text,
      'customerId': customerIdController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'province': provinceController.text,
      'city': cityController.text,
      'district': districtController.text,
      'postalCode': postalCodeController.text,
    };
  }

  void restoreData() {
    nameController.text = originalData['name'] ?? '';
    customerIdController.text = originalData['customerId'] ?? '';
    emailController.text = originalData['email'] ?? '';
    phoneController.text = originalData['phone'] ?? '';
    addressController.text = originalData['address'] ?? '';
    provinceController.text = originalData['province'] ?? '';
    cityController.text = originalData['city'] ?? '';
    districtController.text = originalData['district'] ?? '';
    postalCodeController.text = originalData['postalCode'] ?? '';
  }

  void cancelEdit() {
    restoreData();
    setState(() {
      isEditing = false;
    });
  }

  void saveProfile() {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      originalData = getCurrentData();
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> changePhoto() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null && mounted) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    customerIdController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    provinceController.dispose();
    cityController.dispose();
    districtController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget profileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: controller,
            enabled: isEditing,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, size: 20, color: primary),
              filled: true,
              fillColor: isEditing ? Colors.white : const Color(0xFFF7F9FC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }
    return null;
  }

  String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email wajib diisi';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
    return 'Format email tidak valid';
  }
  return null;
}

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    if (!RegExp(r'^[0-9+]{9,15}$').hasMatch(value.trim())) {
      return 'Nomor telepon tidak valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Profil Pelanggan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Profil',
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // PROFILE HEADER
            profileCard(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: primary.withValues(alpha: 0.1),
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: primary,
                              )
                            : null,
                      ),
                      if (isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: changePhoto,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nameController.text.isEmpty
                        ? 'Nama Pelanggan'
                        : nameController.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customerIdController.text,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Pelanggan Aktif',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // PERSONAL DATA
            profileCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Data Pribadi', Icons.person_outline),
                  profileField(
                    label: 'Nama Lengkap',
                    controller: nameController,
                    icon: Icons.person,
                    validator: requiredValidator,
                  ),
                  profileField(
                    label: 'ID Pelanggan',
                    controller: customerIdController,
                    icon: Icons.badge_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CONTACT
            profileCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(
                    'Informasi Kontak',
                    Icons.contact_phone_outlined,
                  ),
                  profileField(
                    label: 'Email',
                    controller: emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  profileField(
                    label: 'Nomor Telepon',
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: phoneValidator,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ADDRESS
            profileCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(
                    'Alamat Pelanggan',
                    Icons.location_on_outlined,
                  ),
                  profileField(
                    label: 'Alamat Lengkap',
                    controller: addressController,
                    icon: Icons.home_outlined,
                    maxLines: 2,
                    validator: requiredValidator,
                  ),
                  profileField(
                    label: 'Provinsi',
                    controller: provinceController,
                    icon: Icons.map_outlined,
                    validator: requiredValidator,
                  ),
                  profileField(
                    label: 'Kota / Kabupaten',
                    controller: cityController,
                    icon: Icons.location_city_outlined,
                    validator: requiredValidator,
                  ),
                  profileField(
                    label: 'Kecamatan',
                    controller: districtController,
                    icon: Icons.place_outlined,
                    validator: requiredValidator,
                  ),
                  profileField(
                    label: 'Kode Pos',
                    controller: postalCodeController,
                    icon: Icons.markunread_mailbox_outlined,
                    keyboardType: TextInputType.number,
                    validator: requiredValidator,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ACTION BUTTONS
            if (isEditing) ...[
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: saveProfile,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan Perubahan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: cancelEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
