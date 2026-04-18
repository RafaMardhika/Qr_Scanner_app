import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;
  bool _hasScanned = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_hasScanned || _isProcessing) return;
    final barcode = capture.barcodes.first;
    if (barcode.rawValue == null) return;

    setState(() { _isProcessing = true; _hasScanned = true; });
    cameraController.stop();

    final content = barcode.rawValue!;

    try {
      final result = await ApiService.scanQr(content);
      if (mounted) _showResult(result, content);
    } catch (e) {
      if (mounted) _showError();
    }

    setState(() { _isProcessing = false; });
  }

  void _showResult(Map<String, dynamic> result, String content) {
    final success = result['success'] == true;
    final message = result['message'] ?? 'Unknown response';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.cancel,
              color: success ? const Color(0xFF4ECCA3) : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              success ? 'Valid QR' : 'Invalid QR',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('Content:', style: TextStyle(color: Colors.white70,
              fontSize: 12)),
            Text(content, style: const TextStyle(color: Colors.white,
              fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() { _hasScanned = false; });
              cameraController.start();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECCA3)),
            child: const Text('Scan Again',
              style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showError() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Connection Error',
          style: TextStyle(color: Colors.white)),
        content: const Text('Cannot connect to server. Make sure Laravel is running.',
          style: TextStyle(color: Colors.grey)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() { _hasScanned = false; });
              cameraController.start();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECCA3)),
            child: const Text('Try Again',
              style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Scan QR Code',
          style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4ECCA3), width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF4ECCA3)),
              ),
            ),
          Positioned(
            bottom: 40,
            left: 0, right: 0,
            child: const Text(
              'Point camera at a QR code',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}