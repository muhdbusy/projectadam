import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@smartfarming.com',
      query: 'subject=Support Request',
    );
    if (!await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '01156763762');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchVideo() async {
    final Uri videoUri = Uri.parse('https://www.youtube.com/watch?v=gjBFtoruO-I');
    if (!await canLaunchUrl(videoUri)) {
      await launchUrl(videoUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('🌱 Frequently Asked Questions'),
          const SizedBox(height: 10),
          _buildFAQ('How do I connect the sensors?', 'Go to the dashboard and ensure Wi-Fi is enabled.'),
          _buildFAQ('How do I turn on the pump?', 'Use the toggle switch in the actuator control card.'),
          _buildFAQ('What is RSSI?', 'RSSI measures signal strength in dBm.'),

          const SizedBox(height: 25),
          _buildSectionHeader('📞 Contact Support'),
          const SizedBox(height: 10),
          _buildCardTile(
            icon: Icons.email,
            title: 'Email Us',
            subtitle: 'support@smartfarming.com',
            onTap: _launchEmail,
          ),
          _buildCardTile(
            icon: Icons.phone,
            title: 'Call Us',
            subtitle: '+6011-5676 3762',
            onTap: _launchPhone,
          ),

          const SizedBox(height: 25),
          _buildSectionHeader('🎥 Video Tutorials'),
          const SizedBox(height: 10),
          _buildCardTile(
            icon: Icons.video_library,
            title: 'Watch Setup Tutorial',
            subtitle: 'Smart Farming System',
            onTap: _launchVideo,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline, color: Color(0xFF4CAF50)),
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(answer, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF4CAF50)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF388E3C),
      ),
    );
  }
}
