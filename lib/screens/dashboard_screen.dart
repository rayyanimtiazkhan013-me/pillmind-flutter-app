import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/database_helper.dart';
import 'scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Medicine> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getMedicines();
    if (data.isEmpty) {
      await DatabaseHelper.instance.insertMedicine(Medicine(
        name: "Amoxicillin",
        dosage: "500mg",
        time: "08:00 AM",
        totalPills: 14,
        threshold: 4,
      ));
      await DatabaseHelper.instance.insertMedicine(Medicine(
        name: "Omeprazole",
        dosage: "20mg",
        time: "08:00 PM",
        totalPills: 3,
        threshold: 5,
      ));
      _loadData();
      return;
    }
    setState(() {
      _medicines = data;
      _isLoading = false;
    });
  }

  Future<void> _takePill(Medicine med) async {
    if (med.id != null) {
      await DatabaseHelper.instance.decrementStock(med.id!, med.totalPills);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF080810),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.health_and_safety, color: Color(0xFF00F2FE)),
            SizedBox(width: 10),
            Text('PillMind AI', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Schedule & Inventory",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _medicines.length,
                      itemBuilder: (context, index) {
                        final med = _medicines[index];
                        final isLow = med.totalPills <= med.threshold;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF12121E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isLow ? Colors.redAccent.withOpacity(0.5) : Colors.white10,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    med.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${med.dosage} • ${med.time}",
                                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isLow ? Colors.red.withOpacity(0.1) : Colors.cyan.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "Stock: ${med.totalPills} left",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isLow ? Colors.redAccent : const Color(0xFF00F2FE),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => _takePill(med),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00F2FE),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Take 💊"),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScannerScreen()),
          ).then((_) => _loadData());
        },
        backgroundColor: const Color(0xFF00F2FE),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.camera_alt),
        label: const Text("Scan Prescription", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
