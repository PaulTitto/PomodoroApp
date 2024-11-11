import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool aboutEnabled = false; // This is for demonstration; you might replace it with another purpose if needed.

  // Map to store selected times for each setting
  Map<String, String> timeSettings = {
    'Pomodoro': '25',
    'Short Break': '05',
    'Long Break': '15',
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFFD047FF),
          borderRadius: BorderRadius.circular(30.0),
        ),
        width: 300,
        height: 450,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the modal/screen
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
              Center(
                child: Column(
                  children: [
                    _buildTimeSetting('Pomodoro'),
                    _buildTimeSetting('Short Break'),
                    _buildTimeSetting('Long Break'),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'ADVANCE SETTINGS',
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
          Text(label, style: TextStyle(color: Colors.white)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: 124.0,
            height: 40.0,
            child: DropdownButton<String>(
              value: timeSettings[label],
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Color(0xFFD047FF),
              items: ['05', '10', '15', '20', '25', '30']
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(color: Colors.white)),
                ),
              )
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
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.notifications, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Notifications",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: notificationsEnabled,
              activeColor: Color(0xFFD047FF),
              activeTrackColor: Colors.white,
              inactiveThumbColor: Colors.black,
              inactiveTrackColor: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "About",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: aboutEnabled,
              activeColor: Color(0xFFD047FF),
              activeTrackColor: Colors.white,
              inactiveThumbColor: Colors.black,
              inactiveTrackColor: Colors.white,
              onChanged: (bool value) {
                setState(() {
                  aboutEnabled = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
