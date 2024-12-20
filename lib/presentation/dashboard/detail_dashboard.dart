import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailDashboard extends StatefulWidget {
  const DetailDashboard({super.key});

  @override
  State<DetailDashboard> createState() => _DetailDashboardState();
}

class _DetailDashboardState extends State<DetailDashboard> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  Future<void> _fetchDataFromFirebase() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("pomodoroapp")
          .doc("5Z1axeBfpxb2CzviJYlu")
          .get();

      if (snapshot.exists) {
        setState(() {
          dashboardData = snapshot.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No data found in Firestore!")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pomodoro Dashboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "All Time Completed: ${dashboardData!['all_result']} minutes",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),
            Text(
              "Pomodoro Duration: ${dashboardData!['pomodoro']['Pomodoro']} minutes",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Short Break Duration: ${dashboardData!['pomodoro']['Short Break']} minutes",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Long Break Duration: ${dashboardData!['pomodoro']['Long Break']} minutes",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // _buildTimeTable(),
          ],
        ),
      )
          : const Center(
        child: Text(
          "No data to display.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Widget _buildTimeTable() {
  //   final timeData = dashboardData!['time'] as Map<String, dynamic>;
  //
  //   return DataTable(
  //     columns: const [
  //       DataColumn(label: Text('Date')),
  //       DataColumn(label: Text('Minutes')),
  //     ],
  //     rows: timeData.entries.map((entry) {
  //       return DataRow(
  //         cells: [
  //           DataCell(Text(entry.key)), // Date
  //           DataCell(Text(entry.value.toString())), // Minutes
  //         ],
  //       );
  //     }).toList(),
  //   );
  // }
}
