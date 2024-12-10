import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:podomoro_app/presentation/dashboard/detail_dashboard.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, String> timeSettings;
  final Function(Map<String, String>) onSettingsUpdated;

  const SettingsScreen({super.key, required this.timeSettings, required this.onSettingsUpdated});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<String, String> timeSettings;
  bool isLoading = true; // To handle the loading state

  @override
  void initState() {
    super.initState();
    timeSettings = Map.from(widget.timeSettings);
    _ensureValidSettings();
    _fetchDataFromFirestore();
  }

  // Ensure settings are valid
  void _ensureValidSettings() {
    const defaultOptions = ['05', '10', '15', '20', '25', '30'];
    timeSettings.forEach((key, value) {
      if (!defaultOptions.contains(value)) {
        timeSettings[key] = '25';
      }
    });
  }

  // Validate Firestore values against valid options
  String _validateTime(String value) {
    const defaultOptions = ['05', '10', '15', '20', '25', '30'];
    return defaultOptions.contains(value) ? value : '25';
  }

  // Fetch data from Firestore and update timeSettings
  Future<void> _fetchDataFromFirestore() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("pomodoroapp")
          .doc("5Z1axeBfpxb2CzviJYlu")
          .get();

      if (snapshot.exists) {
        final pomodoro = snapshot['pomodoro'];
        setState(() {
          timeSettings['Pomodoro'] = _validateTime(pomodoro['Pomodoro'].toString());
          timeSettings['Short Break'] = _validateTime(pomodoro['Short Break'].toString());
          timeSettings['Long Break'] = _validateTime(pomodoro['Long Break'].toString());
          isLoading = false; // Mark loading as complete
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false; // Mark loading as complete even if there's an error
      });
    }
  }

  // Save updated settings to Firestore
  Future<void> _updateDataToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection("pomodoroapp").doc("5Z1axeBfpxb2CzviJYlu").update({
        'pomodoro': {
          'Pomodoro': int.parse(timeSettings['Pomodoro']!),
          'Short Break': int.parse(timeSettings['Short Break']!),
          'Long Break': int.parse(timeSettings['Long Break']!),
        }
      });

      // Pass updated settings back to the parent screen
      widget.onSettingsUpdated(timeSettings);

      // Show a success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Settings saved successfully!")),
      );
    } catch (e) {
      print("Error saving settings: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save settings. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFD047FF),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'TIME (MINUTES)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _buildTimeSetting('Pomodoro'),
                  _buildTimeSetting('Short Break'),
                  _buildTimeSetting('Long Break'),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'ADVANCE SETTINGS',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailDashboard()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.dashboard,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'DASHBOARD',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: _fetchDataFromFirestore, // Add a Refresh button here
              //   child: const Text('Refresh Settings'),
              // ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _updateDataToFirestore,
                child: const Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the time setting widget for Pomodoro, Short Break, and Long Break
  Widget _buildTimeSetting(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white.withOpacity(0.2),
            ),
            width: 100,
            child: DropdownButton<String>(
              value: timeSettings[label], // Set value from `timeSettings`
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: const Color(0xFFD047FF),
              isExpanded: true,
              underline: Container(),
              items: ['01', '05', '10', '15', '20', '25', '30']
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Center(
                  child: Text(e, style: const TextStyle(color: Colors.white)),
                ),
              ))
                  .toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    timeSettings[label] = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
