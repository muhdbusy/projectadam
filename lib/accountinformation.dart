import 'package:flutter/material.dart';

class DeveloperProfilePage extends StatelessWidget {
  const DeveloperProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Developer Profile'),
        backgroundColor: const Color(0xFF4CAF50), // farming theme green
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with green background and curved bottom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/gadam.jpg'), // replace with real path
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Muhammad Adam Haziq',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'IoT | Embedded Systems | Automation',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InfoRow(
                    icon: Icons.school_outlined,
                    label: 'Class:',
                    value: '2nd Year, Diploma Electronic Engineering (IoT)',
                  ),
                  const InfoRow(
                    icon: Icons.cake_outlined,
                    label: 'Age:',
                    value: '19',
                  ),
                  const InfoRow(
                    icon: Icons.location_city_outlined,
                    label: 'Education:',
                    value: 'Kolej Kemahiran MARA Petaling Jaya',
                  ),

                  const SizedBox(height: 20),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '🌾 Background Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'A dedicated electronic engineering student with a strong interest in IoT, embedded systems, and automation. '
                                'Experienced in developing real-world projects using microcontrollers such as Arduino and ESP32, and proficient in C++, Flutter, and MySQL. '
                                'Passionate about designing intelligent systems that address practical challenges, with a long-term goal of contributing to the advancement of smart automation in areas such as smart farming and beyond.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green[700]),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$label ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
