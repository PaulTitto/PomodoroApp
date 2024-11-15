import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, String> timeSettings;
  final Function(Map<String, String>) onSettingsUpdated;

  const SettingsScreen({super.key, required this.timeSettings, required this.onSettingsUpdated});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool aboutEnabled = false;

  // Time settings data
  late Map<String, String> timeSettings;

  @override
  void initState() {
    super.initState();
    timeSettings = widget.timeSettings;
    _fetchDataFromFirestore();
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("pomodoroapp")
          .doc("5Z1axeBfpxb2CzviJYlu")
          .get();

      if (snapshot.exists) {
        setState(() {
          timeSettings['Pomodoro'] = snapshot['pomodoro']['pomodoro'].toString();
          timeSettings['Short Break'] = snapshot['pomodoro']['shortBreak'].toString();
          timeSettings['Long Break'] = snapshot['pomodoro']['longBreak'].toString();
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _updateData() async {
    try {
      await FirebaseFirestore.instance
          .collection("pomodoroapp")
          .doc("5Z1axeBfpxb2CzviJYlu")
          .update({
        'pomodoro': {
          'pomodoro': int.parse(timeSettings['Pomodoro']!),
          'shortBreak': int.parse(timeSettings['Short Break']!),
          'longBreak': int.parse(timeSettings['Long Break']!),
        }
      });
      // Pass updated settings back to HomeScreen
      widget.onSettingsUpdated(timeSettings);
      Navigator.pop(context); // Close the settings screen
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFFD047FF),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
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
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'TIME (MINUTES)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  _buildTimeSetting('Pomodoro'),
                  _buildTimeSetting('Short Break'),
                  _buildTimeSetting('Long Break'),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'ADVANCED SETTINGS',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  _buildNotificationToggle(),
                  _buildAboutOption(),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateData,
                child: Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              value: timeSettings[label],
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Color(0xFFD047FF),
              isExpanded: true,
              underline: Container(),
              items: ['05', '10', '15', '20', '25', '30']
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Center(child: Text(e, style: TextStyle(color: Colors.white))),
              ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  timeSettings[label] = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.notifications, color: Colors.white),
              SizedBox(width: 10),
              Text("Notifications", style: TextStyle(color: Colors.white)),
            ],
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: notificationsEnabled,
              activeColor: Color(0xFFD047FF),
              activeTrackColor: Colors.white,
              onChanged: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutOption() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 10),
                Text("More information about this app", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
