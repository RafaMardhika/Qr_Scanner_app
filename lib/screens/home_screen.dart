import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/qr_model.dart';
import 'login_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QrModel> _qrList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQrList();
  }

  Future<void> _loadQrList() async {
    setState(() { _isLoading = true; });
    try {
      final data = await ApiService.getQrList();
      setState(() {
        _qrList = data.map((e) => QrModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
    setState(() { _isLoading = false; });
  }

  Future<void> _logout() async {
    await ApiService.clearToken();
    if (mounted) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('QR Scanner', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4ECCA3)),
            onPressed: _loadQrList,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF4ECCA3)))
        : _qrList.isEmpty
          ? const Center(child: Text('No QR codes found',
              style: TextStyle(color: Colors.grey)))
          : RefreshIndicator(
              onRefresh: _loadQrList,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _qrList.length,
                itemBuilder: (context, index) {
                  final qr = _qrList[index];
                  return Card(
                    color: const Color(0xFF16213E),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: qr.isActive
                          ? const Color(0xFF4ECCA3)
                          : Colors.grey,
                        child: const Icon(Icons.qr_code, color: Colors.black),
                      ),
                      title: Text(qr.title,
                        style: const TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold)),
                      subtitle: Text(qr.content,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: qr.isActive
                            ? const Color(0xFF4ECCA3).withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          qr.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: qr.isActive
                              ? const Color(0xFF4ECCA3)
                              : Colors.grey,
                            fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ScannerScreen()))
            .then((_) => _loadQrList()),
        backgroundColor: const Color(0xFF4ECCA3),
        icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
        label: const Text('Scan QR', style: TextStyle(color: Colors.black,
          fontWeight: FontWeight.bold)),
      ),
    );
  }
}