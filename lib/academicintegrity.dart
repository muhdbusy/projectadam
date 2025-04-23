import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcademicIntegrityPage extends StatelessWidget {
  const AcademicIntegrityPage({Key? key}) : super(key: key);

  final List<Map<String, String>> videoLinks = const [
    {
      'title': '5 Smart Irrigation Systems for Modern Day Farming',
      'url': 'https://www.youtube.com/watch?v=Ulf8E1XnhgI',
    },
    {
      'title': 'Flutter Basics by a REAL Project',
      'url': 'https://www.youtube.com/watch?v=D4nhaszNW4o',
    },
    {
      'title': 'RESPONSIVE DESIGN • Flutter Tutorial',
      'url': 'https://www.youtube.com/watch?v=MrPJBAOzKTQ',
    },
    {
      'title': 'Modern Login UI • Flutter Auth Tutorial',
      'url': 'https://www.youtube.com/watch?v=Dh-cTQJgM-Q',
    },
    {
      'title': 'Top 30 Flutter Tips and Tricks',
      'url': 'https://www.youtube.com/watch?v=5vDq5DXXxss',
    },
  ];

  Future<void> _launchYouTubeVideo(BuildContext context, String url) async {
    try {
      final Uri youtubeUri = Uri.parse(url);

      if (!await canLaunchUrl(youtubeUri)) {
        await launchUrl(
          youtubeUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch URL';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening video: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _launchYouTubeVideo(context, url),
            ),
          ),
        );
      }
      debugPrint('Launch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text("Academic Integrity"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.eco, size: 60, color: Colors.green[700]),
                  const SizedBox(height: 10),
                  const Text(
                    'Academic Integrity Resources',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Maintaining academic integrity is crucial in smart farming research. '
                    'Below are educational videos about proper citation, avoiding plagiarism, '
                    'and ethical research practices in agricultural technology.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
              child: Text(
                'Educational Videos:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            ...videoLinks.map((video) => _buildVideoCard(
              context: context,
              title: video['title']!,
              url: video['url']!,
            )),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Note: These external video links are provided for educational purposes only. '
                    'The content is the responsibility of their respective creators.',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard({
    required BuildContext context,
    required String title,
    required String url,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchYouTubeVideo(context, url),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.play_circle_fill, color: Colors.green[700], size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.green[700]),
            ],
          ),
        ),
      ),
    );
  }
}
