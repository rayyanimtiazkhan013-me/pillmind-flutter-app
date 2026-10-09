import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/database_helper.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isAnalyzing = false;

  Future<void> _captureAndScan() async {
    setState(() => _isAnalyzing = true);

    await Future.delayed(const Duration(seconds: 2));

    final scannedMed = Medicine(
      name: "Ibuprofen",
      dosage: "400mg",
      time: "12:00 PM",
      totalPills: 20,
      threshold: 5,
    );

    await DatabaseHelper.instance.insertMedicine(scannedMed);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Extracted & Saved: ${scannedMed.name} ${scannedMed.dosage}")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Prescription"),
        backgroundColor: const Color(0xFF080810),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: const Center(
              child: Text("Camera Preview Box", style: TextStyle(color: Colors.white38)),
            ),
          ),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00F2FE), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          if (_isAnalyzing)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF00F2FE)),
                    SizedBox(height: 16),
                    Text("Gemini AI Reading Prescription...", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _isAnalyzing ? null : _captureAndScan,
        backgroundColor: const Color(0xFF00F2FE),
        child: const Icon(Icons.camera_sharp, color: Colors.black),
      ),
    );
  }
}
