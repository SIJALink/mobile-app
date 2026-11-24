
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CustomerQrScannerScreen extends StatefulWidget {
  const CustomerQrScannerScreen({super.key});

  @override
  State<CustomerQrScannerScreen> createState() =>
      _CustomerQrScannerScreenState();
}

class _CustomerQrScannerScreenState extends State<CustomerQrScannerScreen>
    with WidgetsBindingObserver {
  static const Color primary = Color(0xFF244A7C);
  static const Color background = Color(0xFFF4F7FB);

  final MobileScannerController scannerController =
      MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );

  bool isProcessing = false;
  bool isFlashOn = false;
  bool isCameraActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      isCameraActive = false;
      scannerController.stop();
    } else if (state == AppLifecycleState.resumed) {
      isCameraActive = true;

      if (!isProcessing) {
        scannerController.start();
      }
    }
  }

  // DETEKSI QR CODE
  void onDetect(BarcodeCapture capture) {
    if (isProcessing || !mounted) return;

    final barcode = capture.barcodes.firstOrNull;
    final token = barcode?.rawValue;

    if (token == null || token.trim().isEmpty) return;

    setState(() {
      isProcessing = true;
    });

    scannerController.stop();
    showVerificationDialog(token.trim());
  }

  // DIALOG HASIL SCAN
  Future<void> showVerificationDialog(String token) async {
    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          icon: const Icon(
            Icons.qr_code_scanner_rounded,
            color: primary,
            size: 42,
          ),
          title: const Text(
            'QR Code Berhasil Dipindai',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          content: const Text(
            'QR Code berhasil dibaca. Token selanjutnya perlu '
            'divalidasi melalui server untuk memastikan identitas petugas.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Scan Ulang'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (result == true) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CustomerQrTokenPreviewScreen(),
        ),
      );
    }

    if (!mounted) return;

    resetScanner();
  }

  // RESET SCANNER
  Future<void> resetScanner() async {
    if (!mounted) return;

    setState(() {
      isProcessing = false;
    });

    if (isCameraActive) {
      try {
        await scannerController.start();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kamera gagal dijalankan kembali.'),
          ),
        );
      }
    }
  }

  // FLASH
  Future<void> toggleFlash() async {
    try {
      await scannerController.toggleTorch();

      if (!mounted) return;

      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flash tidak dapat digunakan.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scannerController.dispose();
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
          'Verifikasi Petugas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: toggleFlash,
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
            ),
            tooltip: 'Flash',
          ),
        ],
      ),
      body: Column(
        children: [
          // CAMERA SCANNER
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF172E4F),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: scannerController,
                    onDetect: onDetect,
                    errorBuilder: (context, error) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Kamera tidak dapat diakses',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                error.errorDetails?.message ??
                                    'Periksa izin kamera perangkat.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // SCAN FRAME
                  IgnorePointer(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),

                  // INSTRUCTION
                  Positioned(
                    top: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Arahkan kamera ke QR Code petugas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  // LOADING
                  if (isProcessing)
                    Container(
                      color: Colors.black.withValues(alpha: 0.55),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // INFORMATION PANEL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: primary,
                  size: 38,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Verifikasi Identitas Petugas',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pindai QR Code yang ditampilkan petugas '
                  'untuk memastikan identitas dan statusnya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 18),

                // INFORMATION BOX
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: primary,
                        size: 19,
                      ),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Pastikan QR Code berasal dari aplikasi '
                          'resmi petugas SIJALink.',
                          style: TextStyle(
                            color: primary,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// HALAMAN PREVIEW SEMENTARA
// Akan diganti dengan halaman hasil validasi identitas dari API.

class CustomerQrTokenPreviewScreen extends StatelessWidget {
  const CustomerQrTokenPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF244A7C),
        foregroundColor: Colors.white,
        title: const Text('Hasil Pemindaian'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.qr_code_2,
                    size: 54,
                    color: Color(0xFF244A7C),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'QR Berhasil Dibaca',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF244A7C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'QR Code sudah berhasil dipindai. '
                    'Validasi identitas petugas belum tersedia '
                    'karena integrasi API belum dilakukan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3DF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Menunggu Integrasi API',
                      style: TextStyle(
                        color: Color(0xFFB7791F),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF244A7C),
                        side: const BorderSide(
                          color: Color(0xFF244A7C),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                      ),
                      child: const Text('Kembali ke Scanner'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
